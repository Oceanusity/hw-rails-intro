class Movie < ActiveRecord::Base
    def self.all_ratings
        self.all.map(&:rating).uniq
    end
    
    def self.with_ratings(ratings)
       return self.all.where('rating in (?)', ratings)
    end
end