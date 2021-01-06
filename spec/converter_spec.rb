# frozen_string_literal: true

RSpec.describe Converter do
  it "has a version number" do
    expect(Converter::VERSION).not_to be nil
  end

  it "can convert papr-issues.json" do
    json = json_fixture("papr-issues")

    expect(json["errors"]).to_not be_nil
    expect(json["warnings"]).to_not be_nil

    converter = Converter::IssueConverter.new
    issues = converter.convert_issues(json["warnings"])
    issues.each do |issue|
      expect_valid_issue(issue)
      rescue RSpec::Expectations::ExpectationNotMetError
        puts issue
        raise
    end
  end
end
