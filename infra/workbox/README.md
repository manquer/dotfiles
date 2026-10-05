# workbox hosts

Ansible for the Hetzner bare-metal boxes: hardening, SSH, Docker, firewall,
fail2ban, auditd, mosh, and the self-hosted GitHub Actions runner pools.

| Host (SSH alias) | Hostname | Role |
|---|---|---|
| `workbox` | `archlinux-latest-64-minimal` | dev box: devcontainers + runner pools `@1..N` |
| `workbox2` | `workbox-ci` | CI only: crusible `@101–120`, supergraph and webclients `@101–105` |

This repository is **public**. Hosts are SSH aliases only. Their addresses
live in the untracked `~/.namespace/ssh/personal-hosts.ssh`. Personal values
(your IP) go in the untracked `group_vars/all/local.yml`. Runner tokens never
pass through here.

`infra/` is in `.chezmoiignore`, so chezmoi never copies it into `$HOME`.

## Setup (once per machine)

```sh
cd ~/.local/share/chezmoi/infra/workbox
ansible-galaxy collection install -r requirements.yml -p collections
cp group_vars/all/local.yml.example group_vars/all/local.yml   # then set your IP
```

## Fresh box

1. **Verify the host keys** against the fingerprints in the Robot panel
   *before* trusting them:
   ```sh
   ssh-keyscan -t ed25519,ecdsa,rsa <ip> > /tmp/k && ssh-keygen -lf /tmp/k
   cat /tmp/k >> ~/.ssh/known_hosts
   ```
2. **Add an alias** to `~/.namespace/ssh/personal-hosts.ssh` (`HostName`,
   `User mani`, `IdentitiesOnly yes`), and add the host to `inventory.yml`.
3. **Bootstrap as root.** This creates the admin user with your key and
   passwordless sudo, then proves it can log in:
   ```sh
   ansible-playbook playbooks/bootstrap.yml -l <alias> -u root
   ```
4. **Converge.** This disables root login, so step 3 must have passed:
   ```sh
   ansible-playbook playbooks/site.yml -l <alias> --check --diff
   ansible-playbook playbooks/site.yml -l <alias>
   ```

## What `site.yml` does

| Role | What it does |
|---|---|
| `base` | zsh, git, rsync, jq, mosh, python-systemd; UTC; hostname; zsh login shell |
| `devsec.hardening.os_hardening` | sysctl, module blacklist, login.defs, permissions, suid cleanup. Overrides in `group_vars/all/main.yml` keep parity with workbox |
| `sshd` | workbox's hand-hardened `sshd_config` verbatim, plus an optional AcceptEnv drop-in |
| `docker` | Docker + buildx + compose; `daemon.json` compared as JSON (never restarts dockerd over whitespace); `ip_forward=1` |
| `firewall` | nftables `inet host` table: SSH and mosh UDP 60000–61000 in, everything else dropped, Docker-published ports unreachable from the WAN. Applied behind a 3-minute auto-rollback. Only where `firewall_enabled` |
| `fail2ban` | sshd jail (systemd backend, aggressive mode), bans in `inet f2b-table` |
| `auditd` | change-and-privilege audit rules; logs rotate 10 × 50 MB |
| `ci_runners` | runner pools on both hosts (`runners.yml`, tag `runners`) |

Every role has a tag of its own name, so `--tags fail2ban` re-applies just that one.

### Things that bite

- **Never put `flush ruleset` in `/etc/nftables.conf`.** It wipes the rules
  Docker writes through iptables-nft, and every container loses egress. The
  template owns one table and uses `destroy table`.
- **`ip_forward`**: os_hardening writes *and applies* `ip_forward=0`. On a
  running Docker host that cuts container egress at once (the workbox runner
  outage on 2026-09-14). `sysctl_overwrite` sets it to 1, and
  `99-zz-docker-forwarding.conf` backs that up.
- **auditd** ships `RefuseManualStop=yes`, which breaks os_hardening's restart
  handler on every run after the first. The `auditd` role adds a drop-in to
  allow the restart.
- **ansible output noise**: Arch's `80-systemd-osc-context.sh` makes Ansible
  warn "junk after the JSON data". It is harmless.

## Runner pools

Unit files come **from each repository's deploy checkout**, byte-identical to
what the repo ships. Only `pool.env` and the `User=` drop-in are written here,
which matches what each repo's `scripts/deploy.sh` generates.

**Rolling a merged ops change** (e.g. crusiblehq/app#6067):

1. Bump the ref in `group_vars/all/main.yml` (`crusible_deploy_ref`).
2. Pre-pull the image if the change re-pins it (`docker pull <image@digest>` on
   both hosts), so no runner start stalls on a ~17 GB pull.
3. Run `ansible-playbook playbooks/runners.yml --diff`. workbox moves its git
   checkout to the ref (refusing a dirty tree). Then workbox2 mirrors
   workbox's tree in the same run: Ansible's linear strategy finishes each
   task on every host before the next. Running runners pick up the change at
   their next job boundary.

Pools without a `deploy_ref` (supergraph and webclients today) are left at
whatever their checkout holds.

- **Who owns pool size.** On workbox, `crusible-pool-schedule.timer` and its
  hand-edited `/etc/crusible-runner/pool-schedule.env` own it
  (`runner_manage_instances: false`). On workbox2 the fixed `instances` lists
  in `group_vars/workbox_ci.yml` own it.
- **Instance numbers on a second host start at 101.** Runner names are
  `<pool>-runner-<N>`, and reusing workbox's numbers makes GitHub hand
  workbox's registrations over to the new box.
- **`reconcile.sh` needs `gh`**, authenticated by the `WATCHDOG_TOKEN` in
  `runner.env`. Without it the timer fails on every tick and nobody notices.
  The role installs `github-cli`.
- **workbox2 holds no GitHub credentials of its own.** Its checkouts,
  `secrets/runner.env` and the ghcr.io login are copied from
  `runner_source_host` (workbox), host to host, using a one-off key. That key
  is authorised `from="<source ip>",restrict` and revoked in an `always:`
  block. Temporary edits to workbox's `runner.env`, such as the
  `WATCHDOG_INTERVAL` override that is in place until the paginated watchdog
  image ships, therefore reach workbox2 on the next run.

```sh
ansible-playbook playbooks/runners.yml --diff                              # both hosts
ansible-playbook playbooks/runners.yml -l workbox2 -e runner_prune=true    # also stop unlisted instances
```

A changed `pool.env` reaches each runner at its next job boundary. Restart
`crusible-browser-pool` by hand if its capacity changed.

## workbox (dev) caveat

workbox has been fully under this playbook since 2026-10-05, but it runs live
devcontainers. **Run `--check --diff` against it before applying.**
`firewall_enabled` is off for it: its devcontainers publish ports to the
internet, so a firewall there needs planning first.

## Personal values

`group_vars/all/local.yml` (untracked) holds `fail2ban_ignoreip_extra`. Its
default lives in `roles/fail2ban/defaults`, **not** in `group_vars/all/main.yml`:
files in that directory load alphabetically, so a default in `main.yml` would
silently override `local.yml`. When your IP changes, update `local.yml` and run
`--tags fail2ban`.
