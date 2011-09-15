# => The cost attribute is handled by "your_cost" in order to allow for validations on currency regex.  This way
# the user can enter things like "$1,000" for an amount instead of only being allowed to enter decimals.
class Expense < ActiveRecord::Base
  
  def after_initialize
    self.your_cost ||= cost.to_s if attribute_present?(:cost)
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

  # ======================
  # = Virtual Attributes =
  # ======================
  def your_cost=(value)
    instance_variable_set("@your_cost", value)
    self.cost = value.gsub(/\$|,/, '')
  end
  
  
end