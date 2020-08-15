class Api::V1::ShortUrlsController < ApplicationController
  before_action :set_short_url, only: %i[destroy show]

  def index
    render json: ShortUrl.active
  end

  def show
    render json: @short_url
  end

  def create
    short_url = ShortUrl.new(short_url_params)

    if short_url.save
      render json: short_url, status: :created
    else
      render json: { errors: short_url.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @short_url.expire!
    head 204
  end

  private

    def set_short_url
      @short_url = ShortUrl.find(params[:id])
    end

    def short_url_params
      params.require(:short_url).permit(:slug, :original_url, :expire_at)
    end
end
