require 'spec_helper'

require 'metasploit/framework/specification'

describe Metasploit::Framework::Specification do
	let(:author_email_git_log_format) do
		'%ae'
	end

	let(:author_name_git_log_format) do
		'%an'
	end

	before(:each) do
		if described_class.instance_variable_defined? :@author_email_by_author_name
			described_class.send(
					:remove_instance_variable,
					:@author_email_by_author_name
			)
		end
	end

	context 'CONSTANTS' do
		it 'should define AUTHOR_EMAIL_GIT_LOG_FORMAT' do
			described_class::AUTHOR_EMAIL_GIT_LOG_FORMAT.should == author_email_git_log_format
		end

		it 'should define AUTHOR_NAME_GIT_LOG_FORMAT' do
			described_class::AUTHOR_NAME_GIT_LOG_FORMAT.should == author_name_git_log_format
		end

		context 'GIT_LOG_FORMAT' do
			subject(:git_log_format) do
				described_class::GIT_LOG_FORMAT
			end

			it 'should include AUTHOR_NAME_GIT_LOG_FORMAT' do
				git_log_format.should include(author_name_git_log_format)
			end

			it 'shound include AUTHOR_EMAIL_GIT_LOG_FORMAT' do
				git_log_format.should include(author_email_git_log_format)
			end
		end

		context 'GIT_LOG_FORMAT_REGEXP' do
			subject(:git_log_format_regexp) do
				described_class::GIT_LOG_FORMAT_REGEXP
			end

			context 'names' do
				subject(:names) do
					git_log_format_regexp.names
				end

				it { should include('author_email') }
				it { should include('author_name') }
			end
		end

		context 'REJECTED_AUTHOR_NAMES' do
			subject(:rejected_author_names) do
				described_class::REJECTED_AUTHOR_NAMES
			end

			it { should include('') }
			it { should include('root') }
		end
	end

	context 'author_email_by_author_name' do
		subject(:author_email_by_author_name) do
			described_class.author_email_by_author_name
		end

		it { should_not be_empty }

		it { should_not have_key('') }

		it { should_not have_key('root') }
	end

	context 'sorted_author_names_and_emails' do
		subject(:sorted_author_names_and_emails) do
			described_class.sorted_author_names_and_emails
		end

		it 'should sort author_email_by_author_name' do
			described_class.author_email_by_author_name.should_receive(:sort)

			sorted_author_names_and_emails
		end
	end

	context 'sorted_author_names' do
		subject(:sorted_author_names) do
			described_class.sorted_author_names
		end

		it 'should be an Array of Strings to match format of Gem::Specification#authors' do
			sorted_author_names.should be_a Array

			sorted_author_names.each do |author_name|
				author_name.should be_a String
			end
		end
	end

	context 'author_emails_sorted_by_author_name' do
		subject(:author_emails_sorted_by_author_name) do
			described_class.author_emails_sorted_by_author_name
		end

		it 'should be an Array of Strings to match format of Gem::Specification#email' do
			author_emails_sorted_by_author_name.should be_a Array

			author_emails_sorted_by_author_name.each do |author_email|
				author_email.should be_a String
			end
		end

		it 'should correlate with order of sorted_author_names' do
			described_class.author_email_by_author_name.each do |author_name, author_email|
				name_index = described_class.sorted_author_names.index(author_name)
				email_indices = []

				# an email may be used for multiple Author Names, so check if any of the
				# indices match the name index.
				author_emails_sorted_by_author_name.each_with_index do |sorted_author_email, index|
					if sorted_author_email == author_email
						email_indices << index
					end
				end

				email_indices.should include(name_index)
			end
		end
	end
end