module Classyfier
  module Classifiers
    class English
      attr_accessor :english_dict
      
      def initialize(opts = {:dictionary_size => 50000})
        @dictionary_size = opts[:dictionary_size]
        @english_dict = load_dictionary()
      end
      
      def classify(text)
        words = text.split(" ")
        for word in words
          return true if @english_dict[clean_word(word)]
        end
        return false
      end
    
      protected
        def clean_word(word)
          word.downcase.strip.gsub(/[^a-z ]/, '')
        end
        
        def load_dictionary(filename="english_words.txt", opt={})
          parsed_file = File.open(File.dirname(__FILE__) + "/../data/#{filename}").readlines[0..@dictionary_size].map{|s| s.gsub("\n", "")}
          @english_dict = Hash[parsed_file.map{|s| [s, true]}]
        end
    end
  end
end