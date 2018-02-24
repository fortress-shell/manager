class CreateBuilds < ActiveRecord::Migration[5.1]
  def change
    create_table :builds do |t|
      t.integer :status

      t.timestamps
    end
  end
end
