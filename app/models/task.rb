class Task < ActiveRecord::Base
  
  def after_initialize
  end
  
  # ================
  # = Associations =
  # ================
  belongs_to :company
  has_many :associated_tasks
  has_many :assignments, :through => :associated_tasks

  
  
  # ==============
  # = Attributes =
  # ==============
  attr_protected :company_id
  
  # ===============
  # = Validations =
  # ===============
  validates_presence_of :company_id
  validates_presence_of :name
  validates_uniqueness_of :name, :on => :create, :if => lambda{ |task| Task.company_id_is(task.company_id).name_is(task.name).count > 0 }
  
  
end