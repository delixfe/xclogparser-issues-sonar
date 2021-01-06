# frozen_string_literal: true

RSpec.describe Converter::IssueConverter do
  context "swiftWarning" do
    notice_json = <<~'EOJASON'
      {
        "characterRangeStart" : 0,
        "startingColumnNumber" : 9,
        "endingColumnNumber" : 9,
        "characterRangeEnd" : 269,
        "detail" : "\/Users\/felix\/dev\/bit\/Papr\/Papr\/Warnings\/Enums.swift:17:9: warning: switch covers known cases, but 'DTX_DataCollectionLevel' may have additional unknown values\n        switch item {\n        ^\n\/Users\/felix\/dev\/bit\/Papr\/Papr\/Warnings\/Enums.swift:17:9: note: handle unknown values using \"@unknown default\"\n        switch item {\n        ^",
        "title" : "Switch covers known cases, but 'DTX_DataCollectionLevel' may have additional unknown values",
        "endingLineNumber" : 17,
        "type" : "swiftWarning",
        "documentURL" : "file:\/\/\/Users\/felix\/dev\/bit\/Papr\/Papr\/Warnings\/Enums.swift",
        "startingLineNumber" : 17,
        "severity" : 1
      }
    EOJASON

    before :all do
      notice = JSON.parse(notice_json)
      issue_converter = Converter::IssueConverter.new
      @actual = issue_converter.convert_issues([notice])[0]
    end

    it "engineId is swiftCompiler" do
      expect(@actual[:engineId]).to eq("swiftCompiler")
    end
    it "severity is CRITICAL" do
      expect(@actual[:severity]).to eq("CRITICAL")
    end
    it "type is BUG" do
      expect(@actual[:type]).to eq("BUG")
    end
    it "effortMinutes is 30" do
      expect(@actual[:effortMinutes]).to eq(30)
    end
    it "message" do
      expect(@actual[:primaryLocation][:message]).to \
        eq("Switch covers known cases, but 'DTX_DataCollectionLevel' may have additional unknown values")
    end
    it "filePath" do
      expect(@actual[:primaryLocation][:filePath]).to \
        eq("file:///Users/felix/dev/bit/Papr/Papr/Warnings/Enums.swift")
    end
    it "startLine" do
      expect(@actual[:primaryLocation][:textRange][:startLine]).to eq(17)
    end
    it "endLine" do
      expect(@actual[:primaryLocation][:textRange][:endLine]).to eq(17)
    end
    it "startColumn" do
      expect(@actual[:primaryLocation][:textRange][:startColumn]).to eq(9)
    end
    it "endColumn" do
      expect(@actual[:primaryLocation][:textRange][:endColumn]).to eq(9)
    end
    it :expect_valid_issue do
      expect_valid_issue(@actual)
    end
    it "can serialize to JSON" do
      actual_json = JSON.pretty_generate(@actual)
      JSON.parse(actual_json)
    end
  end

  context "projectWarning" do
    notice_json = <<~'EOJASON'
      {
        "characterRangeStart" : 0,
        "startingColumnNumber" : 0,
        "endingColumnNumber" : 0,
        "characterRangeEnd" : 0,
        "detail" : "warning: The iOS Simulator deployment target 'IPHONEOS_DEPLOYMENT_TARGET' is set to 8.0, but the range of supported deployment target versions is 9.0 to 14.2.99. (in target 'Hero' from project 'Pods')\r",
        "title" : "The iOS Simulator deployment target 'IPHONEOS_DEPLOYMENT_TARGET' is set to 8.0, but the range of supported deployment target versions is 9.0 to 14.2.99.",
        "endingLineNumber" : 0,
        "type" : "projectWarning",
        "documentURL" : "",
        "startingLineNumber" : 0,
        "severity" : 1
      }
    EOJASON

    before :all do
      notice = JSON.parse(notice_json)
      issue_converter = Converter::IssueConverter.new
      @actual = issue_converter.convert_issues([notice])
    end

    it "is not converted as we have no file for SonarQuebe" do
      expect(@actual).to be_empty
    end
  end
end
