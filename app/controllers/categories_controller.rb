class CategoriesController < ApplicationController
    def index
        @categories = Category.all()
    end

    def new
    end

    def create
        @category = Category.new(params[:category])
        result = @category.save()
        redirect_to categories_url
    end

    def destroy
        @category = Category.find(params[:id])
        @category.destroy()
        puts "Got here"

        redirect_to categories_path
    end
end
