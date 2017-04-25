class FavoritesController < ApplicationController
  def create
    @user = current_user
    @show = Show.find(params[:show_id])
    @favorite = current_user.shows << @show
    flash[:notice] = "Your show has been added to favorites."
    redirect_to(:back)
  end

  def destroy
    favorite = Favorite.find(params[:id])
    @show = favorite.show
    Favorite.destroy(params[:id])
    flash[:notice] = "This show has been deleted from favorites."
    redirect_to(:back)
  end
end
