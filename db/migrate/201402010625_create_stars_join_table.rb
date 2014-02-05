class CreateStarsJoinTable < ActiveRecord::Migration
  def change
    create_join_table :users, :repos, table_name: :stars do |t|
      t.index [:user_id, :repo_id], unique: true
    end
  end
end
