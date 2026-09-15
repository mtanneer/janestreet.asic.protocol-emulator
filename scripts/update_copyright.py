#!/usr/bin/env python3
"""Rewrite the LICENSE copyright line from info.yaml contributors + current year."""
import re
import sys
from pathlib import Path

import yaml

REPO_ROOT = Path(__file__).resolve().parent.parent
LICENSE_PATH = REPO_ROOT / "LICENSE"
INFO_YAML_PATH = REPO_ROOT / "info.yaml"
COPYRIGHT_RE = re.compile(r"^   Copyright \d{4} .+$", re.MULTILINE)


def build_copyright_line(year: int) -> str:
    info = yaml.safe_load(INFO_YAML_PATH.read_text())
    contributors = info["project"].get("contributors") or [info["project"]["author"]]
    names = ", ".join(contributors)
    return f"   Copyright {year} {names}"


def main() -> int:
    import datetime

    year = datetime.date.today().year
    new_line = build_copyright_line(year)

    license_text = LICENSE_PATH.read_text()
    if not COPYRIGHT_RE.search(license_text):
        print("No 'Copyright YYYY ...' line found in LICENSE", file=sys.stderr)
        return 1

    updated_text = COPYRIGHT_RE.sub(new_line, license_text)
    if updated_text == license_text:
        print("LICENSE copyright line already up to date")
        return 0

    LICENSE_PATH.write_text(updated_text)
    print(f"Updated LICENSE copyright line to: {new_line.strip()}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
