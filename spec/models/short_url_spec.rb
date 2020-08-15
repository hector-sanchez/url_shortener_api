require 'rails_helper'

RSpec.describe ShortUrl, type: :model do
  let(:short_url) { build(:short_url) }

  describe "Fields" do
    subject { short_url }

    it { should respond_to(:original_url) }
    it { should respond_to(:slug) }
    it { should respond_to(:expire_at) }
  end

  describe "validation" do
    subject(:model) { create(:short_url) }

    it { is_expected.to validate_presence_of :original_url }
    it { is_expected.to validate_presence_of :slug }

    describe "#slug" do
      context "when the slug is taken" do
        let(:other_short_url) { build(:short_url, slug: model.slug) }

        it "is not valid" do
          expect(other_short_url).not_to be_valid
        end
      end
    end
  end

  describe "scopes" do
    describe ".active" do
      before do
        create(:short_url, :expired)
        @active_short_urls = create_list(:short_url, 2)
      end

      subject(:short_url) { ShortUrl.active }

      it { is_expected.to match_array(@active_short_urls) }
    end
  end

  describe "#shortened_url" do
    subject { short_url.shortened_url }

    it { is_expected.to eq("http://www.goldbelly.com/#{short_url.slug}") }
  end

  describe "#expired?" do
    before do
      short_url.expire_at = 1.day.ago
    end

    it "is expired" do
      expect(short_url.expired?).to eq true
    end
  end

  describe "#expired!" do
    before { short_url.expire! }

    it "is expired" do
      expect(short_url.reload.expired?).to eq true
    end
  end
end
