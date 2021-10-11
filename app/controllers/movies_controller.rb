class MoviesController < ApplicationController
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    @all_ratings = Movie.all_ratings
    @ratings_to_show = []
    @title_class = ""
    @release_class = ""
    @sort_type = ""
    
    
    if (params["ratings"])
      @ratings_to_show = params["ratings"].keys
    end
    
    if (params["id"] == "title_header")
      @title_class = "hilite"
      @release_class = ""
      @sort_type = "title"
    elsif params["id"] == "release_date_header" 
      @release_class = "hilite"
      @title_class = ""
      @sort_type = "release_date"
    end
    
    @movies = Movie.with_ratings(@ratings_to_show, @sort_type)
        
    
    #{"class"=>"text-primary hilite", "id"=>"title_header", "controller"=>"movies", "action"=>"index"}
    #"ratings"=>{"PG"=>"1", "PG-13"=>"1"}, "commit"=>"Refresh", "controller"=>"movies", "action"=>"index"
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
