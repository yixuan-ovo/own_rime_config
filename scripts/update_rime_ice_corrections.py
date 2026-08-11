#!/usr/bin/env python3
"""Extract rime-ice corrector rules into a Rime dictionary.

The generated file serves two purposes:
1. its entries make candidates available under the commonly mistyped reading;
2. lua/corrector.lua reads the fourth column and displays the correction.
"""

from __future__ import annotations

import argparse
import re
from pathlib import Path


RULE_PATTERN = re.compile(
    r'\["([^"]+)"\]\s*=\s*\{\s*text\s*=\s*"([^"]+)",'
    r'\s*comment\s*=\s*"([^"]+)"\s*\}'
)


def read_existing_keys(path: Path | None) -> set[tuple[str, str]]:
    if path is None:
        return set()

    keys: set[tuple[str, str]] = set()
    in_body = False
    for raw_line in path.read_text(encoding="utf-8-sig").splitlines():
        line = raw_line.strip()
        if not in_body:
            in_body = line == "..."
            continue
        if not line or line.startswith("#"):
            continue
        columns = raw_line.split("\t")
        if len(columns) >= 2:
            keys.add((columns[0], columns[1]))
    return keys


def extract_rules(source: Path) -> list[tuple[str, str, str]]:
    rules = [
        (text, wrong_code, comment)
        for wrong_code, text, comment in RULE_PATTERN.findall(
            source.read_text(encoding="utf-8")
        )
    ]
    if not rules:
        raise ValueError(f"No correction rules found in {source}")
    if len(rules) != len(set(rules)):
        raise ValueError(f"Duplicate correction rules found in {source}")
    return rules


def render(
    rules: list[tuple[str, str, str]],
    excluded_keys: set[tuple[str, str]],
    version: str,
) -> str:
    rows = [rule for rule in rules if (rule[0], rule[1]) not in excluded_keys]
    header = [
        "# Rime dictionary",
        "# encoding: utf-8",
        "#",
        "# Generated from https://github.com/iDvel/rime-ice/blob/main/lua/corrector.lua",
        "# Run scripts/update_rime_ice_corrections.py to refresh this file.",
        "# Columns: candidate, mistyped reading, weight, correction comment.",
        "---",
        "name: corrections_rime_ice",
        f'version: "{version}"',
        "sort: by_weight",
        "...",
    ]
    body = [f"{text}\t{wrong_code}\t0\t{comment}" for text, wrong_code, comment in rows]
    return "\n".join(header + body) + "\n"


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--source", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--exclude", type=Path)
    parser.add_argument("--version", default="LTS")
    args = parser.parse_args()

    rules = extract_rules(args.source)
    excluded_keys = read_existing_keys(args.exclude)
    content = render(rules, excluded_keys, args.version)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(content, encoding="utf-8", newline="\n")

    generated_count = content.count("\n") - 11
    print(
        f"Generated {generated_count} rules from {len(rules)} upstream rules; "
        f"excluded {len(rules) - generated_count} existing rules."
    )


if __name__ == "__main__":
    main()
