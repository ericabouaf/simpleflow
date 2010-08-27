module Simpleflow
  module Modules
		
   
      def self.StringBuilder(params)
        list = params["liste"].dup
        params.each { |k,v|
          if !k.index('[').nil?
            index = k.split('[')[1].split(']')[0].to_i
            list[index]=v
          end
        }
        { "out" => list.join() }
      end

	end
end