
module Metasploit
	module Framework
		# Helps with generation of the Gem::Specification for metasploit-framework
		# gem.  Helpers are needed because there are a lot of authors and its
		# difficult to keep the specification.authors and specifications.email in
		# sync.
		module Specification
			#
			# CONSTANTS
			#

			GIT_LOG_FORMAT_REGEXP = /(?<author_name>.*) <(?<author_email>.*)>/
			AUTHOR_EMAIL_GIT_LOG_FORMAT = '%ae'
			AUTHOR_NAME_GIT_LOG_FORMAT = '%an'
			GIT_LOG_FORMAT = "#{AUTHOR_NAME_GIT_LOG_FORMAT} <#{AUTHOR_EMAIL_GIT_LOG_FORMAT}>"
			# Author names that will not be allowed in {author_email_by_author_name}
			REJECTED_AUTHOR_NAMES = [
					# Don't include the empty names because its not useful on
					# rubygems.org.
					'',
					# Don't include root because its an artifact of committer not setting
					# up git config correctly.
					'root'
			]

			def self.author_email_by_author_name
				unless instance_variable_defined? :@author_email_by_author_name
					@author_email_by_author_name = {}

					formatted_author_names_and_emails = `git log --format='#{GIT_LOG_FORMAT}'`

					unless $?.success?
						raise IOError, formatted_author_names_and_emails
					end

					formatted_author_names_and_emails.each_line do |line|
						match = GIT_LOG_FORMAT_REGEXP.match(line)

						if match
							author_name = match[:author_name]

							unless REJECTED_AUTHOR_NAMES.include? author_name
								author_email = match[:author_email]

								@author_email_by_author_name[author_name] = author_email
							end
						end
					end

					formatted_author_names_and_emails
				end

				@author_email_by_author_name
			end

			def self.sorted_author_names_and_emails
				author_email_by_author_name.sort
			end

			def self.sorted_author_names
				sorted_author_names_and_emails.collect { |author_name, author_email|
					author_name
				}
			end

			def self.author_emails_sorted_by_author_name
				sorted_author_names_and_emails.collect { |author_name, author_email|
					author_email
				}
			end
		end
	end
end