from __future__ import print_function

import sys
import json

json_data = json.load(sys.stdin)
json_key = sys.argv[1]

print(json_data[json_key])
