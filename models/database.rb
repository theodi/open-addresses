class Address
  include MongoMapper::Document
  
  before_validation :titleize_addresses
  before_validation :set_fulladdress
  validates_uniqueness_of :fulladdress
  
  key :address1, String
  key :area, String
  key :town, String
  key :county, String
  key :postcode, String
  key :fulladdress, String
    
  private 
  
  def titleize_addresses
    # Stops building numbers - i.e. 25a from being titleized
    ActiveSupport::Inflector.inflections do |inflect|
      inflect.human /([0-9]+)_([a-z])/i, '\1\2'
    end
    
    self.address1 = self.address1.titleize rescue nil
    self.area = self.area.titleize rescue nil
    self.town = self.town.titleize rescue nil
    self.county = self.county.titleize rescue nil
  end
  
  def set_fulladdress
    address = [self.address1, self.area, self.town, self.county, self.postcode]
    self.fulladdress = address.reject(&:blank?).join(", ")
  end
end