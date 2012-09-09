# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','kumo','version.rb'])
spec = Gem::Specification.new do |s|
  s.name = 'kumo'
  s.version = Kumo::VERSION
  s.author = "Michael V. O'Brien"
  s.email = 'michael@michaelvobrien.com'
  s.homepage = 'https://github.com/notbrien/kumo'
  s.platform = Gem::Platform::RUBY
  s.summary = 'Manage workspaces in EC2'
  s.files = %w(
bin/kumo
lib/kumo/commands.rb
lib/kumo/config.rb
lib/kumo/server.rb
lib/kumo/version.rb
lib/kumo.rb
  )
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.rdoc_options << '--title' << 'kumo' << '-ri'
  s.bindir = 'bin'
  s.executables << 'kumo'
  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
  s.add_development_dependency('debugger')
  s.add_runtime_dependency('gli','2.0.0')
  s.add_runtime_dependency('fog')
end
