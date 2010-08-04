class Project < ActiveRecord::Base
  
  def after_initialize
  end
  
  # ================
  # = Associations =
  # ================
  belongs_to :client
  has_many :associated_tasks, :dependent => :destroy
  has_many :tasks, :through => :associated_tasks
  has_many :assigned_projects, :dependent => :destroy
  has_many :users, :through => :assigned_projects
  
  # ==============
  # = Attributes =
  # ==============
  attr_protected :client_id
  
  # =========
  # = Hooks =
  # =========
  
  # ===============
  # = Validations =
  # ===============
  validates_presence_of :name
  validates_presence_of :client_id
  
  # ====================
  # = Instance Methods =
  # ====================  
  
end