require 'spec_helper'

RSpec.describe RubyGpt::Client do
  before do
    RubyGpt.configure do |config|
      config.access_token = "test-api-token"
    end

    @client = RubyGpt::Client.new
    @model = "gpt-3.5-turbo"
    @prompt = "Translate 'Hello, world!' to French."
  end

  describe '#query' do
    context 'when the query is successful' do
      before do
        stub_request(:post, "https://api.openai.com/v1/engines/#{@model}/completions")
          .to_return(status: 200, body: { choices: [{ text: "Bonjour, le monde!" }] }.to_json)
      end

      it 'returns a successful response' do
        response = @client.query(@model, @prompt)
        expect(response["choices"].first["text"]).to eq("Bonjour, le monde!")
      end
    end

    # context 'when the API key is invalid' do
    #   before do
    #     stub_request(:post, "https://api.openai.com/v1/engines/#{@model}/completions")
    #       .to_return(status: 401, body: { error: { message: "Invalid API key" } }.to_json)
    #   end

    #   it 'returns an error response' do
    #     response = @client.query(@model, @prompt)
    #     expect(response["error"]["message"]).to eq("Invalid API key")
    #     expect(response["code"]).to eq(401)
    #   end
    # end

    # context 'when there is an unexpected response' do
    #   before do
    #     stub_request(:post, "https://api.openai.com/v1/engines/#{@model}/completions")
    #       .to_return(status: 500, body: { error: { message: "Internal Server Error" } }.to_json)
    #   end

    #   it 'handles the error gracefully' do
    #     response = @client.query(@model, @prompt)
    #     expect(response["error"]["message"]).to eq("Internal Server Error")
    #     expect(response["code"]).to eq(500)
    #   end
    # end
  end
end
