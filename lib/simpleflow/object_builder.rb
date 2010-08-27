module Simpleflow
  module Modules
		
   
      def self.ObjectBuilder(params)
					o = {}
          params["items"].each { |v|
							o[v[0]] = v[1]
        	}
        { "out" => o }
      end

	end
end