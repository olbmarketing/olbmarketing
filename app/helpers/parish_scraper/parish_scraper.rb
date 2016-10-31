# this program takes input of list of parishes from parish_list.txt 
# and output parish_list with their associated attributes in parish_out.txt

require 'nokogiri'
require 'open-uri'

class Parish 
    attr_accessor  :name
    attr_accessor  :contact
    attr_accessor  :phone
    attr_accessor  :fax
    attr_accessor  :email
    attr_accessor  :website
    attr_accessor  :deanery
    attr_accessor  :address
    attr_accessor  :city
    attr_accessor  :state
    attr_accessor  :zip

    def initialize(name)
        @name = name
    end 

    def to_s
        result_list = []
        instance_variables.each do |v| 
            # remove @ symbol
            attribute_name = v.to_s[1..-1]
            result_list << "#{attribute_name}: '#{send(attribute_name)}'"
        end 
        result_list.join(', ')
    end
end 

def get_phone (table_node)
    table_node.at_xpath('./tr/td[3]/span').content.split('Fax: ')[0]
end 
def get_fax (table_node)
    table_node.at_xpath('./tr/td[3]/span').content.split('Fax: ')[1]
end 
def get_address (table_node)
    table_node.at_xpath('./tr/td[2]/span[1]').content.split(', ')[0]
end 
def get_city (table_node)
    table_node.at_xpath('./tr/td[2]/span[1]').content.split(', ')[1]
end 
def get_state (table_node)
    table_node.at_xpath('./tr/td[2]/span[1]').content.split(', ')[2].split(' ')[0]
end 
def get_zip (table_node)
    table_node.at_xpath('./tr/td[2]/span[1]').content.split(', ')[2].split(' ')[1][0,5]
end 
def get_website (table_node) 
    safe_scrape_node table_node.at_xpath('./tr/td[2]/span[2]/a')
end 
def get_email (table_node)
    safe_scrape_node table_node.at_xpath('./tr/td[2]/span[2]/a[2]')
end
def safe_scrape_node (node)
    node ? node.content : ""
end 

def write_parishes (parish_list)
    File.open('parish_out.txt', 'w') do |f| 
        parish_list.each do |p|
            f.write("Parish.create(#{p.to_s})\n")
        end 
        
    end 
end 

if __FILE__==$0
    # read in parish_list
    f = File.open('parish_list.txt', 'r')
    parish_list = []
    f.each_line do |content|
        parish = content.chomp.chomp(',')
        parish_list << Parish.new(parish) if parish.length > 0
    end 
    # for parse parish deanery
    parish_deanery_doc = Nokogiri::HTML(open("http://www.colsdioc.org/Resources/DioceseofColumbusDirectory/DiocesanInformation/DioceseOfColumbusDeaneries.aspx"))
    # for parse paristh other info
    parish_info_doc = Nokogiri::HTML(open("http://www.colsdioc.org/Resources/DioceseofColumbusDirectory/Parishes.aspx"))
    parish_list.each do |parish|
        # get parish's deanery 
        
        span_node = parish_deanery_doc.at_xpath("//span[contains(text(), 'St. Agatha')]")
        parent_node = span_node.parent
        while (parent_node.attribute('class').to_s != 'office printData') 
            parent_node = parent_node.parent
        end 
        parish.deanery = parent_node.at_xpath('./table/tr[1]/td[2]/h3/span').content
        
        # get parish's other info 
        span_node = parish_info_doc.at_xpath("//span[contains(text(), '#{parish.name}')]")
        parent_node = span_node.parent
        while (parent_node.attribute('class').to_s != 'officeTable') 
            parent_node = parent_node.parent
        end 
        #parish.contact = get_contact parent_node
        parish.phone = get_phone parent_node
        parish.fax = get_fax parent_node
        parish.email = get_email parent_node
        parish.website = get_website parent_node
        parish.address = get_address parent_node
        parish.city = get_city parent_node
        parish.state = get_state parent_node
        parish.zip = get_zip parent_node

    end 
    write_parishes (parish_list)
    
end 