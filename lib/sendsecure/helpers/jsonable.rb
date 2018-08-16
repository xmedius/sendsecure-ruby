module SendSecure
  class JSONable

    def initialize(params)
      params.each do |key, value|
        if value.is_a?(Array)
          value.map! do |v|
            object = to_object(key.to_sym, v)
            v = object unless object.nil?
            v
          end
        else
          object = to_object(key.to_sym, value)
          value = object unless object.nil?
        end
        instance_variable_set("@#{key}", value)
      end
    end

    def to_json(params = {})
      { self.class.name.downcase.gsub(/^.*::/, '') => self.to_hash(params) }
    end

    def ignored_keys(params)
      ["created_at", "updated_at"]
    end

    def to_hash(params = {})
      hash = {}

      if self.respond_to?(:hashable_keys)
        keys = self.hashable_keys(params)
      else
        keys = self.instance_variables
        keys = keys.map { |k| k.to_s.delete "@"}
        keys = keys.delete_if { |k| self.ignored_keys(params).include?(k) }
      end

      keys.each do |key|
        value = self.instance_variable_get "@#{key}"
        if value.is_a?(Array)
          hash[key] = value.map { |v| v.is_a?(JSONable) ? v.to_hash(params) : v }
        else
          hash[key] = value.is_a?(JSONable) ? value.to_hash(params) : value
        end
      end
      hash
    end

    def update_old_attribute(key, value, old_value)
      if old_value.nil?
        new_value = to_object(key.to_sym, value)
        return new_value.nil? ? value : new_value
      elsif old_value.is_a?(JSONable)
        return old_value.update_attributes(value)
      else
        return value
      end
    end

    def update_attributes(params)
      params.each do |key, value|
        old_value = self.instance_variable_get "@#{key}"
        if value.is_a?(Array)
          old_value = [] if old_value.nil?
          for i in 0..(value.size - 1)
            old_value[i] = update_old_attribute(key, value[i], old_value[i])
          end
        else
          old_value = update_old_attribute(key, value, old_value)
        end
        instance_variable_set("@#{key}", old_value)
      end
      self
    end

    def to_object(name, value)
      return nil
    end

  end
end
