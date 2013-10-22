require 'spec_helper'

describe ApiMethodsController do

  before(:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  describe "GET show" do
    describe "default script" do
      it "gets assigned if the script is blank" do
        script_config_file = File.join(Rails.root, "config", "default_script")
        default_script_file = File.read(script_config_file)

        api_method = FactoryGirl.create(:api_method)
        get :show, :site_id => api_method.site_id, :id => api_method.id
        assigns[:api_method].script.should == default_script_file
      end

      it "does not overwrite an existing script" do
        script = "Some script"

        api_method = FactoryGirl.create(:api_method, :script => script)
        get :show, :site_id => api_method.site_id, :id => api_method.id
        assigns[:api_method].script.should == script
      end
    end
  end

  describe "POST create" do
    it "creates api method" do
      site = FactoryGirl.create(:site)
      lambda do
        post :create, :site_id => site.id, :api_method => { :name => "test" }
        response.should be_redirect
      end.should change(ApiMethod, :count).by(1)
    end

    it "is not creating api method for invalid arguments" do
      site = FactoryGirl.create(:site)
      lambda do
        post :create, :site_id => site.id, :api_method => { :name => "spec test" }
        response.status.should == 200
      end.should change(ApiMethod, :count).by(0)
    end
  end

  describe "PUT update" do
    it "updates api method" do
      site = FactoryGirl.create(:site)
      api_method = FactoryGirl.create(:api_method, :site => site)
      api_method.name.should_not == "new_test"
      put :update, :site_id => site.id, :id => api_method.id, :api_method => { :name => "new_test" }
      api_method.reload
      api_method.name.should == "new_test"
      response.should be_redirect
    end

    it "is not updating api method for invalid arguments" do
      site = FactoryGirl.create(:site)
      api_method = FactoryGirl.create(:api_method, :site => site)
      put :update, :site_id => site.id, :id => api_method.id, :api_method => { :name => "new test" }
      response.status.should == 200
      old_attrs = api_method.attributes.clone
      old_attrs.delete("created_at")
      old_attrs.delete("updated_at")
      new_attrs = ApiMethod.find(api_method.id).attributes.clone
      new_attrs.delete("created_at")
      new_attrs.delete("updated_at")
      old_attrs.should == new_attrs
    end

    describe "with a new script" do
      before :each do
        @api_method = FactoryGirl.create(:api_method)
        @site = @api_method.site
        @new_script = "new script"
        @message = "comment to explain changes"
      end

      def do_put
        put(:update,
            :site_id => @site.id,
            :id => @api_method.id,
            :api_method => { :script => @new_script },
            :message => @message)
      end

      it "updates the api method" do
        do_put
        @api_method.reload.script.should == @new_script
      end

      it "creates a new version of the script" do
        lambda do
          do_put
        end.should change(ScriptVersion, :count).by(1)
      end

      it "stores the user who made the change" do
        do_put
        ScriptVersion.last.user.should == @user
      end

      it "stores the message against the version" do
        do_put
        ScriptVersion.last.message.should == @message
      end
    end
  end


  describe "GET new" do
    it "gets new" do
      site = FactoryGirl.create(:site)
      get :new, :site_id => site.id
      response.should be_successful
    end
  end

  describe "GET edit" do
    it "gets edit" do
      site = FactoryGirl.create(:site)
      api_method = FactoryGirl.create(:api_method, :site => site)
      get :edit, :site_id => site.id, :id => api_method.id
      response.should be_successful
    end
  end

  describe "GET call" do
    it "returns stats informations when successful" do
      script = "result true"
      api_method = FactoryGirl.create(:api_method, :script => script)
      params = {:site_id => api_method.site.id, :name => api_method.name, :look_for_me => true}

      get :call, params
      JSON::parse(response.body).keys.should include("stats")
    end


    it "calls ScriptRunner with the script and the params" do
      script = "result true"
      api_method = FactoryGirl.create(:api_method, :script => script)
      params = {:site_id => api_method.site.id, :name => api_method.name, :look_for_me => true}

      ScriptRunner.should_receive(:run).with(
        script, hash_including(:params => hash_including(:look_for_me))
      ).once.and_return({})

      get :call, params
    end

    it "doesn't pass controller, action or script params to the script" do
      script = "result params"
      api_method = FactoryGirl.create(:api_method, :script => script)
      params = {:site_id => api_method.site.id, :name => api_method.name, :script => script}

      get :call, params
      result = JSON.parse(response.body)["result"]
      result.should_not have_key("script")
      result.should_not have_key("controller")
      result.should_not have_key("action")
    end

    it "calls api method with remote session" do
      script = "result true"
      api_method = FactoryGirl.create(:api_method, :script => script)
      params = {:site_id => api_method.site.id, :name => api_method.name}
      remote_session = RemoteSession.new(1)
      RemoteSession.should_receive(:get).and_return(remote_session)
      ScriptRunner.should_receive(:run).with(script, hash_including(:remote_session => remote_session) )
      get :call, params
    end

    it "sets the remote_session id" do
      script = "result true"
      api_method = FactoryGirl.create(:api_method, :script => script)
      params = {:site_id => api_method.site.id, :name => api_method.name, :look_for_me => true}
      get :call, params

      session[:remote_session_id].should_not be_blank
    end

    it "sets the a different remote_session id for each session" do
      script = "result true"
      api_method = FactoryGirl.create(:api_method, :script => script)
      params = {:site_id => api_method.site.id, :name => api_method.name, :look_for_me => true}

      get :call, params
      session_1 = session[:remote_session_id]

      session.delete(:remote_session_id)

      get :call, params
      session_2 = session[:remote_session_id]

      session_1.should_not == session_2
    end

    describe "when the script has syntax errors" do
      before :each do
        script = "end"
        api_method = FactoryGirl.create(:api_method, :script => script)
        @params = {:site_id => api_method.site.id, :name => api_method.name}
      end

      it "sets the status code" do
        get :call, @params
        response.status.should == 422
      end

      it "returns the errors" do
        get :call, @params
        result = JSON.parse(response.body)
        # The exact error message depends on whether or not $SAFE=1 is enabled
        result["error"].should =~ /Syntax error on line 1: unexpected keyword_end(, expecting $end\n$SAFE=1;end\n           ^)?/
      end

      it "sets the line number" do
        get :call, @params
        result = JSON.parse(response.body)
        result["line"].should == 1
      end
    end


    describe "when the script thas no result" do
      before :each do
        script = "pointless = true"
        api_method = FactoryGirl.create(:api_method, :script => script)
        @params = {:site_id => api_method.site.id, :name => api_method.name}
      end

      it "returns a 200 success code" do
        get :call, @params
        response.should be_successful
      end

      it "returns the warning" do
        get :call, @params
        result = JSON.parse(response.body)
        result.should have_key("warning")
      end

      it "does not set the result" do
        get :call, @params
        result = JSON.parse(response.body)
        result.should_not have_key("result")
      end
    end
  end

  describe "DELETE destroy" do
    before :each do
      @api_method = FactoryGirl.create(:api_method)
    end

    it "deletes the api method" do
      lambda do
        delete :destroy, :site_id => @api_method.site.id, :id => @api_method.id
      end.should change(ApiMethod, :count).by(-1)

      ApiMethod.find_by_id(@api_method.id).should be_nil
    end

    it "redirects to the site page" do
      delete :destroy, :site_id => @api_method.site.id, :id => @api_method.id
      response.should redirect_to(@api_method.site)
    end
  end

  describe "archived site" do
    it "displayes error while trying to call archived site" do
      site = FactoryGirl.create(:site, :archived => true)
      api_method = FactoryGirl.create(:api_method, :site => site)
      get :call, :site_id => site.to_param, :id => api_method.name
      response.status.should == 422
      JSON::parse(response.body)["error"].should == "Site archived"
    end
  end


  describe "call" do

    it "can route GET requests to call" do
      { :get => "/sites/2-Kuba-s-Site-2/api/dfgdfgdfgdfgdfg" }.should be_routable
      { :get => "/sites/2-Kuba-s-Site-2/api/dfgdfgdfgdfgdfg" }.should route_to("controller" => "api_methods", "action" => "call",  "site_id"=>"2-Kuba-s-Site-2",
        "name"=>"dfgdfgdfgdfgdfg")
    end

    it "can route POST requests to call" do
      { :post => "/sites/2-Kuba-s-Site-2/api/dfgdfgdfgdfgdfg" }.should be_routable
      { :post => "/sites/2-Kuba-s-Site-2/api/dfgdfgdfgdfgdfg" }.should route_to("controller" => "api_methods", "action" => "call",  "site_id"=>"2-Kuba-s-Site-2",
        "name"=>"dfgdfgdfgdfgdfg")
    end
  end

end
