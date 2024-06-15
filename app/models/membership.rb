class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :project

  validates :role, presence: true, inclusion: { in: %w[owner member] }
end
