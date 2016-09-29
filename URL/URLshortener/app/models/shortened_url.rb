require 'securerandom'

# == Schema Information
#
# Table name: shortened_urls
#
#  id         :integer          not null, primary key
#  long_url   :string
#  short_url  :string
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class ShortenedUrl < ActiveRecord::Base
  validates :short_url, presence: true, uniqueness: true

  belongs_to(
    :submitter,
    :class_name => "User",
    :foreign_key => :user_id,
    :primary_key => :id
  )

  has_many(
    :visits,
    :class_name => "Visit",
    :foreign_key => :short_url_id,
    :primary_key => :id
  )

  has_many(
    :visitors,
    Proc.new {distinct},
    :through => :visits,
    :source => :submitter
  )

  def self.random_code
    code = SecureRandom.urlsafe_base64

    while ShortenedUrl.exists?(short_url: code)
      code = SecureRandom.urlsafe_base64
    end
    "example.com/#{code}"
  end

  def self.create_for_user_and_long_url!(user, long_url)
    ShortenedUrl.create!(long_url: long_url, short_url: self.random_code, user_id: user.id)
  end

  def num_clicks
    Visit.all.select { |visit_object| visit_object.short_url_id == self.id}.length
  end

  def num_uniques
    Visit.select(:user_id).distinct.length
  end

  def num_recent_uniques
    Visit.all.where({created_at: 10.minutes.ago..0.minutes.ago}).select(:user_id).distinct.length
  end

end
