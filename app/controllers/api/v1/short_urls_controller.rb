class Api::V1::ShortUrlsController < ApplicationController
  before_action :set_short_url, only: %i[destroy show]
  before_action :check_owner, only: :destroy

  def index
    # should we render ALL active urls or check if the user is authenticated and show only his/hers??
    @short_urls = ShortUrl.active
    render json: ShortUrlSerializer.new(@short_urls).serializable_hash
  end

  def show
    render json: ShortUrlSerializer.new(@short_url).serializable_hash
  end

  def create
    short_url = ShortUrl.new(short_url_params.merge(user_id: current_user&.id))

    if short_url.save
      render json: ShortUrlSerializer.new(short_url).serializable_hash, status: :created
    else
      render json: { errors: short_url.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @short_url.expire!
    head :no_content
  end

  private

  def check_owner
    head :forbidden unless current_user.present? && current_user.id == @short_url.user_id
  end

    def set_short_url
      @short_url = ShortUrl.find(params[:id])
    end

    def short_url_params
      params.require(:short_url).permit(:slug, :original_url, :expire_at)
    end
end
