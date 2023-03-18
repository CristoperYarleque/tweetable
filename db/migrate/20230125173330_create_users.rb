class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :username
      t.string :name
      t.integer :role, default: 0
      t.string :token

      t.timestamps
    end
    add_index :users, :username, unique: true
    add_index :users, :token, unique: true
  end
end
