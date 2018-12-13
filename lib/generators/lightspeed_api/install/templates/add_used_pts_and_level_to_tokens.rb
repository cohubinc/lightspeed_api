class AddUsedPtsAndLevelToTokens < ActiveRecord::Migration[4.2]
  def change
    add_column :access_tokens, :used_points, :integer
    add_column :access_tokens, :bucket_level, :integer
  end
end