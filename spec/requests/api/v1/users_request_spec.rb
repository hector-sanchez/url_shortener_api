require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  describe "POST /users" do
    context "when the user data is valid" do
      let(:post_command) do
        post api_v1_users_path, 
              params: {
                user: {
                  email: FFaker::Internet.email,
                  password: FFaker::Internet.password
                }
              }, as: :json
      end
      
      it "creates the user" do
        expect { post_command }.to change(User, :count).by(1)
        expect(response).to have_http_status :created
      end
    end

    context "when the user data is invalid" do
      before do
        @user = create(:user)
      end

      it "fails to create the user" do
        post api_v1_users_path, 
              params: {
                user: {
                  email: @user.email,
                  password: FFaker::Internet.password
                }
              }, as: :json
        
        expect(response).to have_http_status :unprocessable_entity

        json_response_error = JSON.parse(response.body)["errors"]

        expect(json_response_error["email"]).to eq ["has already been taken"]
      end
    end
  end
end
