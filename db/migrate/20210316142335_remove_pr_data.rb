class RemovePrData < ActiveRecord::Migration[5.2]
  def change
    ProgressReport.where("exam_name ilike ?", "%(omr)").delete_all
  end
end
