class AddUsedPtsAndLevelToTokens < ActiveRecord::Migration
  def change
    add_column :access_tokens, :used_points, :integer
    add_column :access_tokens, :bucket_level, :integer
  end
end