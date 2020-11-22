class CocktailsController < ApplicationController
  def index
    @cocktails = Cocktail.all
    @search = params['search']
    @cocktails = Cocktail.where('lower(name) like ?', "%#{@search['name'].downcase}%") if @search.present?
  end

  def show
    @cocktail = Cocktail.find(params[:id])
    @dose = Dose.new
    @review = Review.new
  end

  def new
    @cocktail = Cocktail.new
  end

  def create
    @cocktail = Cocktail.new(cocktail_params)
    if @cocktail.save
      redirect_to @cocktail
    else
      render :new
    end
  end

  def destroy
    @cocktail = Cocktail.find(params[:id])
    @cocktail.destroy
    redirect_to root_path
  end

  # def top
  #   @cocktails = Cocktail.all.map do |cocktail|
  #     { id: cocktail[:id], score: median_rating(cocktail[:id]) }
  #   end
  #   @cocktails.sort_by! { |cocktail| cocktail[:score] }
  #   @top_cocktails = @cocktails.reverse.first(10).map { |cocktail| Cocktail.find(cocktail[:id]) }
  # end

  private

  def cocktail_params
    params.require(:cocktail).permit(:name, :photo)
  end
end
