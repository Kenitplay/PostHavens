json.extract! post, :id, :title, :body, :status, :scheduled_at, :created_at, :updated_at
json.url post_url(post, format: :json)
