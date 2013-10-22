class VersionsController < ApplicationController
  before_filter :load_site
  before_filter :load_api_method

  # include truncate message
  include ActionView::Helpers::TextHelper

  def show
    @versions = @api_method.script_versions.map do |v| 
      message = truncate(v.message, :separator => " ")
      message.sub!(/^([^\r\n]+)\r?\n.*/m, '\1...')
      ["#{v.version}: #{message}", v.version]
    end


    if params[:id] == "latest"
      @version = @api_method.script_versions.first
    else
      @version = @api_method.script_versions.find_by_version(params[:id])
    end

    if params[:compare_id]
      @compare_version = @api_method.script_versions.find_by_version(params[:compare_id])
      @diff = @compare_version.compare_with(@version).format_as(:html)
    end

    @compare_versions = @versions.select { |_, version| version != @version.version }
    @compare_versions.unshift(["--none--", nil])

    render :layout => "ide"
  end

  def restore
    @version = @api_method.script_versions.find_by_version(params[:id])
    @version.restore!(:user => current_user)
    redirect_to [@site, @api_method]
  end

  protected

  def load_site
    @site = Site.find(params[:site_id])
  end

  def load_api_method
    @api_method = @site.api_methods.find(params[:api_method_id])
  end
end
