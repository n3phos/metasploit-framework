require 'spec_helper'

describe Metasploit::Framework::Version do
	context 'CONSTANTS' do
		it 'should define FULL as MAJOR.MINOR.PATCH' do
			described_class::FULL.should == "#{described_class::MAJOR}.#{described_class::MINOR}.#{described_class::PATCH}"
		end

		it 'should define MAJOR' do
			described_class::MAJOR.should be_a Integer
		end

		it 'should define MINOR' do
			described_class::MINOR.should be_a Integer
		end

		it 'should define PATCH' do
			described_class::PATCH.should be_a Integer
		end
	end
end