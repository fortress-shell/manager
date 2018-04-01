class Log < ApplicationRecord
  belongs_to :build
  scope :ordered_by_position, -> { order(position: :asc) }

  def readonly?
    true
  end
end
