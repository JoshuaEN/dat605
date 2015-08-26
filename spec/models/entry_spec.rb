require 'rails_helper'

RSpec.describe Entry, type: :model do
	describe 'validation' do

		it 'detects YouTube urls' do
			urls = %w(http://www.youtube.com/watch?v=iwGFalTRHDA http://www.youtube.com/watch?v=iwGFalTRHDA&feature=related http://youtu.be/iwGFalTRHDA http://youtu.be/n17B_uFF4cA http://www.youtube.com/watch?v=t-ZRX8984sc http://youtu.be/t-ZRX8984sc)

		end

		it 'detects Vimeo urls' do
			urls = %w(https://vimeo.com/11111111 https://vimeo.com/channels/abc/11111111 https://vimeo.com/groups/abc/videos/11111111)


		end

	end
end
