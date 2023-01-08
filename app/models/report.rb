# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  has_many :mentioning,
           class_name: 'MentioningMentionedReport',
           foreign_key: 'mentioned_report_id',
           inverse_of: :mentioned_reports,
           dependent: :destroy
  # 引用先の日報を求める場合
  has_many :mentioning_reports, through: :mentioning, source: :mentioning_reports

  has_many :mentioned,
           class_name: 'MentioningMentionedReport',
           foreign_key: 'mentioning_report_id',
           inverse_of: :mentioning_reports,
           dependent: :destroy

  has_many :mentioned_reports, through: :mentioned, source: :mentioned_reports


  validates :title, presence: true
  validates :content, presence: true

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end
end
