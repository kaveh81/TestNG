import invoker, sys

ADD_PRIORITY_TEMPLATE=\
'''<addPriority xmlns="http://www.mir3.com/ws">
  <apiVersion>2.19</apiVersion>
  <authorization>
    <username>%s</username>
    <password>%s</password>
  </authorization>
  <priorityDetail>
    <description>%s</description>
    <division>/</division>
  </priorityDetail>
</addPriority>'''

DELETE_PRIORITY_TEMPLATE=\
'''<deletePriority xmlns="http://www.mir3.com/ws">
  <apiVersion>2.19</apiVersion>
  <authorization>
    <username>%s</username>
    <password>%s</password>
  </authorization>
  <priority>/%s</priority>
  </deletePriority>'''

class Priority(object):
	def __init__(self, cfg):
		self.cfg=cfg

	def create(self, priorityName):
		self.priorityName=priorityName
		req = invoker.WSRequest(self.cfg)
		req.send(self._to_add_xml(ADD_PRIORITY_TEMPLATE))
		response = req.parse()
		errors = response.get_errors()
		if len(errors)>0:
			response.print_errors()

	def delete(self, priorityName):
		self.priorityName=priorityName
		req = invoker.WSRequest(self.cfg)
		req.send(self._to_add_xml(DELETE_PRIORITY_TEMPLATE))
		response = req.parse()
		errors = response.get_errors()
		if len(errors)>0:
			response.print_errors()

	def _to_add_xml(self, template):
		return template % (self.cfg['username'],self.cfg['password'],self.priorityName)

if __name__=='__main__':
	print sys.path
	cfg = invoker.read_config(sys.argv[1])
	priorityName = sys.argv[2]
	p=Priority(cfg)
	p.create(priorityName)
	p.delete(priorityName)
	print 'Created and deleted priority %s ' % priorityName


