class PostsController < ApplicationController
  layout 'empty'

  APP_ID="563048747135539"
  APP_SECRET="8d9659c56d7d98cc6500f20c2e30cc87"

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
        # update user's news feed in the background while presenting the latest posts fetched earlier
        PostsWorker.perform_async(params[:uid], params[:t], params[:e], nil)

        # fb_uid IS NULL is for off-Facebook posts, which are targeted to all users
        posts = Post.where("fb_uid = '#{params[:uid]}' OR fb_uid IS NULL")

        # constrain posts by post type, if specified
        if params[:fb_type] && params[:fb_type] != "all"
          posts = posts.where(fb_type: params[:fb_type])
        end

        # constrain posts by message substring, if specified
        if params[:message]
          posts = posts.where("message LIKE '%#{params[:message]}%'")
        end

        # retrieve the latest matching posts available
        render :json => posts.order(updated_time: :desc).limit(20)
      }
    end

  end

end

