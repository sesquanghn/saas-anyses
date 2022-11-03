class LeaveApplicationPolicy < ApplicationPolicy
  def show?
    can_view?
  end

  def update?
    can_modify?
  end

  def destroy?
    can_modify?
  end

  private

  def can_view?
    admin? || record.employee_id == employee.id
  end

  def can_modify?
    can_view? && record.pending? && record.date_of_application >= Date.current
  end
end
