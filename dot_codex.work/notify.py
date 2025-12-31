#!/usr/bin/env python3

import json
import subprocess
import sys
from typing import Any


BODY_CHAR_LIMIT: int = 100


def main() -> int:
    if len(sys.argv) != 2:
        print("Usage: notify.py <NOTIFICATION_JSON>")
        return 1

    try:
        notification = json.loads(sys.argv[1])
    except json.JSONDecodeError:
        return 1

    match notification_type := notification.get("type"):
        case "agent-turn-complete":
            hook_title = notification.get("hook-title")
            if not hook_title:
                hook = notification.get("hook")
                if isinstance(hook, dict):
                    hook_title_candidate = hook.get("title")
                    if isinstance(hook_title_candidate, str) and hook_title_candidate.strip():
                        hook_title = hook_title_candidate.strip()
            assistant_message = notification.get("last-assistant-message")
            if isinstance(assistant_message, str) and assistant_message.strip():
                hook_title = assistant_message.strip()
            if hook_title:
                title = f"Codex: {hook_title}"
            else:
                title = "Codex: Turn Complete!"
            input_messages = notification.get("input-messages", [])
            message = _build_notification_message(
                body=notification.get("body"),
                input_messages=input_messages,
            )
        case _:
            print(f"not sending a push notification for: {notification_type}")
            return 0

    thread_id = notification.get("thread-id", "")

    subprocess.check_output(
        [
            "terminal-notifier",
            "-title",
            title,
            "-message",
            message,
            "-group",
            "codex-" + thread_id,
            "-ignoreDnD",
            "-activate",
            "com.googlecode.iterm2",
        ]
    )

    return 0


def _build_notification_message(body: Any, input_messages: list[Any]) -> str:
    body_text = _extract_body_text(body=body, input_messages=input_messages)
    trimmed_body = body_text[:BODY_CHAR_LIMIT].strip()
    if trimmed_body:
        return trimmed_body
    return "No message provided."


def _extract_body_text(body: Any, input_messages: list[Any]) -> str:
    if isinstance(body, str) and body.strip():
        return body.strip()
    extracted_segments: list[str] = []
    for raw_message in input_messages:
        extracted_text = _extract_text(raw_message)
        if extracted_text:
            extracted_segments.append(extracted_text)
    return " ".join(extracted_segments).strip()


def _extract_text(raw_message: Any) -> str:
    if isinstance(raw_message, str):
        return _maybe_parse_json_string(raw_message)
    if isinstance(raw_message, dict):
        return _extract_text_from_dict(raw_message)
    if isinstance(raw_message, list):
        return " ".join(_extract_text(item) for item in raw_message if item is not None).strip()
    return str(raw_message).strip()


def _maybe_parse_json_string(raw_message: str) -> str:
    stripped_message = raw_message.strip()
    if not stripped_message:
        return ""
    try:
        parsed_message = json.loads(stripped_message)
    except json.JSONDecodeError:
        return stripped_message
    return _extract_text(parsed_message)


def _extract_text_from_dict(message_dict: dict[Any, Any]) -> str:
    for key in ("body", "content", "text", "message", "value"):
        value = message_dict.get(key)
        if isinstance(value, str) and value.strip():
            return value.strip()
        if isinstance(value, list):
            return " ".join(_extract_text(item) for item in value if item is not None).strip()
        if isinstance(value, dict):
            nested_text = _extract_text_from_dict(value)
            if nested_text:
                return nested_text
    return " ".join(
        _extract_text(value)
        for value in message_dict.values()
        if value is not None
    ).strip()


if __name__ == "__main__":
    sys.exit(main())
