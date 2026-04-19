#!/usr/bin/env python3
"""Render a wiki page template with JSON data from stdin.

Usage:
    echo '<json>' | python scripts/wiki/render.py --type feature
    cat data.json | python scripts/wiki/render.py --type knowledge
"""

import argparse
import json
import sys
from pathlib import Path

from jinja2 import Environment, FileSystemLoader

TEMPLATES_DIR = Path(__file__).resolve().parent / "templates"


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--type", required=True, choices=[
        "feature", "choice", "knowledge", "persona", "task"
    ])
    args = parser.parse_args()

    variables = json.load(sys.stdin)

    env = Environment(
        loader=FileSystemLoader(str(TEMPLATES_DIR)),
        trim_blocks=True,
        lstrip_blocks=True,
    )
    template = env.get_template(f"{args.type}.md.j2")
    sys.stdout.write(template.render(**variables))
    sys.stdout.write("\n")


if __name__ == "__main__":
    main()
