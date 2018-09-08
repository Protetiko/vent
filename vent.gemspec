lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vent/version'

Gem::Specification.new do |spec|
  spec.name          = 'vent'
  spec.version       = Vent::VERSION
  spec.authors       = ['David Sennerlöv']
  spec.email         = ['david@proteiko.com']
  spec.license       = 'Nonstandard'

  spec.summary       = %q{Collection of chassis bootstrap modules for service development}
  spec.description   = %q{Web and Consumer service}
  spec.homepage      = "https://dev.protetiko.io"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
#  if spec.respond_to?(:metadata)
#    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
#  else
#    raise "RubyGems 2.0 or newer is required to protect against " \
#      "public gem pushes."
#  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{(\.gem$|^(test|spec|features)\/)})
  end
 # spec.bindir        = "bin"
 # spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
 # spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "pry", "~> 0.11"

  # Consumer Service dependencies
  spec.add_runtime_dependency 'hutch', '~> 0.25'
  spec.add_runtime_dependency 'sucker_punch', ''
  spec.add_runtime_dependency 'wisper', '~> 2'

end
