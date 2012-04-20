require 'json'
require 'twitter'
require 'hashie'

module Jekyll

  class TwitterInfoTag < Liquid::Tag

    def initialize(tag_name, twitter_id, tokens)
      super
      # @text = twitter_id
    end

    def linkify(twitter_user, message)
      return message if twitter_user.url.nil? or twitter_user.url==''
      return "<a target='_blank' href='#{twitter_user.url}'>#{message}</a>"
    end

    def write_file(path, content)
      File.open(path, 'w') { |f| f.write(content) }
    end

    def days_old(path)
      return nil unless File.exist?(path)
      (Time.now - File.mtime(path))/(24 * 60 * 60)
    end

    def lookup_user(twitter_id)
      path = "#{File.dirname(__FILE__)}/../_twitter_cache/#{twitter_id}.json"
      if !days_old(path) or days_old(path) > 30 + rand(30) # add jitter for better scaling
        twitter_user = Twitter.user(twitter_id)
        user_attribs =  twitter_user.attrs
        write_file path, user_attribs.to_json
      else
        user_attribs = JSON.parse File.read(path)
      end
      Hashie::Mash.new user_attribs
    end

    # we can't pass the value in unfortunately, so need to hard-code it from env
    # http://stackoverflow.com/questions/7666236/how-to-pass-a-variable-into-a-custom-tag-in-liquid
    def render(context)
      twitter_id = context['devrel']['twitter']
      u = lookup_user(twitter_id)
<<END
  <p>
    #{linkify u, "<img src='#{u.profile_image_url}'</img>"}
    #{linkify u, "<span class='name'>#{u.name}</span>"}
  </p>
  <p class='description'>#{u.description}</p>
END
    end

  end

end

Liquid::Template.register_tag('twitter_info', Jekyll::TwitterInfoTag)
