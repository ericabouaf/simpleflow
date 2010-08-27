module Simpleflow
  module Modules
    
      def self.JSONparse(params)
				require 'yajl'
				parser = Yajl::Parser.new
        { "out" => parser.parse(params["in"]) }
      end

	end
end