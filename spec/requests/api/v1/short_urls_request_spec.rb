require 'rails_helper'

RSpec.describe "Api::V1::ShortUrls", type: :request do
  before do
    @short_url = create(:short_url)
  end

  describe "GET /short_urls" do
    it "responds successfully" do
      get api_v1_short_urls_path, as: :json

      expect(response.content_type).to eq "application/json; charset=utf-8"
      expect(response).to have_http_status :success
    end
  end

  describe "GET /short_url/:id" do
    it "responds successfully" do
      get api_v1_short_url_path(@short_url), as: :json

      expect(response.content_type).to eq "application/json; charset=utf-8"
      expect(response).to have_http_status :success
    end
    
    it "renders short url" do
      get api_v1_short_urls_path(@short_url), as: :json

      json_response = JSON.parse(response.body)["data"][0]["attributes"]
      
      expect(json_response["slug"]).to eq @short_url.slug
      expect(json_response["original_url"]).to eq @short_url.original_url
    end
  end

  describe "POST /short_urls" do
    context "when the short url data is valid" do
      context "when the user authentication token is not in the header" do
        it "the short url is created" do
          post api_v1_short_urls_path,
                params: { 
                  short_url: { 
                    slug: FFaker::Internet.slug, 
                    original_url: FFaker::Internet.http_url, 
                    expire_at: 5.days.from_now,
                  }
                }, as: :json
          
          expect(response).to have_http_status :created
        end
      end
      
      context "when the user authentication token is in the header" do
        let(:user) { create(:user) }

        it "the short url is created" do
          post api_v1_short_urls_path,
                params: { 
                  short_url: { 
                    slug: FFaker::Internet.slug, 
                    original_url: FFaker::Internet.http_url, 
                    expire_at: 5.days.from_now,
                  }
                },
                headers: {
                  Authorization: JsonWebToken.encode(user_id: user.id)
                }, as: :json
          expect(response).to have_http_status :created

          json_response = JSON.parse(response.body)

          expect(json_response["data"]["attributes"]["user_id"]).to eq user.id
        end
      end
    end

    context "when the short url data is invalid" do
      it "the request is unprocessable" do
        post api_v1_short_urls_path,
              params: { 
                short_url: { 
                  slug: @short_url.slug, 
                  original_url: "bad_url", 
                  expire_at: 5.days.from_now,
                }
              }, as: :json
          
        expect(response).to have_http_status :unprocessable_entity

        json_response_errors = JSON.parse(response.body)["errors"]

        expect(json_response_errors["slug"]).to eq ["has already been taken"]
        expect(json_response_errors["original_url"]).to eq ["is not a valid HTTP URL"]
      end
    end
  end

  describe "DELETE /short_url/:id" do
    context "when the user authentication token is in the header" do
      before do 
        @user = create(:user)
        @other_short_url = create(:short_url, user: @user)
      end

      let(:delete_command) do 
        delete api_v1_short_url_path(@other_short_url),
                headers: { Authorization: JsonWebToken.encode(user_id: user.id) }, as: :json 
      end

      context "when the short url belongs to the authenticated user" do
        let(:user) { @user }

        it "deletes (expires) the short url" do
          delete_command

          expect(response).to have_http_status(:no_content)
          expect(@other_short_url.reload.expired?).to eq true
        end
      end

      context "when the short url does not belong to the authenticated user" do
        let(:user) { create(:user) }
        
        it "does not expire the short url" do
          delete_command

          expect(response).to have_http_status(:forbidden)
          expect(@other_short_url.reload.expired?).to eq false
        end
      end
    end
    
    context "when the user authentication token is not in the header" do
      it "the request is unauthorized" do
        delete api_v1_short_url_path(@short_url), as: :json

        expect(response).to have_http_status :forbidden
        expect(@short_url.reload.expired?).to eq false
      end
    end
  end
end