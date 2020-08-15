require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    subject(:model) { build(:user, email: email) }

    it { validate_presence_of :password_digest }

    describe "#email" do
      context "when the email is valid" do
        let(:email) { "valid_emaiL_address@email.com" }

        it { is_expected.to be_valid }
      end

      context "when the email is NOT valid" do
        let(:email) { "invalid_emaiL_addressemail.com" }

        it { is_expected.not_to be_valid }
      end

      context "when the email is taken" do
        before { create(:user, email: email) }

        let(:email) { "valid_emaiL_address@email.com" }

        it { is_expected.not_to be_valid }
      end
    end
  end
end
