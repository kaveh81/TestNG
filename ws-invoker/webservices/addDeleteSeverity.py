import invoker
import sys

ADD_SEVERITY_TEMPLATE=\
'''<addSeverity xmlns="http://www.mir3.com/ws">
  <apiVersion>2.19</apiVersion>
  <authorization>
    <username>%s</username>
    <password>%s</password>
  </authorization>
  <severityDetail>
    <description>%s</description>
    <division>/</division>
  </severityDetail>
</addSeverity>'''

DELETE_SEVERITY_TEMPLATE=\
'''<deleteSeverity xmlns="http://www.mir3.com/ws">
  <apiVersion>2.19</apiVersion>
  <authorization>
    <username>%s</username>
    <password>%s</password>
  </authorization>
  <severity>/%s</severity>
</deleteSeverity>'''

class Severity(object):
	def __init__(self, cfg):
		self.cfg=cfg

	def create(self, severityName):
		self.severityName=severityName
		req = invoker.WSRequest(self.cfg)
		req.send(self._to_add_xml(ADD_SEVERITY_TEMPLATE))
		response = req.parse()
		errors = response.get_errors()
		if len(errors)>0:
			response.print_errors()

	def delete(self, severityName):
		self.severityName=severityName
		req = invoker.WSRequest(self.cfg)
		req.send(self._to_add_xml(DELETE_SEVERITY_TEMPLATE))
		response = req.parse()
		errors = response.get_errors()
		if len(errors)>0:
			response.print_errors()

	def _to_add_xml(self, template):
		return template % (self.cfg['username'],self.cfg['password'],self.severityName)

if __name__=='__main__':
	print sys.path
	cfg = invoker.read_config(sys.argv[1])
	desc = sys.argv[2]
	c=Severity(cfg)
	c.create(desc)
	c.delete(desc)
	print 'Created and deleted severity %s ' % desc

