class CreateAccessTokens < ActiveRecord::Migration[4.2]
  def change
    create_table :access_tokens do |t|
      t.string  :access_token
      t.string  :expires_at
      t.string  :token_type
      t.string  :refresh_token
      t.string  :app
    end
  end
end