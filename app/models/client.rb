class Client < ActiveRecord::Base
  
  def after_initialize
  end
  
  # ================
  # = Associations =
  # ================
  has_many :projects, :dependent => :destroy
  has_many :tasks, :through => :projects
  has_many :contacts, :dependent => :destroy
  belongs_to :company

  
  
  # ==============
  # = Attributes =
  # ==============
  attr_protected :company_id
  
  # ===============
  # = Validations =
  # ===============
  validates_presence_of :name
  validates_presence_of :company_id
  
  
end