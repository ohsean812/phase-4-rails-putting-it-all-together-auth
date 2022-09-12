class UsersController < ApplicationController

    before_action :authorize, only: [:show]

    def create
        # create & save a new user to the database with their username, encrypted(hashed) password, image URL, and bio
        user = User.create!(user_params)
        # save the user's ID in the session hash (if no rescue, use "if user.valid?")
            session[:user_id] = user.id
        # return the user object(with the user's ID, username, image URL, and bio) in the JSON response and an HTTP status code of 201 (Created)
            render json: user, status: :created
        # if the user is not valid, return a JSON response with the error message, and an HTTP status code of 422 (Unprocessable Entity)
            # refer to render_unprocessable_entity_response private method in application controller
    end

    def show
        # if the user is authenticated (i.e. if the user is logged in) (i.e. if their user_id is in the session hash)...
            user = User.find_by(id: session[:user_id])
        # return the user object(with the user's ID, username, image URL, and bio) in the JSON response and an HTTP status code of 201 (Created)
            render json: user, status: :created
        # If the user is not logged in when they make the request...
        # return a JSON response with an error message, and a status of 401 (Unauthorized)
            # refer to the authorize method in private and before_action on top
    end

    private

    def user_params
        params.permit(:username, :password, :password_confirmation, :image_url, :bio)
    end

    def authorize
        return render json: { error: "Not authorized" }, status: :unauthorized unless session.include? :user_id
    end

end
