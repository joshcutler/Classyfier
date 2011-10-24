require 'helper'

class TestClassyfier < Test::Unit::TestCase
  
  context "after training on a few items" do
    setup do
      @classyfier = Classyfier::NaiveBayes::NaiveBayesClassifier.new
      @classyfier.train({:name => "derp", :extension => "dta"}, :data)
      @classyfier.train({:name => "malerp", :extension => "dta"}, :data)
      @classyfier.train({:name => "derp malerp", :extension => "pdf"}, :not_data)
      @classyfier.train({:name => "foo bar", :extension => "dta"}, :not_data)
      @classyfier.train({:name => "hi", :extension => "dta"}, :data)
    end
    
    should "have stored the priors" do
      assert_equal 3, @classyfier.attribute_counts[:data]['_extension']['dta']
      assert_equal(5, @classyfier.data_size)
    end
    
    context "and classifying an item" do
      setup do
        @scores = @classyfier.classify({:name => "derp hi ", :extension => "dta"})
      end
      
      should "return the proper probability" do
        assert_equal([:data, 1], @scores)
      end
    end
  end
end