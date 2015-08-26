require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
	
	describe 'get_title' do
		it 'gives DAT605 if no title is given' do
			expect(helper.get_title).to eq("DAT605")
		end
		it 'gives "Title - DAT605" if a title is given' do
			helper.provide(:title, "Test")
			expect(helper.get_title).to eq("Test - DAT605")
		end
	end

end
