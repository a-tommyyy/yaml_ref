RSpec.describe YamlRef do
  it "has a version number" do
    expect(YamlRef::VERSION).not_to be nil
  end

  describe ".load_file" do
    subject { described_class.load_file(path) }

    let(:path) do
      File.join(File.expand_path(__dir__), "fixtures", "test.yml")
    end
    let(:expect_hash) do
      YAML.load_file(File.join(File.expand_path(__dir__), "fixtures", "expect.yml"))
    end

    it "parse correctly" do
      is_expected.to eq(expect_hash)
    end
  end
end
