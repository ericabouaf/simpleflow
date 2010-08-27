module Simpleflow
  module Modules
 
    # Liquid Templating
    def self.liquid(params)
			require 'liquid'
			r = Liquid::Template.parse(params["template"]).render 'params' => params["in"]
			{ "out" => r }
    end

  end
end