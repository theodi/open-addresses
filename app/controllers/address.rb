FreeThePaf::App.controllers :address do

  post :postcode, :map => '/postcode' do
    params[:postcode]
    p = UKPostcode.new(params[:postcode])
    postcode = p.norm.gsub(" ", "")
    redirect url(:address, :postcode, :postcode => postcode)
  end
  
  get :postcode, :with => :postcode, :provides => [:html, :json, :xml], :map => '/postcode' do
    p = UKPostcode.new(params[:postcode])
    @postcode = p.norm
    @addresses = Address.where(:postcode => /#{@postcode}/).sort(:address1)
    case content_type
      when :html then
        render 'address/postcode.erb'
      when :json then
        render 'address/postcode.jsonify'
      when :xml then
        render 'address/postcode.builder'
    end
  end

  get :address, :with => :id, :provides => [:html, :json, :xml], :map => '/address' do
    @address = Address.find(params[:id])
    case content_type
      when :html then
        render 'address/address.erb'
      when :json then
        render 'address/address.jsonify'
      when :xml then
        render 'address/address.builder'
    end
  end
  
  get :random, :map => '/random' do
    @address = Address.first(:offset => rand(Address.count))
    render 'address/address.erb'
  end

end