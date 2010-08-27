$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

Dir["#{File.dirname(__FILE__)}/simpleflow/*.rb"].each { |f| load(f) }

module Simpleflow
  VERSION = '0.0.1'

	
  module Modules
		# For Composed modules
    def self.input(params)
			inputName = params["input"]["name"]
		  if params.keys.include?(inputName)
				{"out" => params[inputName] }
			else
				{"out" => params["input"]["value"] }
			end
    end
    
    # For Composed modules
    def self.output(params)
      {"out" => params["in"] }
    end
    
    # Comment do nothing and return nothing
    def self.comment(params)
      {}
    end
	end


	def self.run(config, params = {}, debug = false, find_method = nil)
		
    wires = config["wires"] || []
    modules = config["modules"] || []
        
		# Store the results of each sub-module
    execValues = {} 

		# list all of the modules that we can execute
    moduleIdsToExecute = [] 

		# List all already executed modules
    executedModules = []


    firstTimeInLoop = true
    moreModulesToRun = false
    while moreModulesToRun or firstTimeInLoop do
        firstTimeInLoop = false
      
        # Recalculate all modules that can be executed :
        mId = 0
        modules.each { |m2|
          if !moduleIdsToExecute.include?(mId) and !executedModules.include?(mId) # don't re-execute modules
            mayEval = true
            # runnable if all wires which target is this mId have a source output evaluated.
            wires.each { |w|
              if w["tgt"]["moduleId"] == mId
                if !execValues[ w["src"]["moduleId"] ]
                  mayEval = false
                end
              end
            }            
            moduleIdsToExecute << mId if mayEval
          end  
          mId += 1
        }
      
        if moduleIdsToExecute.size == 0
          moreModulesToRun = false
        else
          moreModulesToRun = true
          
            moduleId = moduleIdsToExecute.shift
            m = modules[moduleId]
        
            # Build the parameters for the execution
            p = {}
            # params passed to the run method
            params.each { |k,v| p[k] = v }

            # default form values
            m["value"].each { |k,v| p[k] = v }

						
						puts "Wires: "+wires.inspect

            # incoming wire params
            wires.each { |w|
              if w["tgt"]["moduleId"] == moduleId
	
								puts "Incoming wire: "+w.inspect
	
								key =  w["tgt"]["terminal"]
								val = execValues[ w["src"]["moduleId"] ][ w["src"]["terminal"] ]
	
								# We simply want to do p[key] = val,
								# except that key might look like   "myvar[1][firstname]"
								# which mean we have to store this val in p["myvar"][1]["firstname"] instead
								push_to = p					
								pathItems = key.scan(/\[([^\]]*)\]/).map { |i| i[0].match(/\d+/) ? i[0].to_i : i[0] }
								if pathItems.size > 0
									push_to = push_to[key.match(/^([^\[]*)/)[0]]
								end
								if pathItems.size > 1
									0.upto(pathItems.size-2) { |i| push_to = push_to[  pathItems[i]  ] }
								end
								if pathItems.size > 0
									key = pathItems.last
								end
                push_to[key] = val

              end
            }


            puts "\n Starting "+m["name"]+" MODULE with : "+p.inspect
        
            # Execute Ruby base modules
            if !Modules.methods.index( m["name"] ).nil?
							begin
              	execValues[moduleId] = Modules.send( m["name"].to_sym, p)
							rescue Exception => e
								puts "Simpleflow "+e.message
							end

            else
              # Try to execute composed module
							if find_method
								w = find_method.call(m["name"])
								if !w
									raise "Module "+m["name"]+" not found !"
								end
	              execValues[moduleId] = Simpleflow.run(w, p, false, find_method)
							else
								raise "Module "+m["name"]+" not found !"
							end
															
            end
        
						puts "\n Finished "+m["name"]+" MODULE with : "+execValues[moduleId].inspect
            

            # Mark this modules as executed
            executedModules.push(moduleId)
      
        end
        
    end  
    
    # Return internal execution values if debug mode
    return execValues if debug
 
    
    # OUTPUTS 
	  outputValues = {}
    moduleIndex = 0
	  modules.each { |m|
	    if m["name"] == "output"
	      wires.each { |w|
	        if w["tgt"]["moduleId"] == moduleIndex and execValues[w["src"]["moduleId"]]
	          outputValues[m["value"]["name"]] = execValues[w["src"]["moduleId"]][ w["src"]["terminal"] ]
          end
        }
      end
      moduleIndex += 1
    }
    return outputValues
		
	end
	
	
end