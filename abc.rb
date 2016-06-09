require 'rubygems'
require 'nokogiri'
#require 'restclient'
require 'open-uri'

#page = Nokogiri::HTML(RestClient.get("http://www.sarkarinaukrisarch.in/ujvnl-recruitment/"))   
page = Nokogiri::HTML(open("http://www.sarkarinaukrisarch.in/ujvnl-recruitment/")) 
#puts page.class   # => Nokogiri::HTML::Document
#puts page.css('h2').text
puts page.css('div .post-content li a')[2].text
puts page.css('div .post-content li a')[3].text
#puts page.css("li[target='_blank']")
#target="_blank"
#puts page.css('p').text
# page.css('a').each do |txt|
# 	if txt
# end

