require "csv"

module Classyfier
  module Classifiers
    class Gender
      def initialize(opts = {})
        #Load the dictionaries
        @male_census = load_dictionary("census_male_1990.dat")
      end
    
      protected
        def load_dictionary(filename)
          parsed_file = CSV.read(File.dirname(__FILE__) + "/lib/data/#{filename}", { :col_sep => "\t" }) 
        end
    end
  end
end