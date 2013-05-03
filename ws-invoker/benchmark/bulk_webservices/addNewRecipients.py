import invoker
import sys
import os.path

ADD_RECIPIENT_TEMPLATE=\
'''<addNewRecipients xmlns="http://www.mir3.com/ws">
  <apiVersion>2.19</apiVersion>
  <authorization>
    <username>%s</username>
    <password>%s</password>
  </authorization>
  %s
  </addNewRecipients>'''

RECIPIENTDETAIL_TEMPLATE=\
'''<recipientDetail>
  <firstName>%s</firstName>
  <lastName>%s</lastName>
  <jobTitle>ENGINEER</jobTitle>
  <company>MIR3</company>
  <division>/</division>
  <alternates>
    <recipient>
      <employeeId>%s</employeeId>
    </recipient>
  </alternates>
  <address>
    <facilityLocation>Del Mar, CA</facilityLocation>
    <address1>12636 High Bluff Drive</address1>
    <address2>Suite 100</address2>
    <building>100</building>
    <floor>2</floor>
    <city>San Diego</city>
    <state>CA</state>
    <zip>92130-1111</zip>
    <province></province>
    <country>USA</country>
  </address>
  <timeZone>EASTERN_USA</timeZone>
  <role>Recipient</role>
  <locale>en_US</locale>
  <devices>
    <device>
      <deviceType>Home Phone</deviceType>
      <address>858-724-1200</address>
      <description>The Blue Phone in the West Wing</description>
      <private>false</private>
      <disabled>false</disabled>
      <defaultPriority>1</defaultPriority>
      <locationStatusReference>
          <name>Work</name>
          <priority>2</priority>
        </locationStatusReference>
        <locationStatusReference>
          <name>Home></name>
          <priority>1</priority>
        </locationStatusReference>
      </device>
      <device>
        <deviceType>1-Way Pager</deviceType>
        <address>1267863</address>
        <description>Gardener Pager #4</description>
        <pagingCarrierId>10</pagingCarrierId>
        <pagerPin>1267863</pagerPin>
        <defaultPriority>2</defaultPriority>
      </device>
    </devices>
    <activeLocationStatus>LOCATION_SCHEDULES</activeLocationStatus>
    <locationStatuses>
      <locationStatus>
        <name>Office</name>
        <locationSchedule>
          <mon-to-fri>
            <allDay>true</allDay>
          </mon-to-fri>
          <sat-sun>
            <from-time>08:00:00</from-time>
            <to-time>16:00:00</to-time>
            <from-date>2005-01-23</from-date>
            <to-date>2005-01-25</to-date>
          </sat-sun>
        </locationSchedule>
      </locationStatus>
    </locationStatuses>
    <employeeId>%s</employeeId>
  <subscriptions>
	  <subscription>
		<category>/Fire</category>
		<priority>/Low</priority>
		<severity>/Critical</severity>
		<matchAll>true</matchAll>
		<keywords>router AND switch</keywords>
		<locationStatus>DEFAULT_LOCATION</locationStatus>
		<activate>true</activate>
	</subscription>
</subscriptions>
<suppressedSubscriptions>
	<suppressedSubscription>
		<startDate>2009-01-23</startDate>
		<startTime>16:00:00</startTime>
		<endDate>2009-01-25</endDate>
		<endTime>08:00:00</endTime>
		<timeZone>PACIFIC_USA</timeZone>
		<category>/Fire</category>
		<priority>/Low</priority>
		<severity>/Critical</severity>
        <matchAll>false</matchAll>
		<keywords>router OR switch</keywords>
		<activate>false</activate>
		<division>/</division>
	</suppressedSubscription>
</suppressedSubscriptions>
</recipientDetail>'''

ALTERNATE_TEMPLATE=\
'''<recipientDetail>
	<firstName>%s</firstName>
	<lastName>%s</lastName>
	<jobTitle>ENGINEER</jobTitle>
	<company>MIR3</company>
	<division>/</division>
	<employeeId>%s</employeeId>
  </recipientDetail>'''

class Recipient(object):
	def __init__(self, cfg, batch_size):
		self.cfg=cfg
		self.batch_size=batch_size		
		self.num_of_recipients_to_create=None
		self.user_ids=[]		
	
	def create_all(self, num_of_recipients_to_create):
		self.user_ids = []
		elapsed_time = 0
		self.num_of_recipients_to_create = range(num_of_recipients_to_create)
		while len(self.num_of_recipients_to_create) > 0:
			if len(self.num_of_recipients_to_create) < self.batch_size:
				self.batch_size = len(self.num_of_recipients_to_create)
			#print 'Create batch with batch size %d Users to be created %d' % (self.batch_size, len(self.num_of_recipients_to_create))
			elapsed_time += self.create_batch()
		return elapsed_time


	def create_batch(self):		
		if self.num_of_recipients_to_create == None:  self.num_of_recipients_to_create = range(self.batch_size)		
		req = invoker.WSRequest(self.cfg)
		req.send(self._to_add_xml())
		response = req.parse()
		errors = response.get_errors()
		if len(errors)>0:
			response.print_errors()
		self.user_ids += response.get_ids('userId')
		return response.get_elapsed_time()

	def _to_add_xml(self):
		str_list = []
		for num in range(self.batch_size):
			user_num = self.num_of_recipients_to_create.pop()			
			str_list.append(RECIPIENTDETAIL_TEMPLATE %('bulk-%d' % user_num , 'bulk', 'alternate-1', 'bulk-%d' % user_num))
		actual_xml = ADD_RECIPIENT_TEMPLATE % (self.cfg['username'],self.cfg['password'], ''.join(str_list))		
		return actual_xml
	
	def get_user_ids(self):		
		return self.user_ids

if __name__=='__main__':	
	cfg = invoker.read_config(sys.argv[1])
	batch_size = int(sys.argv[2])
	users_to_add = int(sys.argv[3])
	r = Recipient(cfg, batch_size)
	r.create_all(users_to_add)
	print r.user_ids