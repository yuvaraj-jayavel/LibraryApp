class ReturnPolicy < ApplicationPolicy
  def create?
    !!user
  end
end