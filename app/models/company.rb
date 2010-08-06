class Company < ActiveRecord::Base
  
  def after_initialize
  end
  
  # ================
  # = Associations =
  # ================
  has_many :company_based_roles, :dependent => :destroy
  has_many :users, :through => :company_based_roles
  has_many :clients, :dependent => :destroy
  has_many :projects, :through => :clients
  # has_many :assignments, :through => :projects
  has_many :tasks, :dependent => :destroy
  has_many :associated_tasks, :through => :tasks, :dependent => :destroy
  belongs_to :owner, :class_name => "User"
  
  def assignment_ids
    @assignment_ids ||= projects.all(:include => [:assignments]).map{|item| item.assignments.map{|a| a.id}}.flatten
  end
  
  def assignments
    ids = assignment_ids.empty? ? 0 : assignment_ids
    Assignment.id_is_any(ids)
  end
  
  # ==============
  # = Attributes =
  # ==============
  attr_protected :owner_id
  
  # =========
  # = Hooks =
  # =========
  after_create :create_default_tasks
  
  def create_default_tasks
    ["Research", "Development", "Design", "Project Management"].each do |name|
      task = Task.new({:name => name, :default => true})
      task.company_id = id
      task.save!
    end
  end
  
  # ===============
  # = Validations =
  # ===============
  validates_presence_of :owner_id
  validates_presence_of :url_id
  validates_uniqueness_of :url_id
  validates_format_of :url_id, :with => /^[A-Za-z0-9-]+$/
  
  # ====================
  # = Instance Methods =
  # ====================
  def admin_ids
    company_based_roles.name_is('admin').map(&:user_id) << owner_id
  end
  
  def to_param
    url_id
  end
  
end