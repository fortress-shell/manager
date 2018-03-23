class User < ApplicationRecord
  has_many :sessions

  # def self.from_github_code(github_params)
  #   hash_with_token = Octokit.exchange_code_for_token \
  #     github_params[:code],
  #     Rails.application.secrets.github_app_id,
  #     Rails.application.secrets.github_app_secret,
  #     {:accept => 'application/json'}
  #   userInfo = Octokit.getUserInfo(token)
  #   create! userInfo
  # end
end
