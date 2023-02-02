class AddIndexToMentioningMentionedReports < ActiveRecord::Migration[7.0]
  def change
    add_index :mentioning_mentioned_reports,
              [:mentioning_report_id, :mentioned_report_id],
              unique: true,
              name: 'index_mentioning_mentioned_reports'
  end
end
