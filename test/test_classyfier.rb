require 'helper'

class TestClassyfier < Test::Unit::TestCase
  
  context "after training on a few items" do
    setup do
      @classyfier = Classyfier::NaiveBayes::NaiveBayesClassifier.new
      @classyfier.train({:name => "derp", :extension => "dta"}, :data)
      @classyfier.train({:name => "malerp", :extension => "dta"}, :data)
      @classyfier.train({:name => "derp malerp", :extension => "pdf"}, :not_data)
      @classyfier.train({:name => "hi", :extension => "dta"}, :data)
    end
    
    should "have stored the priors" do
      assert_equal 3, @classyfier.attribute_counts[:data]['_extension']['dta']
      assert_equal(4, @classyfier.data_size)
    end
  end
end