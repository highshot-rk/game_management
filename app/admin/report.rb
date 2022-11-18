# frozen_string_literal: true
ActiveAdmin.register Report do
  actions :all, except: [:create, :new, :edit, :update, :destroy]

  index do
    selectable_column
    [:created_at, :user, :reason, :message, :download_link, :game].each { |c| column c }
    actions do |report|
      link_to 'Resolve', resolve_admin_report_path(report.id), method: :put unless report.resolved?
    end
  end

  includes :user, :download_link, :game

  member_action :resolve, method: :put do
    resource.update!(resolved: true)
    redirect_to admin_reports_path, notice: 'Resolved!'
  end

  action_item :resolve, only: :show do
    link_to 'Resolve', resolve_admin_report_path(report.id), method: :put unless report.resolved?
  end

  [:user, :game, :reason, :message, :created_at, :updated_at].each { |f| filter f }

  scope :todo, default: true
  scope :resolved
end
