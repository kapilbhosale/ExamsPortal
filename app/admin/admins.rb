ActiveAdmin.register Admin do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

	permit_params :name, :email, :password, :password_confirmation, :org_id, :roles

  index do
    selectable_column
    id_column
    column :name
    column :email
    column :password
    column :phone
    column :roles
    column :created_at
    actions
  end

  form do |f|
    f.inputs 'Org Admins' do
      f.input :name
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :roles
      f.input :org, as: :select, collection: Org.all.map { |org| [org.subdomain, org.id] }, include_blank: false
    end

    f.actions
  end
end
