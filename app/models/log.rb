class Log < ApplicationRecord
  belongs_to :build
  scope :ordered_by_position, -> { order(position: :asc) }
end
