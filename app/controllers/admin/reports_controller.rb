class Admin::ReportsController < ApplicationController
  def index
    @test = {name: "Mock Test 2018", marks: 180, date: '15 July 2018'}
    @students = [
      {id: 1, name: 'Kapil Bhosale', batch: '12th Neet', marks: 160, rank: 1},
      {id: 1, name: 'Deepak Jadhav', batch: '12th Neet', marks: 157, rank: 2},
      {id: 1, name: 'kalpak Bhosale', batch: '12th Neet', marks: 151, rank: 3},
      {id: 1, name: 'Akshay Mohite', batch: '12th Neet', marks: 139, rank: 4},
      {id: 1, name: 'Deepak potdar', batch: '12th Neet', marks: 139, rank: 5},
      {id: 1, name: 'Sachin chole', batch: '12th Neet', marks: 120, rank: 6},
      {id: 1, name: 'sumit Joshi', batch: '12th Neet', marks: 119, rank: 7},
      {id: 1, name: 'Amol Patil', batch: '12th Neet', marks: 119, rank: 8},
      {id: 1, name: 'Somnath kada', batch: '12th Neet', marks: 111, rank: 9},
      {id: 1, name: 'Kiran Kale', batch: '12th Neet', marks: 110, rank: 10},
      {id: 1, name: 'Nilesh Rothe', batch: '12th Neet', marks: 110, rank: 11},
      {id: 1, name: 'Arutwar krisha', batch: '12th Neet', marks: 100, rank: 12},
      {id: 1, name: 'samadhan jadhav', batch: '12th Neet', marks: 99, rank: 13},
      {id: 1, name: 'patil vishal', batch: '12th Neet', marks: 10, rank: 14},
      {id: 1, name: 'more vittha', batch: '12th Neet', marks: 1, rank: 15},
    ]
  end
end
