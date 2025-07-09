class Post < ApplicationRecord
  has_one_attached :cover_photo

  scope :published, -> {
    where(status: 'published')
    .where('scheduled_at <= ?', Time.current.in_time_zone('Asia/Manila'))
  }

  def publish!
    update(status: 'published', scheduled_at: Time.current.in_time_zone('Asia/Manila'))
  end
end
