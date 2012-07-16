module Classyfier
  module Classifiers
    class USRegions
      SOUTH = "south"
      WEST = "west"
      MIDWEST = "midwest"
      NORTHEAST = "northeast"
      
      REGIONS = [SOUTH, WEST, MIDWEST, NORTHEAST]
      
      def initialize()
        @codes = {
          "AK" => WEST, 
          "AL" => SOUTH, 
          "AR" => SOUTH, 
          "AZ" => WEST, 
          "CA" => WEST, 
          "CO" => WEST, 
          "CT" => NORTHEAST, 
          "DC" => NORTHEAST, 
          "DE" => NORTHEAST, 
          "FL" => SOUTH, 
          "GA" => SOUTH, 
          "HI" => nil, 
          "IA" => MIDWEST, 
          "ID" => WEST, 
          "IL" => MIDWEST, 
          "IN" => MIDWEST, 
          "KS" => MIDWEST, 
          "KY" => SOUTH, 
          "LA" => SOUTH, 
          "MA" => NORTHEAST, 
          "MD" => NORTHEAST, 
          "ME" => NORTHEAST, 
          "MI" => MIDWEST, 
          "MN" => MIDWEST, 
          "MO" => MIDWEST, 
          "MS" => SOUTH, 
          "MT" => WEST, 
          "NC" => SOUTH, 
          "ND" => MIDWEST, 
          "NE" => MIDWEST, 
          "NH" => NORTHEAST, 
          "NJ" => NORTHEAST, 
          "NM" => WEST, 
          "NV" => WEST, 
          "NY" => NORTHEAST, 
          "OH" => MIDWEST, 
          "OK" => MIDWEST, 
          "OR" => WEST, 
          "PA" => NORTHEAST, 
          "RI" => NORTHEAST, 
          "SC" => SOUTH, 
          "SD" => MIDWEST, 
          "TN" => SOUTH, 
          "TX" => SOUTH, 
          "UT" => WEST, 
          "VA" => SOUTH, 
          "VT" => NORTHEAST, 
          "WA" => WEST, 
          "WI" => MIDWEST, 
          "WV" => SOUTH, 
          "WY" => WEST }
      
        @names = {"alaska"=>"AK", "alabama"=>"AL", "arkansas"=>"AR", "american samoa"=>"AS", "arizona"=>"AZ", "california"=>"CA", "colorado"=>"CO", "connecticut"=>"CT", "district of columbia"=>"DC", "delaware"=>"DE", "florida"=>"FL", "georgia"=>"GA", "guam"=>"GU", "hawaii"=>"HI", "iowa"=>"IA", "idaho"=>"ID", "illinois"=>"IL", "indiana"=>"IN", "kansas"=>"KS", "kentucky"=>"KY", "louisiana"=>"LA", "massachusetts"=>"MA", "maryland"=>"MD", "maine"=>"ME", "michigan"=>"MI", "minnesota"=>"MN", "missouri"=>"MO", "northern mariana islands"=>"MP", "mississippi"=>"MS", "montana"=>"MT", "north carolina"=>"NC", "north dakota"=>"ND", "nebraska"=>"NE", "new hampshire"=>"NH", "new jersey"=>"NJ", "new mexico"=>"NM", "nevada"=>"NV", "new york"=>"NY", "ohio"=>"OH", "oklahoma"=>"OK", "oregon"=>"OR", "pennsylvania"=>"PA", "puerto rico"=>"PR", "rhode island"=>"RI", "south carolina"=>"SC", "south dakota"=>"SD", "tennessee"=>"TN", "texas"=>"TX", "united states minor outlying islands"=>"UM", "utah"=>"UT", "virginia"=>"VA", "virgin islands"=>"VI", "vermont"=>"VT", "washington"=>"WA", "wisconsin"=>"WI", "west virginia"=>"WV", "wyoming"=>"WY"}
        
        @regional_coords = {
          SOUTH => {
            :top => 37,
            :bottom => 30,
            :right => 75,
            :left => 100 
          },
          WEST => {
            :top => 48,
            :bottom => 32,
            :right => 103,
            :left => 125 
          },
          MIDWEST => {
            :top => 48,
            :bottom => 30,
            :right => 80,
            :left => 35 
          },
          NORTHEAST => {
            :top => 48,
            :bottom => 37,
            :right => 65,
            :left => 80 
          },
        }
      end
      
      def classify(opts = {:lat => nil, :long => nil, :text => nil})
        if opts[:lat] && opts[:long]
          for region in REGIONS
            if opts[:long] >= @regional_coords[region][:right] &&
               opts[:long] <= @regional_coords[region][:left] &&
               opts[:lat] >= @regional_coords[region][:bottom] &&
               opts[:lat] <= @regional_coords[region][:top]
              return region
            end
          end
          return nil
        end
        
        unless !opts[:text]
          chunks = opts[:text].split(" ")
          for word in chunks
            cleanword = clean_word(word.downcase)
            
            state = cleanword.upcase if @codes[cleanword.upcase]
            state = @names[cleanword] if !state && @names[cleanword]

            return @codes[state] if state
          end
        end
      end
      
      protected
        def clean_word(word)
          word.downcase.strip.gsub(/[^a-z]/, '')
        end
    end
  end
end