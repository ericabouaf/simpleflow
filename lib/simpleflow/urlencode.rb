module Simpleflow
  module Modules

	  def self.urlencode(params)
		  require 'cgi'
	    { "out" => CGI::escape(params["in"]) }
	  end

	end
end