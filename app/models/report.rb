# frozen_string_literal: true

class Report < ApplicationRecord
  REPORT_LINK = %r{http://localhost:3000/reports/([1-9]\d*)}

  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  has_many :mentioning,
           class_name: 'MentioningMentionedReport',
           foreign_key: 'mentioning_report_id',
           inverse_of: :mentioning_report,
           dependent: :destroy

  has_many :mentioning_reports, through: :mentioning, source: :mentioned_report

  has_many :mentioned,
           class_name: 'MentioningMentionedReport',
           foreign_key: 'mentioned_report_id',
           inverse_of: :mentioned_report,
           dependent: :destroy

  has_many :mentioned_reports, through: :mentioned, source: :mentioning_report

  validates :title, presence: true
  validates :content, presence: true

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  def save_mentioning_reports
    content.scan(REPORT_LINK).uniq.each do |report_id|
      report = Report.find(report_id)
      mentioning_reports << report
    end
  end

  def update_mentioning_reports
    mentioning.each(&:destroy)
    save_mentioning_reports
  end
end
