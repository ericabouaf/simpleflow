
module Simpleflow
  module Modules
    
		# Ping
		def self.ping(params)
			require 'ping'
			{ "out" => Ping.pingecho(params["hostname"], params["timeout"], params["service"]) }
		end

  end
end