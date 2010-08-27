module Simpleflow
  module Modules
    			
			# HTTP
						
			# TODO: proxy 
			# TODO: timeout
			# TODO: additional headers
			# TODO: allow cookies
			# TODO: whether or not to follow redirects
			
			
			def self.HTTP(params)
	
        require 'net/http'
				require 'net/https'
        require 'uri'
        require 'cgi'


					require 'yajl'

        uri = URI.parse(params["url"])
				path = uri.request_uri
					
				# Parameters / Body
				body = nil
				
				# Raw request
				httpClass = case params["method"]
				   when "GET" then Net::HTTP::Get
				   when "PUT" then Net::HTTP::Put
					 when "POST" then Net::HTTP::Post
				   when "DELETE" then  Net::HTTP::Delete
				   when "OPTIONS" then Net::HTTP::Options
				end
				raw_request = httpClass.new(path)

				case params["method"]
				   when "GET" , "DELETE"  
							path += "?"+ params["urlparams"].map { |p| p[0].to_s+"="+CGI::escape(p[1].to_s) }.join('&')
							raw_request = httpClass.new(path)
				   when "PUT" , "POST" 
							body = case params["encoding"]
								when "application/json" then 
									raw_request["content-type"] = "application/json"
									params["urlparams"].to_json
								when "application/xml" then 
										raw_request["content-type"] = "application/xml"
										params["urlparams"].to_xml
								when "application/x-www-form-urlencoded" then 
										raw_request["content-type"] = "application/x-www-form-urlencoded"
										params["urlparams"].map { |p| p[0].to_s+"="+CGI::escape(p[1].to_s) }.join('&')
							end
				end
				
				raw_request.body = body if body
				
				# Basic Auth
				raw_request.basic_auth(uri.user, uri.password) if uri.user
					
				# HTTPS
			  http = Net::HTTP.new(uri.host, uri.port) 
				http.use_ssl = true if uri.scheme == "https"
				
				
				# Perform 
			  res = http.start{ |h| h.request(raw_request) }
			
				o = res.body
			
				case res
			  	when Net::HTTPSuccess then
			     
						# Parsing
						puts "HTTP res content-type : "+res.content_type
						
						if (res.content_type == "application/xml") or (res.content_type == "text/xml")
							o = Hash.from_xml(res.body)
						elsif res.content_type == "application/json"
							
							parser = Yajl::Parser.new
			        o = parser.parse(res.body)
			
						else 
							o = res.body
						end
						
		        { "out" => o }

					when Net::HTTPRedirection then

						{ "out" => res.error! }

					else
						
						{ "out" => res.error! }
						
				end
			
      end

   end       
end