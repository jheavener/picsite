class CreateUserSessions < ActiveRecord::Migration
  def change
    create_table :user_sessions do |t|
      t.references :user, null: false
      t.string :status, null: false, default: :active, limit: 10
      t.string :ip_addr
      t.string :user_agent
      t.datetime :last_activity_at
      
      t.timestamps
    end
    add_index :user_sessions, [:user_id, :status, :last_activity_at], order: { last_activity_at: :desc }
  end
end
