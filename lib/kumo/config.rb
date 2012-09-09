require 'yaml'

module Kumo
  # Configuration for EC2
  class Config
    attr_reader :config

    # New configuration
    #
    # +config_file_path+:: configuration file path (YAML)
    # +options+:: instance options
    # +sets+:: configuration sets (applied in order)
    def initialize(config_file_path, options = {}, sets = [])
      set_default_config
      merge_config_file(config_file_path, sets)
      merge_extra_config(options)
      validate_config
    end

    private

    # Validate the configuration
    def validate_config
      if @config[:'access-key-id'].nil? || @config[:'secret-access-key'].nil?
        raise Exception, 'AWS "access key id" and "secret access key" must be included in the configuration file'
      elsif @config[:keypair].nil?
        raise Exception, 'AWS "keypair" is missing'
      end
    end

    # Sets the default configuration. This is the base configuration,
    # which will be merged with other configurations later.
    def set_default_config
      @config = {
        :region => 'us-east-1',
        :'type-id' => 't1.micro',
        :'image-id' => 'ami-a29943cb',  # Ubuntu 12.04
        :groups => ['kumo'],
        :tag => 'kumo'
      }
    end

    # Merge the configuration file, overriding the previous configuration
    def merge_config_file(config_file_path, sets)
      begin
        config_file = YAML.load_file(config_file_path)
      rescue
        raise Exception, "Could not load config file: " + config_file_path
      end

      sets.unshift :default
      sets.each do |set|
        begin
          @config.merge!(config_file[:sets][set])
        rescue
          raise Exception, "The set '" + set.to_s + "' was not found"
        end
      end
    end

    # Merge the extra configuration, overriding the previous configuration
    def merge_extra_config(options)
      options[:groups] = @config[:groups] if options[:groups] && options[:groups].empty?
      @config.merge!(options)
    end
  end
end
