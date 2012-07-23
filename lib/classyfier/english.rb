module Classyfier
  module Classifiers
    class English
      attr_accessor :english_dict
      
      def initialize(opts = {:dictionary_size => 50000})
        @dictionary_size = opts[:dictionary_size]
        @english_dict = load_dictionary()
      end
      
      def classify(text, opts = {:word_count => 1, :word_size => 1})
        words = text.split(" ")
        count = 0
        for word in words
          next if word.length < opts[:word_size]
          count += 1 if @english_dict[clean_word(word)]
          break if count >= opts[:word_count]
        end
        return count >= opts[:word_count]
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