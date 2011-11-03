require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  
  # ================
  # = Associations =
  # ================
  has_many :company_based_roles
  has_many :companies, :through => :company_based_roles do
    def <<(company)
      CompanyBasedRole.create!({:email => proxy_owner.email, :company => company})
    end
  end
  has_many :assignments
  has_many :assigned_projects
  has_many :projects, :through => :assigned_projects
  has_many :timers
  
  # ===============
  # = Validations =
  # ===============
  validates_inclusion_of :billing_rate, :in => 1..1000000, :message => ": Please enter a non-zero billing rate."
  validates_numericality_of :billing_rate
  
  validates_presence_of     :login
  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login
  validates_format_of       :login,    :with => Authentication.login_regex, :message => Authentication.bad_login_message

  validates_format_of       :name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of       :name,     :maximum => 100

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message

  

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessor :current_company
  attr_accessible :login, :email, :name, :password, :password_confirmation, :current_company, :billing_rate



  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  
  # =========
  # = Hooks =
  # =========
  after_create :update_company_based_roles
  
  def update_company_based_roles
    CompanyBasedRole.update_all({:user_id => id}, {:id => CompanyBasedRole.find_all_by_email(email).map(&:id)})
  end
  
  # ====================
  # = Instance Methods =
  # ====================  
  def has_multiple_companies?
    @has_multiple_comanies ||= companies.count > 1
  end
  
  def has_role?(role)
    role_symbols.include?(role.to_sym)
  end
  
  def to_param
    login
  end
    
  def role_symbols
    (current_company ? company_based_roles.company_id_is(current_company.id).map(&:name).map(&:to_sym) : []) << :user
  end
  
  # =================
  # = Class Methods =
  # =================
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find_by_login(login.downcase) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # ======================
  # = Virtual Attributes =
  # ======================
  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end

  protected
    


end
