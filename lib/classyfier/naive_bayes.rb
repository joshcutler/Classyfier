module Classyfier
  module NaiveBayes
    class NaiveBayesClassifier
      attr_reader :data_size
      attr_reader :attribute_counts, :category_counts
      
      def initialize(opts = {})
        @data_size = 0
        @attribute_counts = {}
        @category_counts = {}
        
        @laplacean_smoother = opts[:laplacean_smoother] || 0
        @precision = opts[:precision] ? Float(opts[:precision]**10) : 100000.0
      end
      
      def train(data_hash, category)
        @data_size += 1
        @category_counts[category] ||= 0
        @category_counts[category] += 1
        
        _learn(data_hash, category)
      end
      
      def classify(data_hash)
        category_scores = _category_scores(data_hash)
        max = [:none, 0]
        category_scores.each_pair do |key, value|
          max = [key, value] if value > max[1]
        end
        return max
      end
      
      def category_scores(data_hash)
        category_scores = _category_scores(data_hash)
      end
      
      private
        def _category_scores(data_hash, name='', odds={})
          data_hash.each_pair do |key, value|
            case value
            when String
              value.split(" ").each do |sub_string|
                _calculate_conditional(key, sub_string, name, odds) unless sub_string.strip.empty?
              end
            else
              _calculate_conditional(key, value, name, odds)
            end
          end
          
          #calculate posteriors given data
          posteriors = {}
          odds.keys.each do |category|
            likelihood = 1
            odds[category].each_pair{|key, value| likelihood *= value}
            
            prior = (@category_counts[category] + @laplacean_smoother) / (Float(@data_size) + @laplacean_smoother*@category_counts.keys.size)
            
            marginal = 0
            odds.keys.each do |category2|
              likelihood2 = 1
              odds[category2].each_pair do |key, value| 
                likelihood2 *= value
              end
              marginal +=  likelihood2 * ((@category_counts[category2] + @laplacean_smoother) / (Float(@data_size) + @laplacean_smoother*@category_counts.keys.size))
            end
            
            begin
              posteriors[category] = ((likelihood * prior / marginal)*@precision).round / @precision
            rescue
              posteriors[category] = 0
            end
          end
          
          return posteriors
        end
        
        def _calculate_conditional(key, value, name, odds)
          @attribute_counts.each_pair do |category, raw_counts|
            cat = odds[category] ||= {}
            keys = raw_counts["#{name}_#{key}"] || {}
            total_values = 0
            keys.keys.each {|k| total_values += keys[k]}
            cat["#{name}_#{key}_#{value}"] = Float((keys[value] || 0) + @laplacean_smoother) / (total_values + @laplacean_smoother*keys.keys.length)
          end
        end
      
        def _learn(data_hash, category, name='')
          data_hash.each_pair do |key, value|
            case value
            when String
              value.split(" ").each do |sub_string|
                _store_learned_attribute(key, sub_string, category, name) unless sub_string.strip.empty?
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