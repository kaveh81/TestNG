#!/usr/bin/python

import invoker, string, sys
from benchmark.bulk_webservices.addNewRecipients import Recipient
from benchmark.bulk_webservices.deleteRecipients import DeleteRecipient

UPDATE_RECIPIENT_TEMPLATE =\
'''<updateRecipients xmlns="http://www.mir3.com/ws">
  <apiVersion>2.19</apiVersion>
  <authorization>
    <username>%s</username>
    <password>%s</password>
  </authorization>
  <createIfNotFound>true</createIfNotFound>
  %s
</updateRecipients>'''

SINGLE_UPDATE_USER_TEMPLATE=\
''' <updateOneRecipient>
    <recipient>
      <userId>%s</userId>
    </recipient>
	<recipientDetail>
    <firstName>%s</firstName>
    <lastName>%s</lastName>
    <jobTitle>Engineer</jobTitle>
    <company>MIR3</company>
    <division>/</division>
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
          <name>Home</name>
          <priority>1</priority>
        </locationStatusReference>
      </device>
      <device>
        <deviceType>1-Way Pager</deviceType>
        <address>1267863</address>
        <description>Gardener Pager 4</description>
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
    <customFields/>    
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
  </recipientDetail>
  </updateOneRecipient>'''

class UpdateRecipient(object):
	def __init__(self, cfg, batch_size):
		self.cfg=cfg
		self.batch_size=batch_size
	
	def update(self, user_ids_to_update):		
		self.user_ids_to_update = user_ids_to_update		
		elapsed_time = 0
		while len(user_ids_to_update) > 0:
			if len(user_ids_to_update) < self.batch_size:
				self.batch_size = len(user_ids_to_update)
			#print 'Update batch with batchSize %d  Total users to update %d' % (self.batch_size, len(user_ids_to_update))
			elapsed_time += self.update_batch()
		return elapsed_time

	def update_batch(self):
		req = invoker.WSRequest(self.cfg)
		req.send(self._to_add_xml())
		response = req.parse()		
		errors = response.get_errors()
		if len(errors)>0:
			response.print_errors()		
		return response.get_elapsed_time()

	def _to_add_xml(self):
		str_list = []		
		for num in range(self.batch_size):
			user_id = self.user_ids_to_update.pop()
			str_list.append(SINGLE_UPDATE_USER_TEMPLATE %(user_id, 'bulk-update-%d' % user_id , 'bulk-update'))
		actual_xml = UPDATE_RECIPIENT_TEMPLATE % (self.cfg['username'],self.cfg['password'], ''.join(str_list))				
		return actual_xml
	
if __name__=='__main__':
	cfg = invoker.read_config(sys.argv[1])
	batch_size = int(sys.argv[2])
	users_to_update = int(sys.argv[3])

	r = Recipient(cfg, batch_size)
	r.create_all(users_to_update)
	user_ids_to_update = r.get_user_ids()
	print user_ids_to_update

	ur = UpdateRecipient(cfg, batch_size)
	ur.update(user_ids_to_update)

	delRep = DeleteRecipient(cfg, batch_size)
	delRep.delete(user_ids_to_update)