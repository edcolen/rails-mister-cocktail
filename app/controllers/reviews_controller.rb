class ReviewsController < ApplicationController
  def new
    @cocktail = Cocktail.find(params[:cocktail_id])
    @review = Review.new
  end

  def create
    @cocktail = Cocktail.find(params[:cocktail_id])
    @review = Review.new(review_params)
    @review.cocktail = @cocktail
    if @review.save
      redirect_to @review.cocktail
    else
      render :new
    end
  end

  private

  def review_params
    params.require(:review).permit(:content, :rating, :cocktail_id)
  end
end
