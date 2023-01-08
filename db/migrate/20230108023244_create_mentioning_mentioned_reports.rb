class CreateMentioningMentionedReports < ActiveRecord::Migration[7.0]
  def change
    create_table :mentioning_mentioned_reports do |t|
      t.references :mentioning_report, foreign_keys: {to_table: :reports}
      t.references :mentioned_report, foreign_keys: {to_table: :reports}
      t.timestamps
    end
  end
end
