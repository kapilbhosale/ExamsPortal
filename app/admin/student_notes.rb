ActiveAdmin.register StudentNote do
  permit_params :note, :student, :org_id

  filter :note
  filter :student
  filter :batches
  filter :created_at

  index do
    selectable_column
    id_column
    column :note
    column :student
    column :batches
    column :created_at

    actions
  end
end
