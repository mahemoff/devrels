require 'json'
require 'twitter'
require 'hashie'

module Jekyll

  class TagsTag < Liquid::Tag

    def render(context)
      tags = context['devrel']['tags']
      return unless tags
      tags_html = tags.split(',').map { |t| "<span class='tag'>#{t.strip}</span>" }.join(' ')
      "<div class='tags'>#{tags_html}</div>"
    end

  end

end

Liquid::Template.register_tag('tags', Jekyll::TagsTag)
