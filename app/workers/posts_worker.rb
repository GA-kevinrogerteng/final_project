class PostsWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  APP_ID="563048747135539"
  APP_SECRET="8d9659c56d7d98cc6500f20c2e30cc87"
  APP_CODE=""


  def perform(fb_id, access_token, expires_in, next_page_params)
    paginate = false

    graph = Koala::Facebook::API.new(access_token, APP_SECRET)

    if next_page_params
      posts_fb = graph.get_page(next_page_params)
      paginate = true
    else
      home_url = "me/home"
      begin
        # get the last news item for the user
        last_post = Post.where(fb_uid: fb_id).order(updated_time: :desc).take!
        # deterimine the last post's timestamp
        since = last_post[:updated_time].strftime(format='%s')
        # request only the posts published since the last stored post's timestamp
        home_url = home_url + "?since=#{since}"
      rescue ActiveRecord::RecordNotFound => err
        # no posts were found for the user, so we will retrieve all available posts
        paginate = true
      end

      posts_fb = graph.get_object(home_url)
    end


    puts "retrieved #{posts_fb.length} posts"

    posts_fb.each do |post_fb|
      puts post_fb

      begin
        post = Post.find_by!(fb_uid: fb_id, fb_id: post_fb['id'])
        post.delete
      rescue ActiveRecord::RecordNotFound => err
        # ignore
      end

      post = Post.new

      post.fb_id = post_fb['id']
      post.fb_uid = fb_id
      post.fb_uid_from = post_fb['from']['id']
      post.category = post_fb['from']['category']
      post.picture = post_fb['picture']
      post.name = post_fb['name']
      post.icon = post_fb['icon']
      post.object_id = post_fb['object_id']
      post.message = post_fb['message']
      post.story = post_fb['story']
      post.link = post_fb['link']
      post.fb_type = post_fb['type']
      post.created_time = DateTime.iso8601(post_fb['created_time']).to_time
      post.updated_time = DateTime.iso8601(post_fb['updated_time']).to_time

      post.save
    end

    if paginate
      perform(fb_id, access_token, expires_in, posts_fb.next_page_params)
    end

    # update the user's feed indefinitely:
    #PostsWorker.perform_in(5.minutes, fb_id, access_token, expires_in)
  end

end