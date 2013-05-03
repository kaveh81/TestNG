import invoker, sys

DELETE_RECIPIENTS_TEMPLATE=\
'''<deleteRecipients xmlns ="http://www.mir3.com/ws">
  <apiVersion>2.19</apiVersion>
  <authorization>
    <username>%s</username>
    <password>%s</password>
  </authorization>
  %s
</deleteRecipients>'''

RECIPIENT_TO_DELETE_TEMPLATE=\
'''<recipient>
    <userId>%s</userId>
  </recipient>'''

RECIPIENT_TO_DELETE_BY_EMPLOYEEID_TEMPLATE=\
'''<recipient>
    <employeeId>%s</employeeId>
  </recipient>'''


class DeleteRecipient(object):
	def __init__(self, cfg, batch_size):
		self.cfg=cfg
		self.batch_size=batch_size
    
	def delete(self, delete_ids, del_by_employee_Id=None):
		self.delete_ids=delete_ids
		self.del_by_employee_Id = del_by_employee_Id
		elapsed_time = 0
		while len(delete_ids) > 0:
			if len(delete_ids) < self.batch_size:
				self.batch_size = len(delete_ids)
			#print 'Delete batch with batch size %d  Total users to be deleted %d' % (self.batch_size, len(delete_ids))
			elapsed_time += self.delete_batch()
		return elapsed_time

	def delete_batch(self):
		req = invoker.WSRequest(self.cfg)
		req.send(self._to_add_xml())
		response = req.parse()
		errors = response.get_errors()
		if len(errors)>0:
			response.print_errors()
		return response.get_elapsed_time()

	def _to_add_xml(self):
		str_list = []
		for num in xrange(self.batch_size):
			id = self.delete_ids.pop()
			if self.del_by_employee_Id != None:
				str_list.append(RECIPIENT_TO_DELETE_BY_EMPLOYEEID_TEMPLATE %(id))
			else:
				str_list.append(RECIPIENT_TO_DELETE_TEMPLATE %(id))
		return DELETE_RECIPIENTS_TEMPLATE % (self.cfg['username'],self.cfg['password'], ''.join(str_list))

if __name__=='__main__':
	cfg = invoker.read_config(sys.argv[1])
	batch_size = int(sys.argv[2])
	users_to_update = int(sys.argv[3])

	r = Recipient(cfg, batch_size)
	r.create_all(users_to_update)
	user_ids_to_update = r.get_user_ids()
	print user_ids_to_update
	
	delRep = DeleteRecipient(cfg, batch_size)
	delRep.delete(user_ids_to_update)