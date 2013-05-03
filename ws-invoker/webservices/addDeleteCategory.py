import invoker
import sys

ADD_CATEGORY_TEMPLATE=\
'''<addCategory xmlns="http://www.mir3.com/ws">
  <apiVersion>2.19</apiVersion>
  <authorization>
    <username>%s</username>
    <password>%s</password>
  </authorization>
  <categoryDetail>
    <description>%s</description>
    <division>/</division>
	<subcategories/>
  </categoryDetail>  
  </addCategory>'''

DELETE_CATEGORY_TEMPLATE=\
'''<deleteCategory xmlns="http://www.mir3.com/ws">
  <apiVersion>2.19</apiVersion>
  <authorization>
    <username>%s</username>
    <password>%s</password>
  </authorization>
  <category>/%s</category>
  </deleteCategory>'''
  
class Category(object):
	def __init__(self, cfg):
		self.cfg=cfg

	def create(self, categoryName):
		self.categoryName=categoryName
		req = invoker.WSRequest(self.cfg)
		req.send(self._to_add_xml(ADD_CATEGORY_TEMPLATE))
		response = req.parse()
		errors = response.get_errors()
		if len(errors)>0:
			response.print_errors()
			
	def delete(self, categoryName):
		self.categoryName=categoryName
		req = invoker.WSRequest(self.cfg)
		req.send(self._to_add_xml(DELETE_CATEGORY_TEMPLATE))
		response = req.parse()
		errors = response.get_errors()
		if len(errors)>0:
			response.print_errors()

	def _to_add_xml(self, template):
		return template % (self.cfg['username'],self.cfg['password'],self.categoryName)
	
if __name__=='__main__':
	print sys.path
	cfg = invoker.read_config(sys.argv[1])
	categoryName = sys.argv[2]
	c=Category(cfg)
	c.create(categoryName)
	c.delete(categoryName)
	print 'Created and deleted category %s ' % categoryName

