class MemberPolicy < ApplicationPolicy
  def create?
    !!user
  end

  def index?
    !!user
  end
end