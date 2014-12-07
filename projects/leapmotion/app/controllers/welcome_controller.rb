class WelcomeController < ApplicationController
  def index
    javascript_include_tag('//js.leapmotion.com/leap-0.6.4.min.js', '//js.leapmotion.com/leap-plugins-0.1.10.js')
    
  end
  
  def cathead
    
  end
end