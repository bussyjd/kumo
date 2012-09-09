require 'test_helper'



class ConfigTest < Test::Unit::TestCase
  def test_reads_config_file
    Kumo.initialize_config(KumoTest.config_file_path)
    assert_equal 'kumotest', Kumo.config[:tag]
    assert_equal ['kumo'], Kumo.config[:groups]
  end

  def test_extra_config
    options = { :tag => 'yay', :groups => ['foo'] }
    Kumo.initialize_config(KumoTest.config_file_path, options)
    assert_equal 'yay', Kumo.config[:tag]
    assert_equal ['foo'], Kumo.config[:groups]
  end

  def test_extra_config_with_empty_group
    options = { :groups => [] }
    Kumo.initialize_config(KumoTest.config_file_path, options)
    assert_equal ['kumo'], Kumo.config[:groups]
  end

  def test_sets
    sets = [ :scratch, :medium ]
    Kumo.initialize_config(KumoTest.config_file_path, {}, sets)
    assert_equal 'scratch', Kumo.config[:tag]
    assert_equal 'm1.medium', Kumo.config[:'type-id']
  end

  def test_raises_when_set_does_not_exist
    sets = [ :not_there ]
    e = assert_raises(Exception) do
      Kumo.initialize_config(KumoTest.config_file_path, {}, sets)
    end
    assert_match "'not_there' was not found", e.message
  end

  def test_raises_when_default_set_does_not_exist
    e = assert_raises(Exception) do
      Kumo.initialize_config(KumoTest.config_no_default_set_file_path)
    end
    assert_match "'default' was not found", e.message
  end

  def test_no_credientals
    e = assert_raises(Exception) do
      Kumo.initialize_config(KumoTest.config_no_credentials_file_path)
    end
    assert_match "access key id", e.message
  end

  def test_missing_keypair
    e = assert_raises(Exception) do
      Kumo.initialize_config(KumoTest.config_bare_file_path)
    end
    assert_match '"keypair" is missing', e.message
  end

  def test_raises_when_config_file_does_not_exist
    assert_raises(Exception) do
      Kumo.initialize_config(KumoTest.config_no_file_path, {}, [])
    end
  end
end
