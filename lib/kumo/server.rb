require 'fog'

module Kumo
  # The server is an EC2 instance
  class Server
    include Comparable

    # Find an instance by id
    #
    # +id+:: the id of the instance
    def self.find_by_id(id)
      Server.new(infra.servers.get(id))
    end

    # Find all instances
    def self.find_all
      infra.servers.select do |server|
        (server.tags["Name"] == Kumo.config[:tag]) && (server.state != "terminated")
      end.map do |server|
        Server.new(server)
      end.sort
    end

    # Launch an instance
    def self.launch
      Server.new(infra.servers.create(
        :image_id => Kumo.config[:'image-id'],
        :flavor_id => Kumo.config[:'type-id'],
        :key_name => Kumo.config[:keypair],
        :groups => Kumo.config[:groups],
        :tags => { 'Name' => Kumo.config[:tag] }
      ))
    end

    # Create a new instance based on a fog server
    def initialize(fog_server)
      @server = fog_server
    end

    # Get the ID of the instance
    def id
      @server.id
    end

    # Get the launch time of the instance
    def launch_time
      @server.created_at
    end

    # Get the running state of the instance
    def state
      @server.state
    end

    # Get the tag of the instance
    def tag
      @server.tags['Name']
    end

    # Get the public DNS of the instance
    def public_dns
      @server.dns_name
    end

    # Get the private DNS of the instance
    def private_dns
      @server.private_dns_name
    end

    # Terminate the instance
    def terminate
      @server.destroy
    end

    # Start the instance
    def start
      if @server.state == "stopped"
        @server.start
      end
    end

    # Stop the instance
    def stop
      if @server.state == "running"
        @server.stop
      end
    end

    # :nodoc:
    def <=>(other_server)
      if self.launch_time < other_server.launch_time
        -1
      elsif self.launch_time > other_server.launch_time
        1
      else
        0
      end
    end

    private

    # The connection to EC2
    def self.infra
      @fog ||= Fog::Compute.new(
        :provider => 'AWS',
        :region => Kumo.config[:region],
        :aws_access_key_id => Kumo.config[:'access-key-id'],
        :aws_secret_access_key => Kumo.config[:'secret-access-key']
      )
    end
  end
end
