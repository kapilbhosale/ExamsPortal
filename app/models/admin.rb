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
#  org_id                 :integer          default(0)
#
# Indexes
#
#  index_admins_on_email                 (email) UNIQUE
#  index_admins_on_id_and_type           (id,type)
#  index_admins_on_org_id                (org_id)
#  index_admins_on_reset_password_token  (reset_password_token) UNIQUE
#

#  current_sign_in_at     :datetime
#  current_sign_in_ip     :inet
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :inet
#  name                   :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_admins_on_email                 (email) UNIQUE
#  index_admins_on_reset_password_token  (reset_password_token) UNIQUE
#


class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :org

  validates :org_id, presence: true

  has_many :admin_batches
  has_many :batches, through: :admin_batches

  # Admin accounts are
  # 1. Admin
  # 1. Head of Class
  # 1. teacher
  # 1. operator

  attr_writer :login

  ROLES = [
    :students,
    :batches,
    :subjects,
    :reports,
    :exams,
    :videos,
    :pdfs,
    :notifications,
    :live_classes,
    :omr,
    :attendance,
    :admin_users,
    :payments,
    :notes,
    :discounts,


    :batch_delete,
    :batch_edit,
    :download_students,
    :delete_student,
    :ff,
    :online_pay,
    :all_fees
  ]

  def login
    @login || self.email
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end

  # methods to mangae acces

  def can_manage(area)
    roles.include? area.to_s
  end

  def token
    payload = {
      id: id,
      exp: 24.hours.from_now.to_i
    }
    JWT.encode(payload, Rails.application.secrets.secret_key_base.to_s)
  end
end
