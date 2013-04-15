module Metasploit
	module Framework
		# @note At the date of this comment (2012-04-12), metasploit-framework
		#   does not strictly follow {http://semver.org/ Semantic Versioning}: it
		#   does increment {MAJOR} for incompatible changes; {MINOR} is only
		#   incremented when a new version of Pro is release; and {PATCH} is stuck
		#   at 0.
		module Version
			MAJOR = 4
			MINOR = 7
			PATCH = 0

			FULL = "#{MAJOR}.#{MINOR}.#{PATCH}"
		end
	end
end