require 'test/unit'
require 'debugger'
require 'kumo'


class KumoTest
  class << self
    def test_file(filename)
      File.join(File.dirname(__FILE__), 'files', filename)
    end
    def config_file_path
      test_file 'kumorc.yaml'
    end
    def config_bare_file_path
      test_file 'kumorc_bare.yaml'
    end
    def config_no_credentials_file_path
      test_file 'kumorc_no_credentials.yaml'
    end
    def config_no_default_set_file_path
      test_file 'kumorc_no_default.yaml'
    end
    def config_no_file_path
      test_file 'does_not_exist.yaml'
    end
  end
end
