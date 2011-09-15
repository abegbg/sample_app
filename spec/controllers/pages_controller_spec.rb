require 'spec_helper'

describe PagesController do
  render_views

  before(:each) do
    @base_title = "Ruby on Rails Tutorial Sample App"
  end
  
  describe "GET 'home'" do
    
    describe "when not signed in" do

      before(:each) do
        get :home
      end

      it "should be successful" do
        response.should be_success
      end

      it "should have the right title" do
        response.should have_selector("title",
                                      :content => "#{@base_title} | Home")
      end
    end
    
    describe "when signed in" do

      before(:each) do
        @user = test_sign_in(Factory(:user, :email => Factory.next(:email)))
        other_user = Factory(:user, :email => Factory.next(:email))
        other_user.follow!(@user)
      end

      it "should have the right follower/following counts" do
        get :home
        response.should have_selector("a", :href => following_user_path(@user),
                                           :content => "0 following")
        response.should have_selector("a", :href => followers_user_path(@user),
                                           :content => "1 follower")
      end
    end
      
    before(:each) do 
      @user = test_sign_in(Factory(:user)) 
    end
  
    it "should have 1 micropost in the sidebar" do
      mp1 = Factory(:micropost, :user => @user, :content => "Foo bar")
      get 'home'
      regexp = /1 micropost$/
      response.should have_selector("span.microposts") do |content| 
        content.should contain(regexp)
      end
    end

    it "should have 2 microposts in the sidebar" do
      mp1 = Factory(:micropost, :user => @user, :content => "Foo bar")
      mp2 = Factory(:micropost, :user => @user, :content => "Foo bar2")
      get 'home'
      response.should have_selector("span.microposts", :content => "2 microposts")
    end
    
    it "should paginate microposts" do
      35.times do
        Factory(:micropost, :user => @user, :content => "Foo bar")
      end
      get 'home'
      response.should have_selector("div.pagination")
      response.should have_selector("span.disabled", :content => "Previous")
      response.should have_selector("a", :href => "/?page=2",
                                         :content => "2")
      response.should have_selector("a", :href => "/?page=2",
                                         :content => "Next")
    end
    
  end#GET home 

  describe "GET 'contact'" do
    it "should be successful" do
      get 'contact'
      response.should be_success
    end
    
    it "should have the right title" do
      get 'contact'
      response.should have_selector("title",
                        :content => @base_title + " | Contact")
    end
  end

  describe "GET 'about'" do
    it "should be successful" do
      get 'about'
      response.should be_success
    end
    
    it "should have the right title" do
      get 'about'
      response.should have_selector("title",
                        :content => @base_title + " | About")
    end
  end
  
  describe "GET 'help'" do
    it "should be successful" do
      get 'help'
      response.should be_success
    end
    
    it "should have the right title" do
      get 'help'
      response.should have_selector("title",
                        :content => @base_title + " | Help")
    end
  end
end
