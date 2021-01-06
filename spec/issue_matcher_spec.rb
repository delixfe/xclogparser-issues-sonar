# frozen_string_literal: true
require 'rspec/matchers/fail_matchers'

RSpec.describe IssueMatcher do
  include RSpec::Matchers::FailMatchers

  it "nil engineId is not valid" do
    # expect_valid_issue({})

    #noinspection RubyDeadCode
    expect do
      expect_valid_issue({})
    end.to fail

  end

  it "valid issue is valid" do
    issue_json = <<~EOJASON
      {
            "engineId": "test",
            "ruleId": "rule1",
            "severity":"BLOCKER",
            "type":"CODE_SMELL",
            "primaryLocation": {
              "message": "fully-fleshed issue",
              "filePath": "sources/A.java",
              "textRange": {
                "startLine": 30,
                "endLine": 30,
                "startColumn": 9,
                "endColumn": 14
              }
            },
            "effortMinutes": 90
          }
    EOJASON

    issue = JSON.parse(issue_json, {symbolize_names: true})

    expect_valid_issue(issue)
    # expect(issue).to be_a_valid_issue
  end

  describe :be_one_of do
    it "is one of" do
      expect(1).to be_one_of([1, 2, 3])
    end
    it "is not one of" do
      #noinspection RubyDeadCode
      expect do
        expect(1).to be_one_of([2])
      end.to fail

    end
  end

  describe :be_not_black do
    context "blank values" do
      it "" do
        #noinspection RubyDeadCode
        expect do
          expect("").to be_a_string_and_not_blank
        end.to fail
      end
      it nil do
        expect do
          expect(nil).to be_a_string_and_not_blank
        end.to fail_including("blank")
      end
      it " " do
        expect do
          expect("   \t" ).to be_a_string_and_not_blank
        end.to fail_including("blank")
      end
    end
    context "valid values" do
      it ":-)" do
        expect(":-)").to be_a_string_and_not_blank
      end
    end
  end
end