require 'kumo/version'

require 'kumo/config'
require 'kumo/server'

module Kumo
  def self.config
    @config
  end
  def self.initialize_config(file_path, options = {}, sets = [])
    @config = Config.new(file_path, options, sets).config
  end
end
