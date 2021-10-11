class Movie < ActiveRecord::Base
 
  def self.all_ratings
    return ['G','PG','PG-13','R']
  end
  
  def self.with_ratings(ratings_list, sort_type)
  # if ratings_list is an array such as ['G', 'PG', 'R'], retrieve all
  #  movies with those ratings
  # if ratings_list is nil, retrieve ALL movies
    
    
    
    if (ratings_list.length == 0)
      return Movie.order(sort_type).all
    else
      list = Movie.where(
        "rating in (:ratings_list)",
        {ratings_list: ratings_list}
      ).order(sort_type).all
      
      return list
    end
    
    return Movie.all
    
  end
  
  
end
