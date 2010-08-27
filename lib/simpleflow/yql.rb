module Simpleflow
  module Modules
    

##############################
# Keep ME !!! The advantage of this version is that we can look the response of YQL to check if 
# there is an error and format it to a Simpleflow error ! (like invalid YQL query...)
##############################
			
      # def self.YQL(params)
      # 
      # 				require 'yajl'
      # 				require 'cgi'
      # 	
      # 				if !params["query"].is_a?(String)
      # 					return { "out" => "Error: expecting query as a string"}
      # 				elsif params["query"] == ""
      # 					return { "out" => "Error: empty query"}
      # 				end
      # 				
      #         require 'net/http'
      #         require 'uri'
      #         url = URI.parse('http://query.yahooapis.com')
      #         res = Net::HTTP.start(url.host, url.port) { |http|
      #           http.get('/v1/public/yql?q='+CGI::escape(params["query"])+'&format=json')
      #         }
      # 
      # 				 parser = Yajl::Parser.new
      # 				 hash = parser.parse(res.body)
      # 
      #         { "out" => hash }
      #       end

			def self.YQL(params)
				Simpleflow.run({
					"modules" => [

						{
							"name" => "input",
							"value" => {
								"input" => { "value" => 'show tables' , "name" => "query" }
							}
						},

						{
							"name" => "HTTP",
							"value" => {
									"method"=>"GET",
									"url"=> 'http://query.yahooapis.com/v1/public/yql',
									"urlparams"=>[
										["format","json"],
										["q", 		""], # the [1,1] element is wired
										["env", "store://datatables.org/alltableswithkeys"]
									]
							}
						},

						{	"name" => "output","value" => {"in" => '', "name" => "out"}	}

					],
					"wires" => [
						{
							"src" => {"moduleId" => 0 , "terminal" => "out"},
							"tgt" => {"moduleId" => 1 , "terminal" => "urlparams[1][1]"}
						},
						{
							"src" => {"moduleId" => 1 , "terminal" => "out"},
							"tgt" => {"moduleId" => 2 , "terminal" => "in"}
						}
					]
				}, params)
			end

	end
end