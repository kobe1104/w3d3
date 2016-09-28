# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
  has_many(
    :enrollments,
    :class_name => "Enrollment",
    :foreign_key => :student_id,
    :primary_key => :id
  )

  has_many(
  :enrolled_courses,
  :through => :enrollments,
  :source => :course
  )

  has_many(
  :taught_courses,
  :class_name => "Course",
  :foreign_key => :instructor_id,
  :primary_key => :id
  )
end
