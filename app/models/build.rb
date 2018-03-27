class Build < ApplicationRecord
  include AASM
  scope :running, -> { where(status: 'running') }
  scope :queued, -> { where(status: 'queued') }
  scope :sorted_queued, -> { queued.order(created_at: :asc) }

  belongs_to :project
  has_many :logs, dependent: :destroy

  aasm column: 'status' do
    state :created, :initial => true
    state :queued
    state :running
    state :canceled
    state :timeouted
    state :maintananced
    state :successful
    state :failed
    state :empty_config
    state :config_not_valid

    event :empty do
      transitions :from => :created, :to => :empty_config
    end

    event :not_valid do
      transitions :from => :created, :to => :config_not_valid
    end

    event :queue do
      transitions :from => :created, :to => :queued
    end

    event :run do
      transitions :from => [:created, :queued], :to => :running
    end

    event :cancel do
      transitions :from => [:created, :queued, :running], :to => :canceled
    end

    event :timeout do
      transitions :from => [:running], :to => :running
    end

    event :success do
      transitions :from => [:running], :to => :successful
    end

    event :fail do
      transitions :from => [:running], :to => :failed
    end

    event :maintenance do
      transitions :from => [:running], :to => :maintananced
    end
  end
end
