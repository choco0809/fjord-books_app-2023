class MentioningMentionedReport < ApplicationRecord
  belongs_to :mentioning_reports, class_name: 'Report'
  belongs_to :mentioned_reports, class_name: 'Report'
end
