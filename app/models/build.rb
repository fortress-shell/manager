class Build < ApplicationRecord
  include AASM

  belongs_to :project
  has_many :logs, dependent: :destroy
  has_one :user, through: :project

  scope :ordered_by_created_at, -> { order(created_at: :desc) }

  aasm column: 'status' do
    state :created, initial: true
    state :scheduled
    state :running
    state :timeouted
    state :maintananced
    state :successful
    state :failed

    event :schedule do
      transitions from: :created, to: :scheduled
    end

    event :run do
      transitions from: [:created, :scheduled], to: :running
    end

    event :timeout do
      transitions from: :running, to: :timeouted
    end

    event :success do
      transitions from: :running, to: :successful
    end

    event :fail do
      transitions from: :running, to: :failed
    end

    event :maintenance do
      transitions from: :running, to: :maintananced
    end
  end
end
