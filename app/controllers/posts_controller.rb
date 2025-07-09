class PostsController < ApplicationController
  before_action :authenticate_admin!, except: [:index, :show, :search]
  before_action :set_post, only: [:show, :edit, :update, :destroy]

 def index
  if admin_signed_in?
    @posts = if params[:q].present?
      Post.where("title LIKE :q OR body LIKE :q", q: "%#{params[:q]}%")
          .order(:status)
    else
      Post.order(:status)
    end
  else
    @posts = if params[:q].present?
      Post.published.where("title LIKE :q OR body LIKE :q", q: "%#{params[:q]}%")
                    .order(:status)
    else
      Post.published.order(:status)
    end
  end
end



  def search
    index
    render :index
  end

  def show
    unless @post.status == 'published' || admin_signed_in?
      redirect_to posts_path, alert: "You can't access this post."
    end
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.status ||= 'draft'
    if @post.save
      redirect_to @post, notice: 'Post was successfully created.'
    else
      render :new
    end
  end

  def edit; end

  def update
  if post_params[:cover_photo].present? && @post.cover_photo.attached?
    @post.cover_photo.purge
  end

  if @post.update(post_params)
    remove_empty_storage_folders
    redirect_to @post, notice: 'Post was successfully updated.'
  else
    render :edit
  end
end


  
  def remove_empty_storage_folders
    base_path = Rails.root.join("storage")

    Dir.glob("#{base_path}/**/").sort.reverse.each do |folder|
      next if folder == base_path.to_s

      begin
        if Dir.exist?(folder) && (Dir.entries(folder) - %w[. ..]).empty?
          Dir.rmdir(folder)
        end
      rescue SystemCallError
        # Skip folders that can't be deleted
      end
    end
  end

  def destroy
    @post.cover_photo.purge if @post.cover_photo.attached?
    @post.destroy
    remove_empty_storage_folders
    redirect_to posts_path, notice: "Post and image deleted."
  end



  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body, :status, :scheduled_at, :cover_photo)
  end
end
