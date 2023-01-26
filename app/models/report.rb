# frozen_string_literal: true

class Report < ApplicationRecord
  REPORT_LINK = %r{http://localhost:3000/reports/([1-9]\d*)}

  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  has_many :active_mention,
           class_name: 'MentioningMentionedReport',
           foreign_key: 'mentioning_report_id',
           inverse_of: :mentioning_report,
           dependent: :destroy

  has_many :mentioning_reports, through: :active_mention, source: :mentioned_report

  has_many :passive_mention,
           class_name: 'MentioningMentionedReport',
           foreign_key: 'mentioned_report_id',
           inverse_of: :mentioned_report,
           dependent: :destroy

  has_many :mentioned_reports, through: :passive_mention, source: :mentioning_report

  validates :title, presence: true
  validates :content, presence: true

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  def save_report_and_mentioning_reports
    success = true
    transaction do
      success = save
      raise ActiveRecord::Rollback unless success

      active_mention.each(&:destroy)
      save_mentioning_reports
    end
    success
  end

  private

  def save_mentioning_reports
    content.scan(REPORT_LINK).uniq.each do |report_id|
      Report.where(id: report_id).find_each do |report|
        mentioning_reports << report
      end
    end
  end
end
