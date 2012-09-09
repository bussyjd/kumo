module Kumo
  # Commands for managing instances
  class Commands
    class << self
      # List all instances with the same tag
      #
      # Example:
      #
      #     kumo list
      def list(global_options, options, args)
        Kumo.initialize_config(File.expand_path(global_options[:'config-file']), sanitize_options(options), parse_sets(options))
        Kumo::Server.find_all.each { |server| puts "%-15s%-15s%-15s%-30s%-45s" % [server.id, server.tag, server.state, server.launch_time.localtime, server.public_dns] }
      end

      # Launch an instance
      #
      # Examples:
      #
      #     kumo launch
      def launch(global_options, options, args)
        Kumo.initialize_config(File.expand_path(global_options[:'config-file']), sanitize_options(options), parse_sets(options))
        puts Kumo::Server.launch.id
      end

      # Terminate an instance
      #
      # Examples:
      #
      #     kumo terminate
      def terminate(global_options, options, args)
        Kumo.initialize_config(File.expand_path(global_options[:'config-file']), sanitize_options(options))
        if args[0]
          Kumo::Server.find_by_id(args[0]).terminate
        else
          last_server.terminate
        end
      end

      # Start an instance
      #
      # Examples:
      #
      #     kumo start
      def start(global_options, options, args)
        Kumo.initialize_config(File.expand_path(global_options[:'config-file']), sanitize_options(options))
        if args[0]
          Kumo::Server.find_by_id(args[0]).start
        else
          last_server.start
        end
      end

      # Stop an instance
      #
      # Examples:
      #
      #     kumo stop
      def stop(global_options, options, args)
        Kumo.initialize_config(File.expand_path(global_options[:'config-file']), sanitize_options(options))
        if args[0]
          Kumo::Server.find_by_id(args[0]).stop
        else
          last_server.stop
        end
      end

      # Print the public DNS of an instance
      #
      # Examples:
      #
      #     kumo dns
      def dns(global_options, options, args)
        Kumo.initialize_config(File.expand_path(global_options[:'config-file']), sanitize_options(options))
        if args[0]
          puts Kumo::Server.find_by_id(args[0]).public_dns
        else
          puts last_server.public_dns
        end
      end

      private

      # Parse the sets
      def parse_sets(options)
        if options[:sets]
          options[:sets].split(',').map { |s| s.to_sym }
        else
          []
        end
      end

      # Parse the groups
      #
      # +groups_string+:: a string containing a list of comma separated groups
      #
      # Returns an +array+ of +symbols+
      def parse_groups(groups_string)
        groups_string.split(',').map { |g| g.to_sym }
      end

      # Sanitize the options, keeping only those that are defined
      #
      # +options+:: configuration options
      #
      # Returns a +hash+ suitable to initialize the main configuration
      def sanitize_options(options)
        sanitized = {}
        [:keypair, :region, :'type-id', :tag].each do |o|
          sanitized[o] = options[o] unless options[o].nil?
        end

        unless options[:groups].nil?
          sanitized[:groups] = parse_groups(options[:groups])
        end

        sanitized
      end

      # Returns the last server that was launched/started
      def last_server
        Kumo::Server.find_all.last
      end
    end
  end
end
