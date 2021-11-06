class BookPolicy < ApplicationPolicy
  def create?
    !!user
  end

  def index?
    true
  end
end