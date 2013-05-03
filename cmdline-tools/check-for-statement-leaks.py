import mir3console, re

# This uses mir3console to connect to several Tahoe/Yosemite instances,
# look for the currently used statements, gather stack traces for the 
# current statements, and print summaries of where in the code the
# current statements are being executed.  Output is very useful for tracking
# down leaks in prepared statements
# 
# The list of Tahoe/Yosemite instances to access are defined towards the end
# of this script.

ALL_LINES = {}

def inspect_statement(id, host, port):
	global ALL_LINES
	raw = mir3console.run('print statement %s' % id, host, port)
	get_next_line = False
	for line in raw.splitlines():
		if get_next_line: 
			if not ALL_LINES.has_key(line): ALL_LINES[line]=0
			ALL_LINES[line] += 1
			break
		if line.find('SawtoothConnection.prepareStatement') > 0: get_next_line = True

def check_for_leak(host, port=6235):
	raw = mir3console.run('print statements', host, port)
	regex = re.compile(r'(.*)There are currently', re.DOTALL)
	m = regex.search(raw)
	if m is not None:
		ids = m.group(1).split()
		for id in ids:
			inspect_statement(id, host, port)
	else:
		return []


# List out the server(s) you'd like to check here.  This list is the Denver prod list as of 2/8/2010
check_for_leak('172.16.10.20')
check_for_leak('172.16.10.22')
check_for_leak('172.16.10.23')
check_for_leak('172.16.10.24')
check_for_leak('172.16.10.25')
check_for_leak('172.16.10.27')
check_for_leak('172.16.10.29')
check_for_leak('172.16.10.30')
check_for_leak('172.16.10.31')
check_for_leak('172.16.10.50', 6234)
check_for_leak('172.16.10.70', 6234)

for line in ALL_LINES:
	print '%10d %s' % (ALL_LINES[line], line)
