#!/usr/bin/env bash
# Cap every devpod container on this host: a CPU set and a memory limit, applied
# once to the running ones, then to each one that starts (rebuild or restart).
# `docker update` limits persist across a container's stop/start; a rebuild is a
# new container, so the start event covers it.
#
# Why (2026-10-31, workbox): five devpods had no limit. tsc, eslint and vitest
# inside them sized themselves to all 96 CPUs (tsc ran 132 threads), and they
# held ~188 GiB of RAM, so the host stalled at load1 900+ under the CI runners.
#
# A CPU SET, NOT A QUOTA: `nproc` and Go read the affinity mask, so tools see
# DEVPOD_CPUS. Each container takes the block of DEVPOD_CPUS that the fewest
# other devpods hold. A container that already has a set or a memory limit
# keeps it, so a hand-raised limit is never lowered here.
set -uo pipefail

CPUS="${DEVPOD_CPUS:-16}"
MEM="${DEVPOD_MEMORY:-48g}"
# devpods only use blocks below this CPU, so the top of the host stays runner-only
SPAN="${DEVPOD_CPU_SPAN:-80}"
LABEL="${DEVPOD_LABEL:-devpod.user}"
DOCKER="${DOCKER:-docker}"

log() { printf '[devpod-limits] %s\n' "$*"; }

limit() {
	local id="$1" name set mem slots b block
	# `|`-separated: CpusetCpus is empty for no set, which whitespace splitting drops
	IFS='|' read -r name set mem < <("$DOCKER" inspect -f '{{.Name}}|{{.HostConfig.CpusetCpus}}|{{.HostConfig.Memory}}' "$id" 2>/dev/null) || return 0
	name="${name#/}"
	if [[ -z "$set" ]]; then
		slots=$((SPAN / CPUS))
		local held=()
		for ((b = 0; b < slots; b++)); do held[b]=0; done
		while read -r s; do
			[[ "$s" =~ ^([0-9]+)-[0-9]+$ ]] || continue
			b=$((BASH_REMATCH[1] / CPUS))
			((b < slots)) && held[b]=$((held[b] + 1))
		done < <("$DOCKER" ps -q --filter "label=${LABEL}" | xargs -r "$DOCKER" inspect -f '{{.HostConfig.CpusetCpus}}' 2>/dev/null)
		block=0
		for ((b = 1; b < slots; b++)); do ((held[b] < held[block])) && block=$b; done
		set="$((block * CPUS))-$((block * CPUS + CPUS - 1))"
		"$DOCKER" update --cpuset-cpus "$set" "$id" >/dev/null && log "${name}: cpuset ${set}"
	fi
	if [[ "$mem" == "0" ]]; then
		# unlimited swap: a container over the cap swaps rather than being OOM-killed
		"$DOCKER" update --memory "$MEM" --memory-swap -1 "$id" >/dev/null && log "${name}: memory ${MEM}"
	fi
}

for id in $("$DOCKER" ps -q --filter "label=${LABEL}"); do limit "$id"; done
[[ "${1:-}" == "--once" ]] && exit 0
"$DOCKER" events --filter type=container --filter event=start --filter "label=${LABEL}" --format '{{.Actor.ID}}' |
	while read -r id; do limit "$id"; done
