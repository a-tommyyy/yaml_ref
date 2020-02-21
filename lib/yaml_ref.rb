require "yaml_ref/version"
require "yaml"

module YamlRef
  class Error < StandardError; end

  class << self
    #
    # @params [String] path
    # @return [Object]
    #
    # If ref path is defined as a relative path from a specific location,
    # pass ref_home argument or define ref_home on root level in YAML file.
    #
    def load_file(path, ref_home: nil)
      result = ERB.new(File.read(path)).result
      schema = YAML.load(result)
      @ref_home = ref_home || schema["ref_home"]
      parse_schema(schema, path)
    end

    private

    #
    # @private
    #
    # @params [Array | Hash] schema
    # @params [String] path]
    #
    # @return [Array | hash]
    #
    def parse_schema(schema, path)
      case
      when schema.is_a?(Hash)
        parse_hash_schema(schema, path)
      when schema.is_a?(Array)
        parse_array_schema(schema, path)
      else
        schema
      end
    end

    #
    # @private
    #
    # @params [Hash] schema
    # @params [String] path
    #
    # @return [hash]
    #
    def parse_hash_schema(schema, path)
      schema.inject({}) do |hash, (key, value)|
        # in this case, value must be String.
        if key == "$ref"
          if value.start_with?("#")
            # It does not be resolved because
            # Most Services, such as swaggerUI,
            # provide the feature to resolve json key references.
            # e.g.
            #   $ref: "#/components/schemas/User"
            break { key => value }
          else
            # Value can be file path.
            # e.g.
            #   $ref: "../reference.yml"
            break parse_schema(*file_ref(path, value))
          end
        else
          hash[key] = parse_schema(value, path)
          hash
        end
      end
    end

    #
    # @private
    #
    # @params [Array] schema
    # @params [String] path
    #
    # @return [Array]
    #
    def parse_array_schema(schema, path)
      schema.inject([]) do |array, element|
        array << parse_schema(element, path)
        array
      end
    end

    def file_ref(filepath, refpath)
      filepath = File.dirname(filepath) unless File.directory?(filepath)
      path = File.expand_path(File.join(@ref_home || filepath, refpath))
      raise(Error, <<~MESSAGE) unless File.exist?(path)
      No such yml file -- #{path}
      MESSAGE
      [YAML.load_file(path), path]
    end
  end
end
