# Helpers used for devise testing.
#

# Execute the block setting the given values in
# +new_values+ and restoring the old values
# after the block was executed.
#
def swap(object, new_values)
  old_values = {}

  new_values.each do |key, value|
    old_values[key] = object.send key
    object.send(:"#{key}=", value)
  end

  clear_cached_variables(new_values)

  yield
ensure
  clear_cached_variables(new_values)

  old_values.each do |key, value|
    object.send(:"#{key}=", value)
  end
end

def clear_cached_variables(options)
  if options.key?(:case_insensitive_keys) || options.key?(:strip_whitespace_keys)
    Devise.mappings.each do |_, mapping|
      mapping.to.instance_variable_set(:@devise_parameter_filter, nil)
    end
  end
end
