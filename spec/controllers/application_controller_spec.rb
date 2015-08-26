require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
	
	describe 'is_url_safe_for_redirect?' do
		before(:each) do
			controller.request.host = "localhost"
			controller.request.port = "80"

			@host = 'localhost'

			@url_tester = lambda do |urls, expectation| 
				urls.each do |url|
					expect(controller.send(:is_url_safe_for_redirect?, url)).to eq(expectation)
				end
			end
		end

		it 'should accept valid URLs' do
			valid_urls = [
				"http://#{@host}",
				"http://#{@host}/",
				"http://#{@host}/search",
				"http://#{@host}/search/"
			]

			@url_tester.call(valid_urls, true)
		end

		it 'should accept URLs with port mismatches' do
			valid_urls = [
				"https://#{@host}",
				"https://#{@host}/",
				"https://#{@host}/search",
				"https://#{@host}/search/"
			]

			@url_tester.call(valid_urls, true)
		end

		it 'should reject invalid protocols' do
			invalid_urls = [
				"javascript:alert('this is bad');",
				"//badhost.com",
				"#{@host}",
				"#{@host}/search"
			]

			@url_tester.call(invalid_urls, false)
		end

		it 'should reject invalid hosts' do
			invalid_urls = [
				"http://badhost.com",
				"https://badhost.com"
			]

			@url_tester.call(invalid_urls, false)
		end

		it 'should reject invalid URIs' do
			invalid_urls = [
				"not_a_url"
			]

			@url_tester.call(invalid_urls, false)
		end
	end
end
