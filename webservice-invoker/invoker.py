#!/usr/bin/python

import urllib2, re, string, sys
import xml.dom.minidom
from xml.dom.minidom import Node

# This utility can be used from the command-line to send web-service requests
# and print the responses to stdout, or it can be imported as a web-service invoking
# utility by other python modules.
#
# To run at the command-line, run with the XML request to send as the argument, and a file 
# called web-services.cfg should be present in the current working directory containing an 
# endpoint property (or, for backwards compatibility, both host and port properties, 
# although this use is discouraged since it doesn't support SSL)
# EXAMPLE web-services.cfg:
# endpoint = https://ws.mir3.com/services/v1.2/mir3
#
# If web-services.cfg does not exist or does not contain an endpoint, the main production
# endpoint is assumed (https://ws.mir3.com/services/v1.2/mir3)

SOAP_TEMPLATE = "<?xml version='1.0' encoding='UTF-8'?>\r\n" +\
                "<soapenv:Envelope xmlns:soapenv='http://schemas.xmlsoap.org/soap/envelope/'\r\n" +\
                "  xmlns:xsd='http://www.w3c.org/XMLSchema' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'>\r\n" +\
                "<soapenv:Body>\r\n" +\
                "%s\r\n" +\
                "</soapenv:Body>\r\n" +\
                "</soapenv:Envelope>\r\n"

class WSRequest(object):
	def __init__(self, cfg):
		if cfg.has_key('endpoint'):
			self.endpoint = cfg['endpoint']
			m = re.match(r'(\w+)://([^/:]+)(:\d+)?(.*)$', self.endpoint)		
			if m is None: raise ValueError('Cannot parse endpoint: %s' % self.endpoint)
			self.host = m.group(2)
		else:
			host = cfg['host']
			port = cfg['port']
			self.host = host
			self.endpoint = 'http://%s:%s/services/v1.2/mir3' % (host, port)

	def send(self, xml):
		global SOAP_TEMPLATE
		req = urllib2.Request(self.endpoint)
		req.add_header("Content-Type", "text/xml; charset=utf-8")
		req.add_header("Accept", "application/soap+xml")
		req.add_header("Host", self.host)
		req.add_header("Cache-Control", "no-cache")
		req.add_header("Pragma", "no-cache")
		req.add_header("SOAPAction", '""')
		req.add_data( SOAP_TEMPLATE % xml )
		resp = urllib2.urlopen(req).read()
		self.raw_response = resp

	def get_raw_response(self):
		return self.raw_response

	def get_dom(self):
		doc = xml.dom.minidom.parseString(self.raw_response)
		return doc

def read_file(name):
	f = open(name)
	ret = f.read()
	f.close()
	return ret

def read_config(filename):
	f = open(filename,'r')
	regex = re.compile(r'^([^#=][^=]+)=(.*)$')
	cfg = {}
	for line in f.readlines():
		line = string.strip(line)
		m = regex.match(line)
		if m is not None:
			key = string.strip(m.group(1))
			value = string.strip(m.group(2))
			cfg[key] = value
	f.close()
	return cfg

def usage():
	print "Usage: %s [filename]" % sys.argv[0]
	print "Sends a web service request with the XML file specified, and prints the response."

def main():
	if len(sys.argv) != 2:
		usage()
		return
	try:
		cfg = read_config('web-services.cfg')
	except IOError:
		cfg = {'endpoint':'https://ws.mir3.com/services/v1.2/mir3'}
	xml = read_file(sys.argv[1])
	req = WSRequest(cfg)
	req.send(xml)
	print req.get_raw_response()

if __name__=='__main__': main()
