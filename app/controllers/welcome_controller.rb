class WelcomeController < ApplicationController
  def index
  end

  def login
  	render :layout => false
  end

  def signup
  	render :layout => false
  end

  def site
    if (params['fm'] || params['by'])
      Request.create(:params_txt => params.inspect, :utm_source => params['fm'],
        :utm_referer => params['by'], :utm_ip => request.remote_ip)
    else
      Request.create(:params_txt => params.inspect, :utm_ip => request.remote_ip)
    end
    @msg = 'done' if params['msg']    
  	render :layout => false
  end

  def message
    Request.create(:params_txt => params.inspect)
    redirect_to controller: 'welcome', action: 'site', msg: 'done'
  end

  def permalink
    permalink = params['permalink']
    require 'mechanize'

    agent = Mechanize.new
    agent.user_agent_alias = 'Windows Mozilla'
    page = agent.get("http://www.sarkarinaukrisarch.in/#{params['permalink']}/")    

    one_page_post = Hash.new
    
    one_page_post["title"] = page.at('.post-title').text.strip
    one_page_post["content"] = page.at('.post-content').text.strip
    puts"++++++#{one_page_post["title"]}++++++++"


    @one_page_post = one_page_post

    render :layout => false
  end

  def mechanize
    require 'mechanize'

    agent = Mechanize.new
    agent.user_agent_alias = 'Windows Mozilla'
    page = agent.get('http://www.sarkarinaukrisarch.in')    

    one_page_post = Hash.new
    #sec_page_post = Hash.new

    agent.page.search('.status-publish').each_with_index do |h2,dex|
      if !h2.at('.post-title').text.strip.include? 'Affairs'
        one_page_post["title=#{dex}"] = h2.at('.post-title').text.strip
        permalink = one_page_post["title=#{dex}"]
        permalink = page.link_with(text: "#{permalink}").uri        
        permalink = permalink.to_s.split("http://www.sarkarinaukrisarch.in/").last
        permalink = permalink.to_s.split("/").first
        one_page_post["permalink=#{dex}"] = permalink
        one_page_post["time=#{dex}"] = h2.at('.post-time').text.strip
        one_page_post["content=#{dex}"] = h2.at('.post-content').text.strip        
        #one_page_post["image=#{dex}"] = h2.at('.alignleft').attributes["src"].value      
      end
    end

    @one_page_post = one_page_post

    # page = agent.get('http://www.sarkarinaukrisarch.in/page/2/')
    # agent.page.search('.status-publish').each_with_index do |h2,dex|
    #   if !h2.at('.post-title').text.strip.include? 'Affairs'
    #     sec_page_post["title=#{dex}"] = h2.at('.post-title').text.strip      
    #     sec_page_post["time=#{dex}"] = h2.at('.post-time').text.strip
    #     sec_page_post["content=#{dex}"] = h2.at('.post-content').text.strip
    #     sec_page_post["image=#{dex}"] = h2.at('.alignleft').attributes["src"].value      
    #   end
    # end    

    #@sec_page_post = sec_page_post    
    #@one_page_post = one_page_post.merge(sec_page_post)

    render :layout => false
  end
end
