class CategoryPreferencesController < ApplicationController

  def index
    if current_user.is_admin?
      @category_preferences = CategoryPreference.all
    else
      curr = current_user.id
      @category_preferences = CategoryPreference.where(user_id: curr)
    end
  end

  def new
    @category_preference = CategoryPreference.new
  end

  def create
    cat_pref = params[:category_preference]
    category_names = params[:category_preference].delete(:categories)
    categories = []
    category_names.each do |cat_name|
      c = Category.find_by_name(cat_name)
      categories << c
    end
    params[:category_preference][:categories] = categories
    params[:category_preference][:user_id] = current_user.id
    @category_preference = CategoryPreference.new(cat_pref)

    save_success = @category_preference.save
    
    if not save_success or @category_preference.errors.any?
      flash[:error] =  @category_preference.errors
    end
    
    redirect_to category_preferences_path
  end

  def show
    @category_preference = CategoryPreference.find_by_id(params[:id])
  end

  def edit
    @category_preference = CategoryPreference.find_by_id(params[:id])
  end

  def update
    @category_preference = CategoryPreference.find_by_id(params[:id])

    category_names = params[:category_preference].delete(:categories)
    categories = []
    category_names.each do |cat_name|
      c = Category.find_by_name(cat_name)
      categories << c
    end
    params[:category_preference][:categories] = categories
    params[:category_preference][:user_id] = current_user.id

    @category_preference.update_attributes(params[:category_preference])
    flash[:notice] = "Successfully updated #{@category_preference.name}"
    redirect_to category_preferences_path
  end

  def destroy
    @category_preference = CategoryPreference.find_by_id(params[:id])
    @category_preference.destroy
    redirect_to category_preferences_path
  end
end
