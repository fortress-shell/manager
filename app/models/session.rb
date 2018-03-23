class Session < ApplicationRecord
  belongs_to :user
  def invalidate

  end
  def generate_token
    TokenManager.generate_token(self)
  end
end
