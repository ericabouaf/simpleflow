require File.dirname(__FILE__) + '/test_helper.rb'

class TestSimpleflow < Test::Unit::TestCase

  def setup
  end
  
  def test_empty_run
	
		result = Simpleflow::run({
			"modules" => [],
			"wires" => []
		})
	
    assert_equal Hash, result.class
		assert_equal 0, result.keys.size

  end


	def test_YQL_debug
		
		result = Simpleflow::run({
			"modules" => [
				{
					"name" => "YQL",
					"value" => {
							"query"=>"select * from feed where url='http://rss.news.yahoo.com/rss/topstories' limit 2"
					}
				}
			],
			"wires" => []
		}, {}, true)
	
		#puts result.inspect
		#assert result
		# TODO:
    #assert_equal Hash, result.class
		#assert_equal 0, result.keys.size
		
		
	end



end
