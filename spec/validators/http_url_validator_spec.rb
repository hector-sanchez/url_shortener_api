describe HttpUrlValidator do
  let(:validatable) do
    Class.new do
      include ActiveModel::Validations

      attr_accessor :url

      def initialize(url:)
        @url = url
      end

      def self.model_name
        ActiveModel::Name.new(self, nil, "temp")
      end

      validates :url, http_url: true
    end
  end

  context "when the url is valid" do
    subject(:model) { validatable.new(url: "http://goldbelly.com") }

    it { is_expected.to be_valid }
  end

  context "when the url is not valid" do
    subject(:model) { validatable.new(url: "goldbelly") }

    it { is_expected.not_to be_valid }
  end
end