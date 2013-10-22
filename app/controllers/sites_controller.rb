
class SitesController < ApplicationController

  def index
    @sites = Site.unarchived.page(params[:page]).per(20)
  end

  def show
    @site = Site.find(params[:id])
  end

  def new
    @site = Site.new
  end

  def create
    @site = Site.new(params[:site])
    if @site.save
      flash[:notice] = "New Site created, Yay!"
      redirect_to sites_url
    else
      flash[:error] = "There was a problem creating site"
      render :new
    end
  end

  def edit
    @site = Site.find(params[:id])
  end

  def update
    @site = Site.find(params[:id])
    if @site.update_attributes(params[:site])
      flash[:notice] = "Site updated, Yay!"
      redirect_to sites_url
    else
      flash[:error] = "There was a problem while updating site"
      render :edit
    end
  end

  def destroy
    @site = Site.find(params[:id])
    @site.try(:destroy)
    redirect_to sites_url
  end

  def archived
    @sites = Site.archived.page(params[:page]).per(20)
  end

  def archive
    site = Site.find(params[:id])
    site.archive
    redirect_to archived_sites_path
  end

  def unarchive
    site = Site.find(params[:id])
    site.unarchive
    redirect_to sites_path
  end

end

