class Build < ApplicationRecord
  enum status: [:active, :running]
end
