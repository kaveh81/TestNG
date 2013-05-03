#!/usr/bin/python
from optparse import OptionParser
import invoker

# This is a simple tool for initiating an existing notification, intended as much as an example of how to 
# build a tool using the invoker module as it is to be actually useful.  Run with python to see usage help.

parser = OptionParser('usage: %prog [options] title_of_notification')
parser.add_option('-e', '--endpoint', dest='endpoint', help='Endpoint URL', default='https://ws.mir3.com/services/v1.2/mir3')
parser.add_option('-u', '--user', dest='user', help='Username for authentication')
parser.add_option('-p', '--password', dest='password', help='Password for authentication')
(options, args) = parser.parse_args()
if len(args) < 1:
	parser.print_help()
else:
	notification = reduce(lambda x,y: x+' '+y, args) # Let users be lazy and not quote notification titles with spaces.
	req = invoker.WSRequest({'endpoint':options.endpoint})
	xml = """<initiateNotifications xmlns="http://www.mir3.com/ws">
  		<apiVersion>2.7</apiVersion>
  		<authorization>
    		<username>%s</username>
    		<password>%s</password>
  		</authorization>
  		<initiateOneNotification>
    		<notification>%s</notification>
  		</initiateOneNotification>
		</initiateNotifications>""" % (options.user, options.password, notification)
	req.send(xml)
	print req.get_raw_response()

