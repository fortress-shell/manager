class CreateTables < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :access_token
      t.integer :github_user_id
      t.integer :plan, default: 1

      t.timestamps
    end

    create_table :projects do |t|
      t.belongs_to :user, index: true
      t.string :webhook_secret
      t.jsonb :repository
      t.text :private_key
      t.bigint :repository_id
      t.string :repository_owner
      t.string :repository_name
      t.jsonb :deploy_key
      t.jsonb :webhook

      t.timestamps
    end

    create_table :builds do |t|
      t.string :status
      t.jsonb :payload
      t.string :dispatched_job_id
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
