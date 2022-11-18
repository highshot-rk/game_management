class GamePolicy < ApplicationPolicy
  def create?
    true
  end

  def index?
    true
  end

  def update?
    author? || admin?
  end

  alias stats? update?

  def manage?
    author?
  end

  def destroy?
    update?
  end

  def admin_area?
    admin?
  end

  def players_list?
    update?
  end

  def record_info?
    update?
  end

  def monetisation?
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
