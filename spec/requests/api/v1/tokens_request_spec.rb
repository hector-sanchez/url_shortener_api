require 'rails_helper'

RSpec.describe "Api::V1::Tokens", type: :request do

  describe "GET /create" do
    before do
      @user = create(:user)
    end

    context "when the email/password combination is good" do
      it "returns the token" do
        post api_v1_tokens_path,
              params: {
                user: {
                  email: @user.email,
                  password: "G00dP@ssw0rd"
                }
              }, as: :json

        expect(response).to have_http_status(:created)

        json_response = JSON.parse(response.body)

        expect(json_response["token"]).not_to be_nil
      end
    end

    context "when the email/password combination is not good" do
      it "does not create the token" do
        post api_v1_tokens_path,
              params: {
                user: {
                  email: @user.email,
                  password: "B@dP@55w0rd"
                }
              }, as: :json

        expect(response).to have_http_status :unauthorized
      end
    end
  end

end
