#!/usr/bin/python

import urllib2, re, string, sys
import xml.dom.minidom
from xml.dom.minidom import Node
import time

NAMESPACE = 'http://www.mir3.com/ws'

SOAP_TEMPLATE = "<?xml version='1.0' encoding='UTF-8'?>\r\n" +\
                "<soapenv:Envelope xmlns:soapenv='http://schemas.xmlsoap.org/soap/envelope/'\r\n" +\
                "  xmlns:xsd='http://www.w3c.org/XMLSchema' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'>\r\n" +\
                "<soapenv:Body>\r\n" +\
                "%s\r\n" +\
                "</soapenv:Body>\r\n" +\
                "</soapenv:Envelope>\r\n"

class WSError(object):
	def __init__(self, code, description):
		self.code = code
		self.description = description

	def __str__(self):
		return 'Error %d: %s' % (self.code, self.description)

class WSResponse(object):
	def __init__(self, dom, elapsed, raw_response):
		self.dom = dom
		self.elapsed_time = elapsed
		self._errors = self._parse_errors()
		self.raw_response = raw_response

	def get_raw_response(self):
		return self.raw_response

	def get_elapsed_time(self):
		return self.elapsed_time

	def get_errors(self):
		return self._errors[:]


	def textForNode(self, name):
		for node in self.dom.getElementsByTagNameNS(NAMESPACE, name):
			return self._get_text(node)

	def textsForNode(self, name):
		return [self._get_text(node) for node in self.dom.getElementsByTagNameNS(NAMESPACE, name)]

	def print_errors(self):
		for error in self._errors:
			print error

	def _get_text(self, node):
        	ret = ''
        	for sub in node.childNodes:
                	if sub.nodeType == sub.TEXT_NODE:
                        	ret += sub.data
        	return ret

	def get_ids(self, tagName):
		ids = []
		for nodeName in self.dom.getElementsByTagNameNS(NAMESPACE, tagName):
			ids.append(int(self._get_text(nodeName)))
		return ids

	def _parse_errors(self):
		errors = []
		for errorNode in self.dom.getElementsByTagNameNS(NAMESPACE, 'error'):
			errorCode = None
			errorMsg = None
			for errorCodeNode in errorNode.getElementsByTagNameNS(NAMESPACE, 'errorCode'):
				errorCode = int(self._get_text(errorCodeNode))
			for errorMsgNode in errorNode.getElementsByTagNameNS(NAMESPACE, 'errorMessage'):
				errorMsg = self._get_text(errorMsgNode)
			errors.append( WSError(errorCode, errorMsg) )
		return errors

class WSRequest(object):
	def __init__(self, cfg):		
		self.host = cfg['host']
		self.port = cfg['port']
		self.parsed_response = None

	def send(self, xml):
		global SOAP_TEMPLATE
		req = urllib2.Request('http://%s:%s/services/v1.2/mir3' % (self.host,self.port))
		req.add_header("Content-Type", "text/xml; charset=utf-8")
		req.add_header("Accept", "application/soap+xml")
		req.add_header("Host", self.host)
		req.add_header("Cache-Control", "no-cache")
		req.add_header("Pragma", "no-cache")
		req.add_header("SOAPAction", '""')
		req.add_data( SOAP_TEMPLATE % xml )
		startTime = time.time()
		resp = urllib2.urlopen(req).read()
		self.raw_response = resp
		self.elapsedTime = time.time() - startTime

	def get_raw_response(self):
		return self.raw_response

	def parse(self):
		dom = self.get_dom()
		return WSResponse(dom, self.elapsedTime, self.raw_response)
		
	def get_dom(self):
		if self.parsed_response == None:
			self.parsed_response = xml.dom.minidom.parseString(self.raw_response)
		return self.parsed_response

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
	cfg = read_config('web-services.cfg')
	xml = read_file(sys.argv[1])
	req = WSRequest(cfg)
	req.send(xml)
	print req.get_raw_response()

if __name__=='__main__': main()
