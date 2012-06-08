require "csv"

module Classyfier
  module Classifiers
    class Gender
      def initialize(opts = {:dictionary => :popular})
        #Load the dictionaries
        if opts[:dictionary] == :popular
          @male_dict = load_dictionary("popular_male_names_1960-2010.dat")
          @female_dict = load_dictionary("popular_female_names_1960-2010.dat")
        else
          @male_dict = load_dictionary("census_male_1990.dat")
          @female_dict = load_dictionary("census_female_1990.dat")
        end
      end
      
      def classify(name)
        male_score = @male_dict[name.downcase].to_f || -1
        female_score = @female_dict[name.downcase].to_f || -1
        
        return {:male => 0, :female => 1} if male_score < 0 and female_score > 0
        return {:male => 1, :female => 0} if male_score > 0 and female_score < 0
        return {:male => 0, :female => 0} if male_score == 0 and female_score == 0
        return {:male => male_score/(male_score + female_score), :female => female_score/(male_score + female_score)} 
      end
    
      protected
        def load_dictionary(filename)
          parsed_file = CSV.read(File.dirname(__FILE__) + "/../data/#{filename}", { :col_sep => "\t" })
          Hash[*parsed_file.flatten.map{|n| n.downcase}]
        end
    end
  end
end