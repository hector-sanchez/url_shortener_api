require "rails_helper"

class MockController
  include Authenticatable

  attr_accessor :request

  def initialize
    mock_request = Struct.new(:headers)
    self.request = mock_request.new({})
  end
end

RSpec.describe "Authenticatable" do
  before do
    @user = create(:user)
    @authentication = MockController.new
    @authentication.request.headers["Authorization"] = encoded_token
  end

  context "when the user is authenticated" do
    let(:encoded_token) { JsonWebToken.encode(user_id: @user.id) }

    it "should get the user from the authentication token" do
      expect(@user.id).to eq @authentication.current_user.id
    end
  end

  context "when the user is not authenticated" do
    let(:encoded_token) { nil }

    it "should not get user from the empty Authorization token" do
      expect(@authentication.current_user).to be_nil
    end
  end
end