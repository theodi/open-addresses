def navigation
  routes = []
  FreeThePaf::App.controllers.routes.map { |r| routes << r if r.controller == "static" }
  routes.uniq! { |r| r.path_for_generation }
   
  content = '<ul class="nav">'
 
  routes.each do |r|
    if r.path_for_generation == ""
      title = "Home"
      uri = "/"
    else
      title = r.path_for_generation.gsub('/','').humanize
      uri = r.path_for_generation
    end
    css_class = "active" if uri == request.path_info
    content << "<li class='#{css_class}'><a href='#{uri}'>#{title}</a>"
    css_class = ""
  end
  content
end

def addresscount
  number_with_delimiter(Address.count, ",")
end