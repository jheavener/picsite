class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username, null: false, limit: 30
      t.string :status, null: false, limit: 10, default: :active
      t.string :display_name, null: false, limit: 30
      t.string :email, limit: 100
      t.string :password_digest, null: false
      t.string :forgot_password_token, limit: 60
      t.datetime :forgot_password_at

      t.timestamps
    end
    add_index :users, :username, unique: true
    add_index :users, :forgot_password_token, unique: true
  end
end
