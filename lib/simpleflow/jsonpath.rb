module Simpleflow
  module Modules

    # JSONPath module
    # cf http://github.com/bruce/jsonpath
    def self.JSONPath(params)
				require 'jsonpath'
				
				begin
					out = JSONPath.lookup( params["in"], params["path"])
				rescue Exception => e
					out = {:error => e.message}
				end
				
				if params["firstonly"]
					out = out[0]
				end
				
        { "out" =>  out }
    end
		

	end
end