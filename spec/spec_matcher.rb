# frozen_string_literal: true

require "rspec/matchers"

module IssueMatcher
  extend RSpec::Matchers::DSL

  # https://github.com/SonarSource/sonarqube/blob/9c4f81390e6739fa09f596d359d66c181db9ad1c/sonar-scanner-engine/src/main/java/org/sonar/scanner/externalissue/ReportParser.java
  #  private Report validate(Report report) {
  #     for (Issue issue : report.issues) {
  #       mandatoryField(issue.primaryLocation, "primaryLocation");
  #       mandatoryField(issue.engineId, "engineId");
  #       mandatoryField(issue.ruleId, "ruleId");
  #       mandatoryField(issue.severity, "severity");
  #       mandatoryField(issue.type, "type");
  #       mandatoryField(issue.primaryLocation, "primaryLocation");
  #       mandatoryFieldPrimaryLocation(issue.primaryLocation.filePath, "filePath");
  #       mandatoryFieldPrimaryLocation(issue.primaryLocation.message, "message");
  #
  #       if (issue.primaryLocation.textRange != null) {
  #         mandatoryFieldPrimaryLocation(issue.primaryLocation.textRange.startLine, "startLine of the text range");
  #       }
  #
  #       if (issue.secondaryLocations != null) {
  #         for (Location l : issue.secondaryLocations) {
  #           mandatoryFieldSecondaryLocation(l.filePath, "filePath");
  #           mandatoryFieldSecondaryLocation(l.textRange, "textRange");
  #           mandatoryFieldSecondaryLocation(l.textRange.startLine, "startLine of the text range");
  #         }
  #       }
  #     }
  #
  #     return report;
  #   }

  matcher :be_one_of do |expected|
    match { |actual| expected.any?(actual) }
  end

  matcher :be_a_string_and_not_blank do
    match { |actual| !actual.nil? && actual.instance_of?(String) && !actual.strip.empty? }
  end

  def expect_valid_issue(issue)
    aggregate_failures "validate issue" do
      expect(issue[:engineId]).to be_a_string_and_not_blank
      expect(issue[:ruleId]).to be_a_string_and_not_blank
      # BLOCKER, CRITICAL, MAJOR, MINOR, INFO
      expect(issue[:severity]).to be_one_of(%w[BLOCKER CRITICAL MAJOR MINOR INFO])
      # BUG, VULNERABILITY, CODE_SMELL
      expect(issue[:type]).to be_one_of(%w[BUG VULNERABILITY CODE_SMELL])
      expect(issue[:primaryLocation]).to be_a(Hash)
      unless issue[:primaryLocation].nil?
        expect(issue[:primaryLocation][:filePath]).to be_a_string_and_not_blank
        expect(issue[:primaryLocation][:message]).to be_a_string_and_not_blank
        unless issue[:primaryLocation][:textRange].nil?
          expect(issue[:primaryLocation][:textRange][:startLine]).to be_a(Numeric)
        end
      end
    end
  end
end
