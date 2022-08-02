class CreateAdmissionBatches < ActiveRecord::Migration[5.2]
  def change
    create_table :admission_batches do |t|
      # org = Org.first
      # ['latur', 'nanded'].each do |rcc_branch|
      #   ['NEET', 'JEE'].each do |course_type|
      #     courses = ['pcb', 'phy', 'chem', 'bio', 'pc', 'pb', 'cb'] if course_type == 'NEET'
      #     courses = ['phy', 'chem', 'pc'] if course_type == 'JEE'
      #     courses.each do |course_name|
      #       batch_name = rcc_branch == "latur" ?
      #         "LTR-11-REG-#{course_type}-#{course_name.upcase}-21-22" :
      #         "NED-11-REG-#{course_type}-#{course_name.upcase}-21-22"

      #       _batch = Batch.find_by(org_id: org.id, name: batch_name)
      #       if _batch.blank?
      #         admin = Admin.where(org_id: org.id).first
      #         group_name = "11-REG-#{rcc_branch.upcase}-2021-22"
      #         batch_group = BatchGroup.find_or_create_by(name: group_name, org_id: org.id)
      #         _batch = Batch.create(org_id: org.id, name: batch_name, batch_group_id: batch_group.id)
      #         AdminBatch.create(admin_id: admin.id, batch_id: _batch.id)
      #       end
      #       Batch.where(org_id: org.id, name: batch_name)
      #     end
      #   end
      # end
    end
  end
end
