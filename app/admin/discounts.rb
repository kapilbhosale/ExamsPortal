ActiveAdmin.register Discount do
  permit_params :amount, :student_name, :parent_mobile, :student_mobile, :status, :data, :comment

  actions :index, :show

  filter :amount
  filter :student_name
  filter :parent_mobile
  filter :approved_by
  filter :type_of_discount
  filter :status
  filter :created_at


  index do
    selectable_column
    id_column
    column :amount
    column :approved_by
    column :student_name
    column :parent_mobile
    column :student_mobile
    column :type_of_discount
    column :status
    column :comment
    column :data
    column :created_at
  end
end
