class AddressSearch
  require 'sparql/client'
  
  def initialize(postcode)
    p = UKPostcode.new(postcode)
    if p.full?
      @postcode = p.norm
    else
      false
    end
  end
  
  def addresses
    [self.price_paid, self.companies_house, self.fsa].flatten
  end
  
  def price_paid
    addresses = []
    sparql = SPARQL::Client.new("http://landregistry.data.gov.uk/landregistry/query")
    
    query = "PREFIX xsd:     <http://www.w3.org/2001/XMLSchema#>
    PREFIX lrppi:   <http://landregistry.data.gov.uk/def/ppi/>
    PREFIX lrcommon: <http://landregistry.data.gov.uk/def/common/>

    SELECT ?paon ?saon ?street ?locality ?town ?county ?postcode ?amount ?date
    WHERE
    {   	?transx   lrppi:propertyAddress ?addr.

    	?addr lrcommon:postcode '#{@postcode}'^^xsd:string .
    	?addr lrcommon:postcode ?postcode .

    	OPTIONAL {?addr lrcommon:county ?county .}
    	OPTIONAL {?addr lrcommon:paon ?paon .}
    	OPTIONAL {?addr lrcommon:saon ?saon .}
    	OPTIONAL {?addr lrcommon:street ?street .}
    	OPTIONAL {?addr lrcommon:locality ?locality .}
    	OPTIONAL {?addr lrcommon:town ?town .}
    }
    ORDER BY ?amount
    "
    
    results = sparql.query(query)
    
    results.each do |r|
      addresses << build_address({
                                  :address1 => "#{r[:paon].to_s || r[:saon].to_s} #{r[:street].to_s}".strip,
                                  :address2 => r[:town].to_s, 
                                  :address3 => r[:county].to_s, 
                                  :postcode => r[:postcode].to_s
                                  })
    end
    
    return addresses
  end
  
  def companies_house  
    addresses = []
    url = "http://api.opencorporates.com/v0.2/companies/search?q=#{URI.escape(@postcode)}&jurisdiction_code=gb"
    json = JSON.parse HTTParty.get(url).body
    json["results"]["companies"].each do |c|
      company = JSON.parse HTTParty.get("#{c['company']['registry_url']}.json").body
      if company["primaryTopic"]["RegAddress"]["Postcode"] == @postcode     
        addresses << build_address({
                                    :address1 => company["primaryTopic"]["RegAddress"]["AddressLine1"], 
                                    :address2 => company["primaryTopic"]["RegAddress"]["AddressLine2"], 
                                    :address3 => company["primaryTopic"]["RegAddress"]["PostTown"], 
                                    :address4 => company["primaryTopic"]["RegAddress"]["County"], 
                                    :postcode => company["primaryTopic"]["RegAddress"]["Postcode"]
                                    })
      end
    end
    return addresses
  end
  
  def fsa
    addresses = []
    url = "http://ratings.food.gov.uk/search/%5E/#{URI.escape(@postcode)}/json"
    json = JSON.parse HTTParty.get(url).body
    unless json["FHRSEstablishment"]["EstablishmentCollection"].nil?
      json["FHRSEstablishment"]["EstablishmentCollection"]["EstablishmentDetail"].each do |e|
        addresses << build_address({
                                   :address1 => e["AddressLine1"], 
                                   :address2 => e["AddressLine2"], 
                                   :address3 => e["AddressLine3"], 
                                   :postcode => e["PostCode"]
                                   })
      end
    end
    return addresses
  end
  
  def build_address(address)
    a = Address.new(
      :address1    => address[:address1],
      :address2    => address[:address2],
      :address3    => address[:address3],
      :address4    => address[:address4],
      :postcode    => address[:postcode]
    )
    if a.save
      a.fulladdress
    else
      nil
      #Address.where(:address1 => address[:address1], :postcode => address[:postcode]).first.fulladdress
    end
  end
  
end