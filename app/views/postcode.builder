xml.instruct!
xml.addresses do
  @addresses.each do |address|
    xml.address do
    	xml.address1 address.address1
    	xml.area address.area 
    	xml.town address.town
    	xml.county address.county
    	xml.postcode address.postcode
    	xml.full address.fulladdress
    	xml.uri url_for(:address, :id => address.id)
    end
  end
end