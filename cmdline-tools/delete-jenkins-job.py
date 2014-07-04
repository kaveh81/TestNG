#!/usr/bin/env python

import sys
import urllib2
from urllib import quote

def delete(job):
	url = 'http://marvin/jenkins/job/%s/doDelete' % quote(job, '')
	print 'Deleting %s' % url
	response = urllib2.urlopen(url, 'yes=really')

for job in sys.argv[1:]:
	delete(job)
