# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RubyLLM::Chat do
  include_context 'with configured RubyLLM'

  describe 'custom options' do
    CHAT_MODELS.each do |model_info|
      model = model_info[:model]
      provider = model_info[:provider]

      next unless %i[gemini openai anthropic].include?(provider)

      max_tokens_key = case provider
                       when :openai
                         :max_completion_tokens
                       when :gemini
                         :max_output_tokens
                       else
                         :max_tokens
                       end

      it "#{provider}/#{model} can take a custom option" do
        chat = RubyLLM.chat(model: model, provider: provider)
        chat.with_options(max_tokens_key => 1)

        response = chat.ask("I'm sending you some custom options")
        expect(response.output_tokens).to eq(1)
      end

      model = model_info[:model]
      provider = model_info[:provider]

      next unless %i[gemini openai anthropic].include?(provider)

      it "#{provider}/#{model} raises an error when passed an invalid option" do
        chat = RubyLLM.chat(model: model, provider: provider)
        chat.with_options(foo: 'bar')

        expect { chat.ask("I'm sending you some custom options") }.to raise_error(RubyLLM::BadRequestError)
      end
    end
  end
end
