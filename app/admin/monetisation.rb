ActiveAdmin.register Monetisation do
  permit_params :paypal_account, :approved

  index do
    selectable_column
    [:id, :game, :paypal_account, :approved, :created_at, :updated_at].each { |c| column c }
    actions
  end
end
