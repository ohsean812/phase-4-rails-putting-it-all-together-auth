class RecipesController < ApplicationController

rescue_from ActiveRecord::RecordNotFound, with: :render_unauthorized_response

before_action :authorize, only: :create

    def index
    # if the user is logged in (if their user_id is in the session hash)...
        if user = User.find_by(id: session[:user_id])
    # Return a JSON response with an array of all recipes with their title, instructions, and minutes to complete data along with a nested user object; and an HTTP status code of 201 (Created)
            recipes = Recipe.all
            render json: recipes, status: :created
    # if the user is not logged in when they make the request...
        else
    # return a JSON response with an error message, and a status of 401 (Unauthorized)
            render json: { errors: ["Login to see the contents"] }, status: :unauthorized
        end
    end

    def create
    # if the user is logged in (if their user_id is in the session hash)...
        user = User.find_by(id: session[:user_id])
    # save a new recipe to the database if it is valid. The recipe ***belongs to the user***.
        recipe = user.recipes.create!(recipe_params)
    # return a JSON response with recipe params along with a nested user object; and an HTTP status code of 201 (Created)
        render json: recipe, status: :created
    # if the user is not logged in when they make the request, return a JSON response with an error message, and a status of 401 (Unauthorized)
        # refer to the authorize private method
    # if the recipe is not valid, return a JSON response with the error messages, and an HTTP status code of 422 (Unprocessable Entity)
        # refer to the [render_unprocessable_entity_response] private method stored in the application controller
    end

    private

    def authorize
        return render json: { errors: ["Not authorized"] }, status: :unauthorized unless session.include? :user_id
    end

    def recipe_params
        params.permit(:title, :instructions, :minutes_to_complete)
    end

    def render_unauthorized_response
        render json: { errors: ["Login to see the contents"] }, status: :unauthorized
    end

end
