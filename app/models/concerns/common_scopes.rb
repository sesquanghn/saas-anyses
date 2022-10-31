module CommonScopes
  extend ActiveSupport::Concern

  included do
    scope :by_employee_id, ->(employee_id) { where(employee_id: employee_id) }
  end
end
