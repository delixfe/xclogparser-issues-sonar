# frozen_string_literal: true

require_relative "converter/version"

module Converter
  class Error < StandardError; end

  class IssueConverter
    def initialize
      @prototype = {
        engineId: "swiftCompiler",
        ruleId: "rule1",
        severity: "CRITICAL",
        type: "BUG",
        effortMinutes: 30
      }
    end

    def convert_issues(notices)
      issues = []
      notices.each do |notice|
        issue = convert_issue(notice)
        issues << issue unless issue.nil?
      end
      issues
    end

    private

    def convert_issue(notice)
      document_url = notice["documentURL"]

      return nil if document_url.nil? || document_url.to_s.strip.empty?

      issue = @prototype.dup

      issue[:primaryLocation] = {
        message: notice["title"],
        filePath: document_url,
        textRange: convert_text_range(notice)
      }

      issue
    end

    # TODO: adapt to XCLogAnalyzer index handling
    # /// Xcode reports the line and column number based on a zero-index location
    #     /// This adds a 1 to report the real location
    #     /// If there is no location, Xcode reports UIInt64.max. In that case this function
    #     /// doesn't do anything and returns the same number
    #     private static func realLocationNumber(_ number: UInt64) -> UInt64 {
    #         if number != UInt64.max {
    #             return number + 1
    #         }
    #         return number
    #     }
    # TODO: adapt to SonarQube index handling
    # TextRange fields:
    # startLine - integer. 1-indexed
    # endLine - integer, optional. 1-indexed
    # startColumn - integer, optional. 0-indexed
    # endColumn - integer, optional. 0-indexed
    def convert_text_range(notice)
      {
        startLine: notice["startingLineNumber"],
        endLine: notice["endingLineNumber"],
        startColumn: notice["startingColumnNumber"],
        endColumn: notice["endingColumnNumber"]
      }
    end
  end
end
