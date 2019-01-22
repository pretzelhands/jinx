from __future__ import print_function
from datetime import datetime, timedelta

import time

yesterday = datetime.now() - timedelta(days=1)
formatted = str(time.mktime(yesterday.timetuple()))[:-2]

print(formatted)
