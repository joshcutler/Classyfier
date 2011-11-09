require 'helper'

class TestClassyfier < Test::Unit::TestCase
  
  context "after training on a few items with no smoothing" do
    setup do
      @classyfier = Classyfier::NaiveBayes::NaiveBayesClassifier.new
      @classyfier.train({:name => "derp", :extension => "dta"}, :data)
      @classyfier.train({:name => "malerp", :extension => "dta"}, :data)
      @classyfier.train({:name => "hi", :extension => "dta"}, :data)
      @classyfier.train({:name => "derp malerp", :extension => "pdf"}, :not_data)
      @classyfier.train({:name => "foo bar", :extension => "dta"}, :not_data)
    end
    
    should "have stored the priors" do
      assert_equal 3, @classyfier.attribute_counts[:data]['_extension']['dta']
      assert_equal(5, @classyfier.data_size)
      assert_equal(3, @classyfier.category_counts[:data])
      assert_equal(2, @classyfier.category_counts[:not_data])
    end
    
    context "and classifying an item" do
      setup do
        @scores = @classyfier.classify({:name => "derp hi", :extension => "dta"})
        @scores1 = @classyfier.classify({:name => "malerp", :extension => "dta"})
        @scores2 = @classyfier.classify({:extension => "pdf"})
        @scores3 = @classyfier.classify({:extension => "unknown"})
      end
      
      should "return the proper probability" do
        # P(data|"derp hi") = P("derp hi"|data)*P(data) / P("derp hi") = P("derp hi"|data)*P(data) / P("derp hi"|data)P(data) + P("derp hi|not")P(not)  = 
        # P("derp"|data)*P("hi"|data)P(dta|data)*P(data) / P("derp"|data)P(hi"|data)P(dta|data)P(data) + P("derp"|not)P("hi"|not)P(dta|data)P(not)
        # (1/3)(1/3)(3/3)(3/5)/((1/3)(1/3)(3/3)(3/5) + (1/4)(0/4)(1/2)(2/5))
        assert_equal([:data, 1], @scores)
        # P("malerp"|data)P(dta|data)P(data)/P("malerp"|data)P(dta|data)P(data) + P("malerp"|not_data)P(dta|not_data)P(not_data)
        # (.333*1*.6)/(.333*1*.6+.25*.5*.4)
        assert_equal([:data, 0.8], @scores1)
        assert_equal([:not_data, 1], @scores2)
        assert_equal([:none, 0], @scores3)
      end
    end
  end
  
  context "after training on a few items with smoothing" do
    setup do
      @classyfier = Classyfier::NaiveBayes::NaiveBayesClassifier.new(:laplacean_smoother => 1)
      @classyfier.train({:name => "derp", :extension => "dta"}, :data)
      @classyfier.train({:name => "malerp", :extension => "dta"}, :data)
      @classyfier.train({:name => "derp malerp", :extension => "pdf"}, :not_data)
      @classyfier.train({:name => "foo bar", :extension => "dta"}, :not_data)
      @classyfier.train({:name => "hi", :extension => "dta"}, :data)
    end
    
    should "have stored the priors" do
      assert_equal 3, @classyfier.attribute_counts[:data]['_extension']['dta']
      assert_equal(5, @classyfier.data_size)
      assert_equal(3, @classyfier.category_counts[:data])
      assert_equal(2, @classyfier.category_counts[:not_data])
    end
    
    context "and classifying an item" do
      setup do
        @scores = @classyfier.classify({:name => "derp hi", :extension => "dta"})
        @scores1 = @classyfier.classify({:name => "malerp", :extension => "dta"})
        @scores2 = @classyfier.classify({:extension => "pdf"})
        @scores3 = @classyfier.classify({:extension => "unknown"})
      end
      
      should "return the proper probability" do
        # P(data|"derp hi") = P("derp hi"|data)*P(data) / P("derp hi") = P("derp hi"|data)*P(data) / P("derp hi"|data)P(data) + P("derp hi|not")P(not)  = 
        # P("derp"|data)*P("hi"|data)*P(dta|data)*P(data) / P("derp"|data)P(hi"|data)P(dta|data)P(data) + P("derp"|not)P("hi"|not)P(dta|not)P(not)
        #((1+1)/(3+3))((1+1)/(3+3))((3+1)/(3+1))((3+1)/(5+2))/(((1+1)/(3+3))((1+1)/(3+3))((3+1)/(3+1))((3+1)/(5+2)) + ((1+1)/(4+4))((0+1)/(4+4))((1+1)/(2+2))((2+1)/(5+2)))
        assert_equal([:data, 0.90459], @scores)
        assert_equal([:data, 0.78049], @scores1)
        assert_equal([:not_data, 0.6], @scores2)
        assert_equal([:data, 0.57143], @scores3)
      end
    end
  end
end