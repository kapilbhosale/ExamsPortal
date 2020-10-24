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

	permit_params :name, :email, :password, :password_confirmation, :org_id

  form do |f|
    f.inputs 'Org Admins' do
      f.input :name
      f.input :email
      f.input :password if f.object.new_record?
      f.input :password_confirmation if f.object.new_record?
      f.input :org
    end

    f.actions
  end
end
