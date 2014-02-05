class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :login
      t.string :name

      t.index :login, unique: true
    end
  end
end
