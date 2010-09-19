class Expense < ActiveRecord::Base
  
  def after_initialize
    self.your_cost ||= cost.to_s if cost
  end
  
  # ================
  # = Associations =
  # ================
  belongs_to :invoice
  belongs_to :project

  
  
  # ==============
  # = Attributes =
  # ==============
  attr_accessor :your_cost
  
  # ===============
  # = Validations =
  # ===============
  validates_format_of :your_cost, :with => Validator.currency_regex, :allow_blank => true
  validates_presence_of :project
  
  # =========
  # = Hooks =
  # =========
  before_save :set_cost
  
  def set_cost
    self.cost = your_cost.gsub(/\$|,/, '') if your_cost
  end
  
  
end