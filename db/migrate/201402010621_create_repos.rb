class CreateRepos < ActiveRecord::Migration
  def change
    create_table :repos do |t|
      t.string :owner
      t.string :name
      t.string :url
      t.string :homepage
      t.string :language
      t.text :description
    end
  end
end
