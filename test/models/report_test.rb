# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  setup do
    @report1 = reports(:one)
    @report2 = reports(:two)
    @report3 = reports(:three)
  end

  test 'MentioningMentionedReport should be count up when mentioning' do
    @report1.content = "http://localhost:3000/reports/#{@report2.id}"
    @report1.save_mentioning_reports
    assert_difference 'MentioningMentionedReport.count', 1 do
      @report1.save_mentioning_reports
    end
  end

  test 'MentioningMentionedReport should be count dont matter when dont mentioning' do
    assert_no_difference 'MentioningMentionedReport.count' do
      @report1.save_mentioning_reports
    end
    assert_empty @report1.mentioning_reports
  end

  test 'MentioningMentionedReport should be count dont matter when another mentioning' do
    @report3.content = "http://localhost:3000/reports/#{@report1.id}"
    assert_no_difference 'MentioningMentionedReport.count' do
      @report3.update_mentioning_reports
    end
    assert_equal @report3, @report1.mentioned_reports[0]
  end

  test 'MentioningMentionedReport should be count down when dont mentioning' do
    @report3.content = '日報へのリンクなし'
    assert_difference 'MentioningMentionedReport.count', -1 do
      @report3.update_mentioning_reports
    end
  end
end
