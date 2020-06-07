class AddCoursePbcbToNewAdmission < ActiveRecord::Migration[5.2]
  def change
    courses = [
      {name: 'pb', fees: 20_000.00},
      {name: 'cb', fees: 20_000.00}
    ]
    courses.each do |course|
      Course.find_or_create_by(course);
    end
  end
end
