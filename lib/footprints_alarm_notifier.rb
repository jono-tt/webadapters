require 'net/http'
require 'uri'

class FootprintsAlarmNotifier
  @queue = :footprints_notifications

  def self.config
    @config ||= YAML::load_file(File.join(Rails.root, "config", "footprints.yml"))[Rails.env]
  end

  def self.ws_uri
    "http://" + self.config["ws_host"] + "/MRcgi/MRWebServices.pl"
  end

  def self.namespace
    "http://" + self.config["ws_host"] + "/MRWebServices"
  end

  def self.project_id
    self.config["project_id"]
  end

  def self.username
    self.config["username"]
  end

  def self.password
    self.config["password"]
  end

  def self.alarm_host
    self.config["alarm_host"]
  end

  def self.perform(alarm_id)
    alarm = Alarm.find(alarm_id)
    alarm_link = Rails.application.routes.url_helpers.site_api_method_alarm_url(alarm.site, alarm.api_method, alarm, :host => self.alarm_host)

    xml_header  = %{<?xml version="1.0" encoding="UTF-8"?><soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" soap:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">}
    soap_header = %{<soap:Body><MRWebServices__createIssue xmlns="#{self.namespace}">}
    username    = %{<c-gensym3 xsi:type="xsd:string">#{self.username}</c-gensym3>}
    password    = %{<c-gensym5 xsi:type="xsd:string">#{self.password}</c-gensym5>}
    assignees   = %{<c-gensym7 xsi:type="xsd:string" />}
    priority    = %{<c-gensym9><priorityNumber xsi:type="xsd:int">1</priorityNumber>}
    status      = %{<status xsi:type="xsd:string">Open</status>}
    project     = %{<projectID xsi:type="xsd:int">#{self.project_id}</projectID>}
    title       = %{<title xsi:type="xsd:string">Webadapter: alarm for #{alarm.site.name}</title>}
    description = %{<description xsi:type="xsd:string">#{alarm.message}\n\n#{alarm_link}</description>}
    soap_footer = %{</c-gensym9></MRWebServices__createIssue></soap:Body></soap:Envelope>}

    soap_body   = xml_header << soap_header << username << password << assignees << priority << status << project << title << description << soap_footer

    # Send the request
    uri = URI.parse(self.ws_uri)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    request.body = soap_body
    request["SOAPAction"] = "#{self.namespace}#MRWebServices__createIssue"
    request["Content-Type"] = "text/xml; charset=utf-8"
    response = http.request(request)

    # Extract the issue id
    xml = Nokogiri::XML(response.body)
    element = xml.at_xpath("//return")
    if element
      issue_id = element.text
      alarm.update_attributes(:footprints_issue_id => issue_id)
    else
      Rails.logger.error("Failed to create ticket: #{response.body.inspect}")
    end
  end
end
