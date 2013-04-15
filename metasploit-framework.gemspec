# -*- encoding: utf-8 -*-
lib_path = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift lib_path

require 'metasploit/framework/version'

Gem::Specification.new do |gem|
	gem.authors       = [
			'Metasploit Hackers'
	]
	gem.description   = 'Exploit development, penetration testing and security auditing framework'
	gem.email         = [
			'metasploit-hackers@lists.sourceforge.net'
	]
	gem.homepage      = 'http://www.metasploit.com'
	gem.name          = 'metasploit-framework'
	gem.require_paths = ['lib']
	gem.summary       = 'Metasploit Framework'
	gem.version       = Metasploit::Framework::Version::FULL

	gem.files         = `git ls-files`.split($\)
	gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
	gem.test_files    = gem.files.grep(%r{^(spec|test)/|\.rb\.(ut|ts)\.rb$})

	#
	# Default runtime dependencies.
	# Optional development and runtime dependencies are grouped in Gemfile.
	#

	# Need 3+ for ActiveSupport::Concern
	gem.add_runtime_dependency 'activesupport', '>= 3.0.0'
	# Needed for some admin modules (scrutinizer_add_user.rb)
	gem.add_runtime_dependency 'json'
	# Needed by msfgui and other rpc components
	gem.add_runtime_dependency 'msgpack'
	# Needed by anemone crawler
	gem.add_runtime_dependency 'nokogiri'
	# Needed by anemone crawler
	gem.add_runtime_dependency 'robots'
end
