require 'spec_helper'

# This won't show coverage for metasploit-framework.gemspec because the
# gemspec is loaded by `Bundler::GemHelper.install_tasks` in `Rakefile` before
# simplecov can be loaded.

name = 'metasploit-framework'
specification_basename = "#{name}.gemspec"

describe specification_basename do
	let(:specification_path) do
		Metasploit::Framework.root.join(specification_basename)
	end

	subject(:specification) do
		Bundler.load_gemspec(specification_path)
	end

	context '#authors' do
		subject(:authors) do
			specification.authors
		end

		it { should_not be_empty }

    it 'should match Metasploit::Framework::Specification.sorted_author_names' do
	    authors.should == Metasploit::Framework::Specification.sorted_author_names
    end
	end

	context '#description' do
		it 'should not contain TODO' do
			specification.description.should_not match(/TODO/i)
		end
	end

	context '#email' do
		subject(:email) do
			specification.email
		end

		it { should_not be_empty }

		it 'should have same number of entries as #authors' do
			email.length.should == specification.authors.length
		end

		it 'should match Metasploit::Framework::Specification.author_emails_sorted_by_author_name' do
			email.should == Metasploit::Framework::Specification.author_emails_sorted_by_author_name
		end
	end

	context '#executables' do
		subject(:executables) do
			specification.executables
		end

		it { should include('msfcli') }
		it { should include('msfconsole') }

		it 'should be a subset of #files basenames' do
			file_basename_set = Set.new

			specification.files.each do |path|
				basename = File.basename(path)
				file_basename_set.add basename
			end

			executable_set = Set.new(executables)

			executable_set.should be_subset(file_basename_set)
		end
	end

	context '#files' do
		subject(:files) do
			specification.files
		end

		it { should_not be_empty }
	end

	context '#homepage' do
		subject(:homepage) do
			specification.homepage
		end

		it { should == 'http://www.metasploit.com' }
	end

	context '#name' do
		subject(:name) do
			specification.name
		end

		it { should == name }

		it "should use '-' in name to signify it's a main entry point is a submodule" do
			name.should include('-')
		end
	end

	context '#require_paths' do
		subject(:require_paths) do
			specification.require_paths
		end

		it { should include('lib') }
	end

	context '#summary' do
		subject(:summary) do
			specification.summary
		end

		it 'should not contain TODO' do
			summary.should_not match(/TODO/i)
		end

		it 'should be shorter than description' do
			summary.length.should < specification.description.length
		end
	end

	context '#test_files' do
		let(:test_file_set) do
			Set.new(test_files)
		end

		subject(:test_files) do
			specification.test_files
		end

		it 'should include all files under spec directory in #files' do
			spec_directory_set = Set.new

			specification.files.each do |path|
				if path.starts_with? 'spec'
					spec_directory_set.add path
				end
			end

			spec_directory_set.should be_subset(test_file_set)
		end

		it 'should include all files under test directory in #files' do
			test_directory_set = Set.new

			specification.files.each do |path|
				if path.starts_with? 'test'
					test_directory_set.add path
				end
			end

		  test_directory_set.should be_subset(test_file_set)
		end

		context 'Rex::Test' do
			it 'should include all test suite files' do
				test_suite_set = Set.new

				specification.files.each do |path|
					if path.ends_with? '.rb.ts.rb'
						test_suite_set.add path
					end
				end

				test_suite_set.should be_subset(test_file_set)
			end

			it 'should include all unit test files' do
				unit_test_set = Set.new

				specification.files.each do |path|
					if path.ends_with? '.rb.ut.rb'
						unit_test_set.add path
					end
				end

				unit_test_set.should be_subset(test_file_set)
			end
		end
	end

	context '#version' do
		subject(:version) do
			specification.version
		end

		it 'should match Metasploit::Framework::Version::FULL' do
			version.to_s.should == Metasploit::Framework::Version::FULL
		end
	end
end
