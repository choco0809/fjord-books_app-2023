# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  setup do
    @new_report = Report.new(user_id: users(:alice).id,
                             title: 'railsの学習が難しい',
                             content: 'おすすめの参考サイトが知りたい')
    @another_report_url = "http://localhost:3000/reports/#{reports(:report1).id}"
  end

  test '別の日報を言及していない時、MentioningMentionedReportの数は変わらない' do
    assert_no_difference 'MentioningMentionedReport.count' do
      @new_report.save_or_update_report_and_update_mentioning_reports
    end
  end

  test '別の日報を言及した時、MentioningMentionedReportの数が増加する' do
    @new_report[:content] += @another_report_url
    assert_difference 'MentioningMentionedReport.count', 1 do
      @new_report.save_or_update_report_and_update_mentioning_reports
    end
  end

  test '別の日報を複数言及した時、MentioningMentionedReportの数が言及した分増加する' do
    @new_report[:content] += @another_report_url + "http://localhost:3000/reports/#{reports(:report2).id}"
    assert_difference 'MentioningMentionedReport.count', 2 do
      @new_report.save_or_update_report_and_update_mentioning_reports
    end
  end

  test '同じ日報を複数回言及した時、MentioningMentionedReportの数は1つだけ増加する' do
    @new_report[:content] += @another_report_url + @another_report_url
    assert_difference 'MentioningMentionedReport.count', 1 do
      @new_report.save_or_update_report_and_update_mentioning_reports
    end
  end

  test '既に日報を言及していた状態から、言及先を変更するとMentioningMentionedReportの数が減少する' do
    @new_report[:content] += @another_report_url + "http://localhost:3000/reports/#{reports(:report2).id}"
    @new_report.save_or_update_report_and_update_mentioning_reports
    assert_difference 'MentioningMentionedReport.count', -1 do
      @new_report.save_or_update_report_and_update_mentioning_reports(content: @another_report_url)
    end
  end

end
