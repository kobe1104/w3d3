# == Schema Information
#
# Table name: visits
#
#  id           :integer          not null, primary key
#  user_id      :integer          not null
#  short_url_id :integer          not null
#

class Visit < ActiveRecord::Base
  validates :user_id, presence: true
  validates :short_url_id, presence: true

  belongs_to(
    :submitter,
    :class_name => "User",
    :foreign_key => :user_id,
    :primary_key => :id
  )

  belongs_to(
    :visited_short_url,
    :class_name => "ShortenedUrl",
    :foreign_key => :short_url_id,
    :primary_key => :id
  )

  def self.record_visit!(user, shortened_url)
    Visit.create!(user_id: user.id, short_url_id: shortened_url.id)
  end

end