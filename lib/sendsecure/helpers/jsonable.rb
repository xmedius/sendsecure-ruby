module SendSecure

    class JSONable
      def initialize(params)
        params.each do |key, value|
          instance_variable_set("@#{key}", value)
        end
      end

      def to_json
        { self.class.name.downcase.gsub(/^.*::/, '') => self.to_hash }
      end

      def to_hash(ignored_keys = [])
        hash = {}
        self.instance_variables.each do |var|
          key = var.to_s.delete "@"
          unless ignored_keys.include?(key)
            value = self.instance_variable_get var
            if value.is_a?(Array)
              hash[key] = value.map { |v| v.is_a?(JSONable) ? v.to_hash : v }
            else
              hash[key] = value.is_a?(JSONable) ? value.to_hash : value
            end
          end
        end
        hash
      end
    end


end