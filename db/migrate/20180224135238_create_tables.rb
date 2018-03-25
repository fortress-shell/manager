class CreateTables < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :access_token
      t.integer :plan, default: 1

      t.timestamps
    end

    create_table :projects do |t|
      t.belongs_to :user, index: true
      t.bigint :repo_id
      t.string :repo_url
      t.jsonb :deploy_key
      t.jsonb :webhook

      t.timestamps
    end

    create_table :builds do |t|
      t.string :status
      t.jsonb :payload
      t.text :configuration

      t.belongs_to :project, index: true

      t.timestamps
    end

    create_table :logs do |t|
      t.integer :position
      t.text :content
      t.string :stage
      t.string :command

      t.belongs_to :build, index: true

      t.timestamps
    end
  end
end