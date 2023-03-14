ActiveAdmin.register Note do
  permit_params :name, :description, :org_id, :min_pay

  filter :name
  filter :min_pay
  filter :created_at

  index do
    selectable_column
    id_column
    column :name
    column :description
    column :min_pay
    column :org

    actions
  end

  form do |f|
    f.inputs 'Org Admins' do
      f.input :name
      f.input :description
      f.input :min_pay, as: :select, collection: Note.min_pays.keys, include_blank: false
      f.input :org, as: :select, collection: Org.all.map { |org| [org.subdomain, org.id] }, include_blank: false
    end

    f.actions
  end
end
