#!/usr/bin/python
import socket, re
from optparse import OptionParser

# Run commands via Tahoe/Yosemite console, and echo the result to stdout.
# mir3console.py can be used as a module and imported from other scripts,
# or it can be invoked directly on the command-line.  If invoked from the command-line
# with no further arguments, it prints a usage summary.

def run(cmd, host='localhost', port=6235):
	s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
	s.connect((host,port))
	s.send(cmd + '\nQUIT\n')
	resp = ''
	while 1:
		data = s.recv(4096)
		if len(data) < 1:
			break
		resp += data
	regex = re.compile(r'\n> (.*)\n(?:INlogic)|(?:MIR3) Console', re.DOTALL)
	m = regex.search(resp)
	if m is not None:
		print 'Got group from resp ', m.group(1)
		return m.group(1)
	else: raise Exception('Cannot parse output on %s:%d' % (host,port))

if __name__=='__main__':
	parser = OptionParser()
	parser.add_option('-s', '--server', dest='server', help='Server to connect to, default is localhost', default='localhost')
	parser.add_option('-p', '--port', dest='port', help='Port to connect to, default is 6235', default=6235, type="int")
	(options, args) = parser.parse_args()
	cmd = reduce(lambda x,y: x + ' ' + y, args)
	print run(cmd, options.server, options.port)
