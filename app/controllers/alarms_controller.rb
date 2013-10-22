class AlarmsController < ApplicationController
  before_filter :load_site
  before_filter :load_api_method
  
  def index
    @scope ||= Alarm
    @alarms = @scope.page(params[:page]).per(20)
  end

  def show
    @alarm = Alarm.find(params[:id])
    @site = @alarm.site
    @api_method = @alarm.api_method

    render :layout => "ide"
  end

  protected

  def load_site
    if params[:site_id]
      @site = Site.find(params[:site_id])
    end
  end

  def load_api_method
    if params[:api_method_id]
      @api_method = ApiMethod.find(params[:api_method_id])
      @scope = @api_method.alarms
    end
  end
end
