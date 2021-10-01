class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
      if params[:ratings]
        session[:ratings] = params[:ratings]
      end

      if params[:sort]
        session[:sort] = params[:sort]
      end
      
      if params[:direction]
        session[:direction] = params[:direction]
      end
      
      if !session.has_key?(:ratings)
        session[:ratings] = @all_ratings.each_with_object({}) {|rating, h| h[rating] = '1'}
      end
      
      params[:ratings] = session[:ratings]
      params[:direction] = session[:direction]
      params[:sort] = session[:sort]

      # flash.keep
      # redirect_to movies_path(:ratings => params[:ratings], :sort => params[:sort]) and return
      
      @movies = Movie.all
      # load the @all_ratings from the movie class every time
      @all_ratings = Movie.all_ratings
      
      def sort_column
        Movie.column_names.include?(params[:sort]) ? params[:sort] : "title"
      end
      
      def sort_direction
        %w[ASC DESC].include?(params[:direction]) ? params[:direction] : "ASC"
      end
      
      if session[:ratings]
        @fliter_keys = session[:ratings].keys
        @movies = Movie.with_ratings(@fliter_keys)
        # strange not work?
        # @movies = @movies.select { |movie| @filted_rating.include?movie.rating}
      end

      # I am not fully understand the parameters of the order method 
      @movies = @movies.order(sort_column + ' ' + sort_direction)
      
      if sort_column == "title"
        @sort_title = "p-3 mb-2 bg-warning text-dark hlite"
      elsif sort_column == "release_date"
        @sort_release_date = 'p-3 mb-2 bg-warning text-dark hilite'
      end
    end
  
    def new
      # default: render 'new' template
    end
  
    def create
      @movie = Movie.create!(movie_params)
      flash[:notice] = "#{@movie.title} was successfully created."
      redirect_to movies_path
    end
  
    def edit
      @movie = Movie.find params[:id]
    end
  
    def update
      @movie = Movie.find params[:id]
      @movie.update_attributes!(movie_params)
      flash[:notice] = "#{@movie.title} was successfully updated."
      redirect_to movie_path(@movie)
    end
  
    def destroy
      @movie = Movie.find(params[:id])
      @movie.destroy
      flash[:notice] = "Movie '#{@movie.title}' deleted."
      redirect_to movies_path
    end
  
    private
    # Making "internal" methods private is not required, but is a common practice.
    # This helps make clear which methods respond to requests, and which ones do not.
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end
  end