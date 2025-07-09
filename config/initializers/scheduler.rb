require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

scheduler.every '1m' do
  now = Time.current.in_time_zone('Asia/Manila')
  Post.where(status: 'draft').where('scheduled_at <= ?', now).find_each(&:publish!)
end
