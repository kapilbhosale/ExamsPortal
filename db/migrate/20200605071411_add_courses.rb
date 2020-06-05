class AddCourses < ActiveRecord::Migration[5.2]
  def change
    courses = [
      {name: 'phy', fees: 10_000.00},
      {name: 'chem', fees: 10_000.00},
      {name: 'bio', fees: 10_000.00},
      {name: 'pcb', fees: 25_000.00}
    ]
    if Course.count == 0
      Course.create(courses);
    end
  end
end
