class Log < ApplicationRecord
  belongs_to :build
  default_scope { order(position: :asc) }
end
