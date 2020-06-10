lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "teamstuff/version"

Gem::Specification.new do |spec|
  spec.name          = "teamstuff"
  spec.version       = Teamstuff::VERSION
  spec.authors       = ["Rogier Lodewijks"]
  spec.email         = []

  spec.summary       = %q{Gem for accessing Teamstuff programatically}
  spec.description   = %q{Little doodle (for now) to be able to manage our teams a bit more easily using Teamstuff. Using the calls the webapp makes, as no official api has been published by Teamstuff and probably never will.}
  spec.homepage      = "https://haagscherugbyclub.nl"
  spec.license       = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/HaagscheRC/teamstuff-client"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "pry", "> 0.10"
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_dependency "http", "~> 4.0"
  spec.add_dependency "activesupport", "~> 6.0"
end
