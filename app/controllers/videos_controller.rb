class VideosController < ApplicationController
  before_action :require_user

  def index
    @categories = Category.all
  end

  def show
    @video = Video.find(params[:id]).decorate
    @reviews = @video.reviews
  end

  def search
    @videos = Video.search_by_title(params[:search_title])
  end
end