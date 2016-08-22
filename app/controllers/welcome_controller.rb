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

  def govt_jobs
    begin
    Request.create(:params_txt => params.inspect, :utm_ip => request.remote_ip)  

    permalink = params['permalink']
    @permalink = params['permalink']
    require 'mechanize'

    agent = Mechanize.new
    agent.user_agent_alias = 'Windows Mozilla'
    page = agent.get("http://www.sarkarinaukrisarch.in/govt-jobs/#{params['permalink']}")    

    one_page_post = Hash.new

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

    render :layout => false

    rescue => error
      logger.warn "Internal server error: #{error}"
      redirect_to controller: 'welcome', action: 'mechanize', msg: 'error'
    end
  end

  def qualification
    begin
    Request.create(:params_txt => params.inspect, :utm_ip => request.remote_ip)  

    permalink = params['permalink']
    @permalink = params['permalink']
    require 'mechanize'

    agent = Mechanize.new
    agent.user_agent_alias = 'Windows Mozilla'
    page = agent.get("http://www.sarkarinaukrisarch.in/qualification/#{params['permalink']}")    

    one_page_post = Hash.new

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

    render :layout => false

    rescue => error
      logger.warn "Internal server error: #{error}"
      redirect_to controller: 'welcome', action: 'mechanize', msg: 'error'
    end
  end

  def permalink
    begin
    Request.create(:params_txt => params.inspect, :utm_ip => request.remote_ip)

    permalink = params['permalink']
    @job_post = JobPost.find_by_permalink(permalink)
    if @job_post

      @one_page_post  = Hash.new
      @one_page_post["title"] = @job_post.title
      @one_page_post["content"] = @job_post.title
      @content = @job_post.content

      @total_link = Array.new
      @job_post.post_links.each_with_index do |link,i|
        @total_link[i] = link.link_text
      end
      #@job_post.view_count =+1
      @job_post.update(view_count: @job_post.view_count+1) 

    else

    require 'mechanize'
    require 'nokogiri'
    require 'open-uri'

    agent = Mechanize.new
    agent.user_agent_alias = 'Windows Mozilla'
    page = agent.get("http://www.sarkarinaukrisarch.in/#{params['permalink']}/")
    #page_nok = Nokogiri::HTML(open("http://www.sarkarinaukrisarch.in/#{params['permalink']}/"))     

    one_page_post = Hash.new
    
    
    one_page_post["title"] = page.at('.post-title').text.strip
    one_page_post["content"] = one_page_post["title"]
    @content = page.css('div .post-content p').text.to_s
    @job_post = JobPost.create(:permalink => permalink, :title => one_page_post["title"], :content => @content, :view_count => 1)
    #one_page_post["link1"] = page.css('div .post-content li a')[2].text
    #one_page_post["link2"] = page.css('div .post-content li a')[3].text
    
    total_size_link = page.css('div .post-content li a').size

    @total_link = Array.new
    total_size_link.times do |i|
      str = page.css('div .post-content li a')[i].to_s
      if !str.include? '#'
        if !str.include? 'sarkarinaukrisarch'
          @total_link[i] = page.css('div .post-content li a')[i].text
          PostLink.create(:link_text => @total_link[i], :job_post_id => @job_post.id)
        end  
      end 
    end    

    @one_page_post = one_page_post
    end

    render :layout => false

    rescue => error
      logger.warn "Internal server error: #{error}"
      redirect_to controller: 'welcome', action: 'mechanize', msg: 'error'
    end
  end

  def statewisejob
    begin
    Request.create(:params_txt => params.inspect, :utm_ip => request.remote_ip)  

    permalink = params['permalink']
    @permalink = params['permalink']
    require 'mechanize'

    agent = Mechanize.new
    agent.user_agent_alias = 'Windows Mozilla'
    page = agent.get("http://www.sarkarinaukrisarch.in/states/#{params['permalink']}")    

    one_page_post = Hash.new

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

    render :layout => false

    rescue => error
      logger.warn "Internal server error: #{error}"
      redirect_to controller: 'welcome', action: 'mechanize', msg: 'error'
    end
  end

  def mechanize
    begin
    Request.create(:params_txt => params.inspect, :utm_ip => request.remote_ip)
    require 'mechanize'
    @msg = 'error' if params['msg']

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

    rescue => error
      logger.warn "Internal server error: #{error}"
      redirect_to controller: 'welcome', action: 'statewisejob', permalink: 'jobs-in-delhi'
    end
  end
end
