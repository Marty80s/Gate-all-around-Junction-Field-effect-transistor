#!/usr/bin/env python3
"""Convert the included DF-ISE text curves to CSV without TCAD dependencies."""
import csv
import json
import math
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

def read_curve(path):
    text = path.read_text()
    header = re.search(r'datasets\s*=\s*\[(.*?)\]', text, re.S)
    data = re.search(r'Data\s*\{(.*?)\}', text, re.S)
    if not header or not data:
        raise ValueError(f'{path}: expected DF-ISE text datasets and Data block')
    names = re.findall(r'"([^"]+)"', header.group(1))
    values = [float(v.replace('D', 'E').replace('d', 'e')) for v in data.group(1).split()]
    if not names or not values or len(values) % len(names):
        raise ValueError(f'{path}: incomplete data rows')
    if not all(math.isfinite(v) for v in values):
        raise ValueError(f'{path}: non-finite values')
    return names, [values[i:i+len(names)] for i in range(0, len(values), len(names))]

def main():
    dest = ROOT / 'results/csv'
    dest.mkdir(parents=True, exist_ok=True)
    summary = {}
    for stem in ['idvd', 'idvg']:
        names, rows = read_curve(ROOT / 'results/raw' / (stem + '.plt'))
        with (dest / (stem + '.csv')).open('w', newline='') as f:
            writer = csv.writer(f)
            writer.writerow(names)
            writer.writerows(rows)
        fields = ['source OuterVoltage', 'gate OuterVoltage', 'drain OuterVoltage', 'drain TotalCurrent']
        summary[stem] = {'rows': len(rows), 'ranges': {
            name: {'min': min(r[names.index(name)] for r in rows),
                   'max': max(r[names.index(name)] for r in rows)} for name in fields}}
    (dest / 'summary.json').write_text(json.dumps(summary, indent=2) + '\n')
    print(json.dumps(summary, indent=2))

if __name__ == '__main__':
    main()
