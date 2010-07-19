class Project < ActiveRecord::Base
  
  def after_initialize
  end
  
  # ================
  # = Associations =
  # ================
  belongs_to :client
  has_many :tasks
  has_many :assigned_projects
  has_many :users, :through => :assigned_projects
  
  # ==============
  # = Attributes =
  # ==============
  # attr_protected :client_id
  
  # ===============
  # = Validations =
  # ===============
  validates_presence_of :name
  validates_presence_of :client_id
  
  # ====================
  # = Instance Methods =
  # ====================  
  
end