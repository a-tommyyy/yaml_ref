RSpec.describe YamlRef do
  it "has a version number" do
    expect(YamlRef::VERSION).not_to be nil
  end

  describe ".load_file" do
    subject { described_class.load_file(path) }

    context "Valid file" do
      let(:path) do
        File.join(File.expand_path(__dir__), "fixtures", "test_success.yml")
      end
      let(:expect_hash) do
        YAML.load_file(File.join(File.expand_path(__dir__), "fixtures", "expect.yml"))
      end

      it "parse correctly" do
        is_expected.to eq(expect_hash)
      end
    end

    context "Invalid file" do
      let(:path) do
        File.join(File.expand_path(__dir__), "fixtures", "test_fail.yml")
      end

      it "should raise errorr" do
        expect { subject }.to raise_error(YamlRef::Error)
      end
    end
  end
end
