FreeThePaf::App.controllers :static do
  get :index, :map => '/' do
    render 'static/index'
  end

  get :about, :map => '/about' do
    render 'static/about', :layout_engine => :erb, :layout => :application
  end

  get :data, :map => '/data' do
    render 'static/data', :layout_engine => :erb, :layout => :application
  end    

  get :license, :map => '/license' do
    render 'static/license', :layout_engine => :erb, :layout => :application
  end

  get :sources, :map => '/sources' do
    render 'static/sources', :layout_engine => :erb, :layout => :application
  end
end