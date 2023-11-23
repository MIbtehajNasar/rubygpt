
module RubyGpt
  class Client
    include HTTParty
    base_uri 'https://api.openai.com'

    def initialize
      @headers = {
        "Authorization" => "Bearer #{RubyGpt.configuration.access_token}",
        "Content-Type" => "application/json"
      }
    end

    def query(model, prompt)
      response = self.class.post("/v1/engines/#{model}/completions", 
        body: body(model, prompt).to_json, 
        headers: @headers
      )

      handle_response(response)
    end

    private

    def body(model, prompt)
      {
        'model': model,
        'messages': [{"role": "user", "content": prompt}],
        'temperature': 0.7
      }
    end

    def handle_response(response)
      case response.code
      when 200
        JSON.parse(response)
      else
        { error: response["error"], code: response.code }
      end
    end
  end
end