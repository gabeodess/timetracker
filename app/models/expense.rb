# => The cost attribute is handled by "your_cost" in order to allow for validations on currency regex.  This way
# the user can enter things like "$1,000" for an amount instead of only being allowed to enter decimals.
class Expense < ActiveRecord::Base
  
  def after_initialize
    self.your_cost ||= cost.to_s if attributes[:cost]
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
  validates_presence_of :project_id, :name, :cost
  
  # =========
  # = Hooks =
  # =========
  before_save :set_cost
  
  def set_cost
    self.cost = your_cost.gsub(/\$|,/, '') if your_cost
  end
  
  
end