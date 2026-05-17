"""Audit helper: emit screen-level metrics for AUDITORIA_PANTALLAS.md."""
import re
from pathlib import Path

screens = sorted(Path("lib/features").glob("**/screens/*.dart"))
rows = []
for f in screens:
    txt = f.read_text(encoding="utf-8", errors="ignore")
    lines = txt.splitlines()
    loc = len(lines)
    colors = len(re.findall(r"Color\(0x", txt))
    theater = len(re.findall(r"_mockData|mockPedidos|hardcoded|FakeRepo|seedDemo|dummyData", txt))
    bad = len(re.findall(r"localhost|X-Secret", txt))

    # detect god classes
    god = []
    current = None
    start = 0
    for i, line in enumerate(lines, 1):
        m = re.match(r"^class (\w+)", line)
        if m:
            if current and (i - start) > 400:
                god.append(f"{current}({i - start})")
            current = m.group(1)
            start = i
    if current and (len(lines) - start) > 400:
        god.append(f"{current}({len(lines) - start})")
    god_str = "; ".join(god) if god else "-"

    rel = str(f).replace("\\", "/").replace("lib/features/", "")
    rows.append((rel, loc, colors, theater, bad, god_str))

print("Pantalla|LOC|ColorLits|Theater|BadBackend|GodClasses(LOC)")
for r in rows:
    print("|".join(str(x) for x in r))

# totals globals
total_loc = sum(r[1] for r in rows)
total_colors = sum(r[2] for r in rows)
print(f"\nTOTALS: screens={len(rows)} loc={total_loc} colors={total_colors}")
