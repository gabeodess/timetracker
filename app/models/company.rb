class Company < ActiveRecord::Base
  
  def after_initialize
  end
  
  # ================
  # = Associations =
  # ================
  has_many :company_based_roles, :dependent => :destroy
  has_many :users, :through => :company_based_roles
  has_many :clients
  has_many :invoices, :through => :clients
  has_many :projects, :through => :clients
  has_many :tasks, :dependent => :destroy
  has_many :associated_tasks, :through => :tasks, :dependent => :destroy
  belongs_to :owner, :class_name => "User"
  
  def timer_ids
    @timer_ids ||= projects.all(:include => [:timers]).map{|item| item.timers.map{|a| a.id}}.flatten
  end
  
  def timers
    ids = timer_ids.empty? ? 0 : timer_ids
    Timer.id_is_any(ids)
  end
  
  # ==============
  # = Attributes =
  # ==============
  attr_protected :owner_id
  
  # =========
  # = Hooks =
  # =========
  after_create :create_default_tasks, :add_owner_to_users
  before_destroy :destroy_worthy?
  
  def destroy_worthy?
    clients.first(:select => 'id').nil?
  end
  
  def add_owner_to_users
    CompanyBasedRole.create!({:user => owner, :company => self, :name => 'admin'})
  end
  
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
  validate :validate_uniqueness_of_name
  validates_presence_of :owner_id, :url_id
  validates_uniqueness_of :url_id
  validates_format_of :url_id, :with => /^[A-Za-z0-9-]+$/
  
  def validate_uniqueness_of_name
    company_scope = new_record? ? [:id_not_null] : [:id_not, id]
    errors.add :name, "has already been taken." if Company.send(*company_scope).find_by_owner_id_and_name(owner_id, name)
  end
  
  # ====================
  # = Instance Methods =
  # ====================
  def owner_name
    owner.login
  end
  
  def admin_ids
    company_based_roles.name_is('admin').map(&:user_id) << owner_id
  end
  
  def to_param
    url_id
  end
  
  # =================
  # = Class Methods =
  # =================
  def self.authenticate(my_url_id, current_user)
    company = owner_id_is(current_user.id).url_id_is(my_url_id).first
    return company ? company : current_user.companies.url_id_is(my_url_id).first
  end
  
end