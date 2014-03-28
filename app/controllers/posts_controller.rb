class PostsController < ApplicationController
  layout 'empty'

  APP_ID="563048747135539"
  APP_SECRET="8d9659c56d7d98cc6500f20c2e30cc87"
  APP_CODE=""
  SITE_URL="http://localhost:3000/"

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

    #profile = @graph.get_object("me")
    #friends = @graph.get_connections("me", "friends")
    # @graph.put_connections("me", "feed", :message => "I am writing on my wall!")

#    if session['access_token']
 #     @face='You are logged in! <a href="facebooks/logout">Logout</a>'
      # do some stuff with facebook here
      # for example:
      # @graph = Koala::Facebook::GraphAPI.new(session["access_token"])
      # publish to your wall (if you have the permissions)
      # @graph.put_wall_post("I'm posting from my new cool app!")
      # or publish to someone else (if you have the permissions too ;) )
      # @graph.put_wall_post("Checkout my new cool app!", {}, "someoneelse's id")
#    else
#      @face='<a href="posts/login">Login</a>'
#    end
  end

  # def login
  # # generate a new oauth object with your app data and your callback url
  #   session['oauth'] = Koala::Facebook::OAuth.new(APP_ID, APP_SECRET, SITE_URL + 'feeds/callback')
  #   #Koala::Facebook::OAuth.new(oauth_callback_url).

  #   # redirect to facebook to get your code
  #   redirect_to session['oauth'].url_for_oauth_code()

  # end

  # def logout
  #   session['oauth'] = nil
  #   session['access_token'] = nil
  #   redirect_to '/feeds/index'
  # end

  #method to handle the redirect from facebook back to you
  # def callback
  #   #get the access token from facebook with your code
  #   session['access_token'] = session['oauth'].get_access_token(params[:code])
  #   redirect_to '/feeds/menu'
  # end

  # def menu
  #    @ok="you are welcome"
  #    if session['access_token']
  #      @face='You are logged in! <a href="/feeds/logout">Logout</a>'
  #      # do some stuff with facebook here
  #      # for example:
  #      # @graph = Koala::Facebook::GraphAPI.new(session["access_token"])
  #      # publish to your wall (if you have the permissions)
  #      # @graph.put_wall_post("I'm posting from my new cool app!")
  #      # or publish to someone else (if you have the permissions too ;) )
  #      # @graph.put_wall_post("Checkout my new cool app!", {}, "someoneelse's id")
  #    else
  #      @face='<a href="/feeds/login">Login</a>'
  #    end

  # end
end

