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
  belongs_to :owner, :class_name => "User"
  
  # ==============
  # = Attributes =
  # ==============
  attr_protected :owner_id
  
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