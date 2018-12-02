class Role < ApplicationRecord
  has_and_belongs_to_many :users, :join_table => :users_roles
  belongs_to :resource,
             :polymorphic => true,
             :optional => true

  validates :resource_type,
            :inclusion => { :in => Rolify.resource_types },
            :allow_nil => true


  validates :name, presence: true
  #validates :name, presence: true, uniqueness: true, length: {:in => 2..30}
  validates :name, inclusion: { in: ["admin", "manager", "specialist", "viewer"] }, uniqueness: true

  #enum role: [:admin, :manager, :specialist, :client ]


  scopify
end