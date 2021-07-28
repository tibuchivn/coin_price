require_relative 'lib/coin_price/version'

Gem::Specification.new do |spec|
  spec.name          = "coin_price"
  spec.version       = CoinPrice::VERSION
  spec.authors       = ["Tung Tram"]
  spec.email         = ["tung@tinypulse.com"]

  spec.summary       = 'A cli tool to get coin price from coingecko'
  spec.description   = 'A cli tool to get coin price from coingecko'
  spec.homepage      = 'https://tibuchivn.com'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://tibuchivn.com"
  spec.metadata["changelog_uri"] = "https://tibuchivn.com"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'thor'
  spec.add_dependency 'coingecko_ruby'

  spec.add_development_dependency 'byebug'
end
