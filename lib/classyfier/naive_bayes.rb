module Classyfier
  module NaiveBayes
    class NaiveBayesClassifier
      attr_reader :data_size
      
      def initialize()
        @data_size = 0
        @attribute_counts = {}
      end
      
      def train(data_hash, category)
        @data_size += 1
        _learn(data_hash, category)
      end
      
      private
        def _learn(data_hash, category, name='')
          data_hash.each_pair do |key, value|
            case value
            when Hash
              _learn(value, category, "#{name}_#{key}")
            when String
              value.split(" ").each do |sub_string|
                _store_learned_attribute(key, sub_string, category, name) unless sub_string.blank?
              end
            else
              _store_learned_attribute(key, value, category, name)
            end
          end
        end
        
        def _store_learned_attribute(key, value, category, name)
          cat = (@attribute_counts[category] ||= {})
          values = (cat["#{name}_#{key}"] ||= {})
          values[value] ||= 0
          values[value] += 1
        end
    end
  end
end