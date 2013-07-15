xml.instruct!
xml.address do
	xml.address1 @address.address1
	xml.area @address.area 
	xml.town @address.town
	xml.county @address.county
	xml.postcode @address.postcode
	xml.full @address.fulladdress
end