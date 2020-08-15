require 'rails_helper'

RSpec.describe "Short URL", type: :request do
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

      json_response = JSON.parse(response.body).first

      expect(json_response["slug"]).to eq @short_url.slug
      expect(json_response["original_url"]).to eq @short_url.original_url
    end
  end

  describe "POST /short_urls" do
    context "when the short url data is valid" do
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
    it "expires the short url" do
      delete api_v1_short_url_path(@short_url), as: :json

      expect(response).to have_http_status :no_content
      expect(@short_url.reload.expired?).to eq true
    end
  end
end