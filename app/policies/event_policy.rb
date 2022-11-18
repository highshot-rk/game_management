class EventPolicy < ApplicationPolicy
  def create?
    admin? || user.score >= Settings.privileges.events.create.required_level
  end

  def index?
    true
  end

  def update?
    author? || admin?
  end

  def destroy?
    author? || admin?
  end

  private

  def author?
    record.user == user
  end

  def admin?
    user.try(:staff?)
  end
end
