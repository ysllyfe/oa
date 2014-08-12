#encoding:utf-8
class SmsNow
	require "base64"
	require 'socket'
	require 'rexml/document'
	#require 'iconv'
	def initialize
		@serverUrl = "sms.todaynic.com"
		@serverPort = "20002"
		@serverUser = "ms33859"
		@serverPassword="ndi3nd"
	end

	def sendSMS(phones,msg,api_type,time)
		if phones.class == Hash
			@phones = phones.collect {|w| w.phone}.uniq.compact.join(',')
		end
		if phones.class == Array
			@phones = phones.uniq.compact.join(',')
		end
		if phones.class == String
			@phones = phones
		end

		#@ic2 = Iconv.new('gb2312//IGNORE', 'UTF-8//IGNORE')
		#msg = @ic2.iconv(msg)
		msg = msg.encode("gb2312", :invalid => :replace, :undef => :replace, :replace => "?")
		command = "<action>SMS:sendSMS</action><sms:mobile>#{@phones}</sms:mobile><sms:message>#{Base64.encode64(msg)}</sms:message><sms:datetime>#{time}</sms:datetime><sms:apitype>#{api_type}</sms:apitype>"
		response = sendSCPData(command)
		xml = REXML::Document.new(response)
		xml.elements["//msg"].text
	end
	def infoSMSAccount
		xml_command="<action>SMS:infoSMSAccount</action>"
		response = sendSCPData(xml_command)
		xml = REXML::Document.new(response)
		#xml.elements["//msg"].text
		xml.elements["//smsaccount"].text
	end
	def sendSCPData(xml_command)
		@XMLDATA = self.toSCPXML(xml_command)
		#p @XMLDATA
		self.sendXMLData(@XMLDATA)
	end
	def CltrID
		@time = Time.now.to_f.to_s.split('.')
		@cltrid = @time[0].to_i * 100 + @time[1].to_i * 100
	end
	def getENCID(cltrid,password)
		Digest::MD5.hexdigest("#{cltrid}-#{password}")
	end
	def toSCPXML(commandxml)
		cltrid = self.CltrID
		@clientid = self.getENCID(cltrid,@serverPassword)
		@xmlns = "xmlns=\"urn:mobile:params:xml:ns:scp-1.0\"
			  xmlns:sms=\"urn:todaynic.com:sms\"
			  xmlns:user=\"urn:todaynic.com:user\""
		@secruser = "<smsuser>#{@serverUser}</smsuser>";
		@respxml="<?xml version=\"1.0\" encoding=\"UTF-8\"?>
			<scp #{@xmlns}>
				<command>
					   #{commandxml}
				</command>
				<security>
					#{@secruser}
					<cltrid>#{cltrid}</cltrid>
					<login>#{@clientid}</login>
			   </security>
			</scp>"
		end
	def sendXMLData(xmldata)
		socket = TCPSocket.open(@serverUrl,@serverPort)  # Connect to server
			socket.print(xmldata)               # Send request
			response = socket.read              # Read complete response
		socket.close
		response
	end
end