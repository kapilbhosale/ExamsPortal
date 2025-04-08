# == Schema Information
#
# Table name: admins
#
#  id                     :bigint(8)        not null, primary key
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :inet
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :inet
#  name                   :string
#  photo                  :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  roles                  :jsonb
#  sign_in_count          :integer          default(0), not null
#  type                   :string           default("Teacher")
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  branch_id              :integer          default(1), not null
#  org_id                 :integer          default(0)
#
# Indexes
#
#  index_admins_on_branch_id             (branch_id)
#  index_admins_on_email                 (email) UNIQUE
#  index_admins_on_id_and_type           (id,type)
#  index_admins_on_org_id                (org_id)
#  index_admins_on_reset_password_token  (reset_password_token) UNIQUE
#

class Manager < Admin
  belongs_to :org
end
