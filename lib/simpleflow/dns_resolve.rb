module Simpleflow
  module Modules

	  def self.getIpsFromDomain(params)
		  require 'resolv'
  
	    hosts = []
	    dns = Resolv::DNS.new
	    dns.getresources(params["domain"], Resolv::DNS::Resource::IN::A).collect do |r| 
	       hosts << r.address.to_s
	    end
	    { "hosts" => hosts }
	  end

	end
end