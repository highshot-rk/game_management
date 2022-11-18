class NewsPolicy < ApplicationPolicy
  def create?
    false
  end

  def index?
    true
  end

  def update?
    author? || admin?
  end

  def destroy?
    update?
  end

  private

  def author?
    record.user == user
  end

  def admin?
    user.try(:staff?)
  end
end
