class CategoriesController < ApplicationController
    def index
        @categories = Category.all()
    end

    def create
        @category = Category.new(params[:category])
        result = @category.save()
        redirect_to categories_path
    end

    def destroy
        @category = Category.find(params[:id])
        @category.destroy()

        redirect_to categories_path
    end
end
