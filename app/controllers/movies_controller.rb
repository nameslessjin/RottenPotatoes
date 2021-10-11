class MoviesController < ApplicationController
  

  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

    if (params["commit"] == "Refresh")
      session.delete(:sort_type)
      session.delete(:ratings_to_show)
    end
   
      
    @all_ratings = Movie.all_ratings
    @ratings_to_show = session[:ratings_to_show] || @all_ratings
    @title_class = ""
    @release_class = ""
    @sort_type = session[:sort_type] || ""

    # redirect
    if (!params["id"] && !params["ratings"])
      header = ""
      if (@sort_type == "title")
         header = "title_header"
      elsif (@sort_type == "release_date")
         header = "release_date_header"
      end
      redirect_to movies_path(:id => header, :ratings => Hash[@ratings_to_show.map {|x| [x, 1]}])
    end
    
    # ratings assignment
    if (params["ratings"])
      @ratings_to_show = params["ratings"].keys
      session[:ratings_to_show] = @ratings_to_show
    end
    
    # sorting assignment
    if (params["id"] == "title_header")
      @sort_type = "title"
      session[:sort_type] = @sort_type
    elsif (params["id"] == "release_date_header")
      @sort_type = "release_date"
      session[:sort_type] = @sort_type
    end
    
    if (@sort_type == "title")
      @title_class = "hilite"
      @release_class = ""
    elsif (@sort_type == "release_date")
      @release_class = "hilite"
      @title_class = ""
    end
    
    @movies = Movie.with_ratings(@ratings_to_show, @sort_type)  
    
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
