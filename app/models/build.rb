class Build < ApplicationRecord
  include AASM
  scope :running, -> { where(status: ['running', 'queued', 'created']) }
  scope :queued, -> { where(status: 'queued') }
  scope :sorted_queued, -> { queued.order(created_at: :asc) }

  belongs_to :project
  has_many :logs, dependent: :destroy
  has_one :user, through: :projects

  def cancel_nomad_job
    NomadTask.stop(self.dispatched_job_id)
  end

  def dispatch_to_nomad
    meta = {
      build_id: self.id,
      ssh_key: self.project.deploy_key,
      username: self.payload[:repository][:owner][:login],
      repository: self.payload[:repository][:ssh_url],
      branch: self.payload[:ref].split('/').last,
      commit: self.payload[:after],
    }
    result = NomadTask.dispatch(Base64.encode(self.configuration), meta)
    self.update!(dispatched_job_id: result[:DispatchedJobID])
  end

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
    state :skiped

    event :empty do
      transitions :from => :created, :to => :empty_config
    end

    event :skip do
      transitions :from => :created, :to => :skiped
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
