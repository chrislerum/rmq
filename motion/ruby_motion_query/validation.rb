module RubyMotionQuery
  class RMQ
    # @return [Validation]
    def self.validation
      Validation
    end

    # @return [Validation]
    def validation
      Validation
    end
  end

  class Validation
    class << self
      # Validation Regex from jQuery validation -> https://github.com/jzaefferer/jquery-validation/blob/master/src/core.js#L1094-L1200
      EMAIL = Regexp.new('^[a-zA-Z0-9.!#$%&\'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$')
      URL = Regexp.new('^(https?|s?ftp):\/\/(((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&\'\(\)\*\+,;=]|:)*@)?(((\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5]))|((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?)(:\d*)?)(\/((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&\'\(\)\*\+,;=]|:|@)+(\/(([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&\'\(\)\*\+,;=]|:|@)*)*)?)?(\?((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&\'\(\)\*\+,;=]|:|@)|[\uE000-\uF8FF]|\/|\?)*)?(#((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&\'\(\)\*\+,;=]|:|@)|\/|\?)*)?$')
      DATEISO = Regexp.new('^\d{4}[\/\-](0?[1-9]|1[012])[\/\-](0?[1-9]|[12][0-9]|3[01])$')
      NUMBER = Regexp.new('^-?(?:\d+|\d{1,3}(?:,\d{3})+)?(?:\.\d+)?$')
      DIGITS = Regexp.new('^\d+$')
      # Other Fun by http://www.freeformatter.com/regex-tester.html
      IPV4 = Regexp.new('^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$')
      TIME = Regexp.new('^(20|21|22|23|[01]\d|\d)((:[0-5]\d){1,2})$')
      # Future Password strength validations -> http://stackoverflow.com/questions/5142103/regex-for-password-strength
      USZIP = Regexp.new('^\d{5}(-\d{4})?$')
      # 7 or 10 digit number, delimiters are spaces, dashes, or periods
      USPHONE = Regexp.new('^(?:(?:\+?1\s*(?:[.-]\s*)?)?(?:(\s*([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9]‌​)\s*)|([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9]))\s*(?:[.-]\s*)?)?([2-9]1[02-‌​9]|[2-9][02-9]1|[2-9][02-9]{2})\s*(?:[.-]\s*)?([0-9]{4})$')


      @@validation_methods = {
        :email => lambda { |value| Validation.regex_match?(value, EMAIL)},
        :url => lambda { |value| Validation.regex_match?(value, URL)},
        :dateiso => lambda { |value| Validation.regex_match?(value, DATEISO)},
        :number => lambda { |value| Validation.regex_match?(value, NUMBER)},
        :digits => lambda { |value| Validation.regex_match?(value, DIGITS)},
        :ipv4 => lambda { |value| Validation.regex_match?(value, IPV4)},
        :time => lambda { |value| Validation.regex_match?(value, TIME)},
        :uszip => lambda { |value| Validation.regex_match?(value, USZIP)},
        :usphone => lambda { |value| Validation.regex_match?(value, USPHONE)}
      }

      # Add tags
      # @example
      #    rmq.validation.valid?('test@test.com', :email)
      #    rmq.validation.valid?(53.8, :number)
      #    rmq.validation.valid?(54, :digits)
      #    rmq.validation.valid?('https://www.tacoland.com', :url)
      #    rmq.validation.valid?('2014-03-02'), :dateiso)
      #
      # @return [Boolean]
      def valid?(value, *rule_or_rules)
        rule_or_rules.each do |rule|
          # only supported validations
          raise "RMQ validation error: :#{rule} is not one of the supported validation methods." unless @@validation_methods.include?(rule)
          #return false if validation_failed
          return false unless @@validation_methods[rule].call(value)
        end
        true
      end

      def regex_match?(value, regex)
        (value.to_s =~ regex) == 0
      end

    end
  end
end