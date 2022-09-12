class SessionsController < ApplicationController

    before_action :authorize, only: :destroy

    def create
        # if the user's username and password are authenticated...
        user = User.find_by(username: params[:username])
        if user&.authenticate(params[:password])
        # save the user's ID in the session hash
            session[:user_id] = user.id
        # return a JSON response with the user's ID, username, image URL, and bio
            render json: user, status: :created
        # if the user's username and password are not authenticated...
        else
        # return a JSON response with an error message, and a status of 401 (Unauthorized)
            render json: { errors: ["Invalid username or password"] }, status: :unauthorized
        end
    end

    def destroy
        session.delete :user_id
        head :no_content
    end

    private

    def authorize
        return render json: { errors: ["Not authorized"] }, status: :unauthorized unless session.include? :user_id
    end

end
