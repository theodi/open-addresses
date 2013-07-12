require 'sinatra/base'
require 'jsonify/tilt'
 
class JsonifySinatra < Sinatra::Base
  helpers do
    def jsonify(*args) render(:jsonify, *args) end
  end
end