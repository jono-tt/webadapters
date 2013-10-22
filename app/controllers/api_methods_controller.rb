class ApiMethodsController < ApplicationController

  before_filter :load_site
  skip_before_filter :authenticate_user!, :only => [:call]

  def show
    @api_method = @site.api_methods.find(params[:id])
    @api_method.load_default_script_if_required
    render :layout => "ide"
  end

  def new
    @api_method = @site.api_methods.new
  end

  def create
    @api_method = @site.api_methods.new(params[:api_method])
    if @api_method.save
      flash[:notice] = "Yay! Api method created!"
      redirect_to [@site, @api_method]
    else
      flash[:error] = ":( Something went wrong try again later, maybe tomorrow!"
      render :new
    end
  end

  def edit
    @api_method = @site.api_methods.find(params[:id])
  end

  def update
    @api_method = @site.api_methods.find(params[:id])
    @api_method.clear_draft

    @api_method.attributes = params[:api_method]
    if @api_method.script_changed? && @api_method.save_version(:user => current_user, :message => params[:message])
      flash[:notice] = "Yay! Script saved!"
      redirect_to [@site, @api_method]
    elsif @api_method.save
      flash[:notice] = "Yay! Api method updated!"
      redirect_to [@site, @api_method]
    else
      flash[:error] = ":( Something went wrong try again later, maybe tomorrow!"
      render :edit
    end
  end

  def call
    if @site.archived?
      render :json => { :error => "Site archived" }, :status => 422 and return
    end
    remote_session = RemoteSession.get(session[:remote_session_id])
    session[:remote_session_id] = remote_session.id

    @api_method = @site.api_methods.find_by_name(params[:name])
    if params[:script]
      script = params[:script]
      @api_method.save_draft( script )
      @api_method.script = script
    end

    params_to_delete = [:controller, :action, :script]
    safe_params = params.dup.delete_if { |p| params_to_delete.include?(p.to_sym) }
    
    script = @api_method.run_script(safe_params, remote_session)
    if script.successful?
      if script.result.nil? && script.warning
        render :json => { :warning => script.warning }
      else
        Stats.new(@api_method.id).store(script.stats[:total])
        render :json => { :result => script.result, :debug => script.debug, :stats => script.stats }
      end
    else
      render :json => { :error => script.error, :line => script.line }, :status => 422
    end
  end

  def destroy
    @api_method = @site.api_methods.find(params[:id])
    @api_method.destroy
    redirect_to @site
  end

  protected

  def load_site
    @site = Site.find(params[:site_id])
  end

end
