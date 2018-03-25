class User < ApplicationRecord
  has_many :projects, dependent: :destroy
  has_many :builds, through: :projects
end
