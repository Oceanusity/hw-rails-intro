class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  helper_method :sort_colum, :sort_direction
  def index
    @movies = Movies.order(sort_colum + " " + sort_direction)
  end
  
  def sort_colum
    Application.column_names.include? (params[:sort]) ? params[:sort] : "Movie Title"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
