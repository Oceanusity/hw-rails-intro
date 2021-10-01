class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
      @movies = Movie.all
      # load the @all_ratings from the movie class every time
      @all_ratings = @movies.map(&:rating).uniq
      
      def sort_column
        Movie.column_names.include?(params[:sort]) ? params[:sort] : "title"
      end
      
      def sort_direction
        %w[ASC DESC].include?(params[:direction]) ? params[:direction] : "ASC"
      end
      
      if params[:ratings]
        @fliter_keys = params[:ratings].keys
        @movies = @movies.where('rating in (?)', @fliter_keys)
        # strange not work?
        # @movies = @movies.select { |movie| movie.rating in @filted_rating }
      end

      # I am not fully understand the parameters of the order method 
      @movies = @movies.order(sort_column + ' ' + sort_direction)  
      
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