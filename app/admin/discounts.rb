ActiveAdmin.register Discount do
  permit_params :amount, :student_name, :parent_mobile, :student_mobile, :status, :data


  filter :amount
  filter :student_name
  filter :parent_mobile
  filter :approved_by
  filter :type_of_discount
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
    column :data
    column :created_at
  end

  form do |f|
    f.inputs 'Org Admins' do
      f.input :amount
      f.input :student_name
      f.input :parent_mobile
      f.input :student_mobile
      f.input :type_of_discount
      f.input :status
      f.input :data
    end

    f.actions
  end
end


#  amount           :decimal(, )
#  approved_by      :string
#  comment          :string
#  data             :jsonb
#  parent_mobile    :string
#  roll_number      :string
#  status           :string
#  student_mobile   :string
#  student_name     :string
#  type_of_discount :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  org_id           :bigint(8)