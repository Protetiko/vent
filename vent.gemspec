
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "vent/version"

Gem::Specification.new do |spec|
  spec.name          = "vent"
  spec.version       = Vent::VERSION
  spec.authors       = ["David Sennerlöv"]
  spec.email         = ["ndavidn@gmail.com"]

  spec.summary       = %q{Dead simpe event publishing.}
  spec.description   = %q{Vent makes it dead simple to handle event publishing throughout your applications. Vent use a adapter pattern to make it easily extendable with new publisher. The main concern of Vent is to connect event publishing with publisher adapters. Any transportation method is supported (given a publisher adapter is available), for example publishing to RabbitMQ, Log files and STDOUT. Multiple publishers are supported for events, so a message could be published from one place both to RabbitMQ, internally inside the application and the log file at the same time. Horray!}
  spec.homepage      = "https://github.com/Protetiko/vent"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "sucker_punch", "~> 2.1"
end
