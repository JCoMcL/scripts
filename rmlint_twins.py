#!/usr/bin/env python
import json
import sys

def main():
	rmlint_data = json.loads(sys.stdin.read())
	twins = {}
	for f in rmlint_data:
		current_id = 0
		if "type" in f and f["type"] == "duplicate_file":
			id = f["checksum"]
			if id not in twins:
				twins[id] = [f["path"]]
			else:
				twins[id].append(f["path"])
	for a in twins.values():
		print (",".join(a))

if __name__ == "__main__":
	main()
