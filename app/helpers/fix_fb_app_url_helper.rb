# To change this template, choose Tools | Templates
# and open the template in the editor.

module FixFbAppUrlHelper
  def link_to(*args, &block)
    if block_given?
      options      = args.first || {}
      html_options = args.second
      concat(link_to(capture(&block), options, html_options))
    else
      name         = args.first
      options      = args.second || {}
      html_options = args.third || {}

      options[:force_fbapp_url] = true if options.is_a?(Hash)
      html_options[:target] ||= '_top'
      url = url_for(options)

      if html_options
        html_options = html_options.stringify_keys
        href = html_options['href']
        convert_options_to_javascript!(html_options, url)
        tag_options = tag_options(html_options)
      else
        tag_options = nil
      end

      href_attr = "href=\"#{url}\"" unless href
      "<a #{href_attr}#{tag_options}>#{name || url}</a>"
    end
  end

  def fb_will_paginate(collection = nil, options = {})
    options[:params] ||= {}
    options[:params][:force_fbapp_url] = true
    will_paginate collection, options
  end
end
