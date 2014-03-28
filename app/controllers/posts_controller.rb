class PostsController < ApplicationController
  layout 'empty'

  APP_ID="563048747135539"
  APP_SECRET="8d9659c56d7d98cc6500f20c2e30cc87"
  #APP_CODE=""
  #SITE_URL="http://localhost:3000/"

  def new
    @post = Post.new
    @post.fb_uid_from = params[:fb_uid]
  end

  def create
    post_params = params.require(:post).permit(:fb_uid_from, :local_photo, :message)
    if post_params[:fb_uid_from] && post_params[:local_photo] && post_params[:message]
      post = Post.create(post_params)
      post.fb_type = 'photo'
      post.picture = post.local_photo.url
      post.updated_time = post.created_time = DateTime.now
      post.save
    end
    redirect_to '/'
  end


  def index
    respond_to do |f|
      f.html {
        #redirect_to posts_path
      }

      f.json {
        PostsWorker.perform_async(params[:uid], params[:t], params[:e], nil)

        posts = Post.where("fb_uid = '#{params[:uid]}' OR fb_uid IS NULL")

        if params[:fb_type] && params[:fb_type] != "all"
          posts = posts.where(fb_type: params[:fb_type])
        end

        if params[:message]
          posts = posts.where("message LIKE '%#{params[:message]}%'")
        end

        render :json => posts.order(updated_time: :desc).limit(3)
      }
    end

  end

end

