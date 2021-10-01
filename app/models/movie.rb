class Movie < ActiveRecord::Base
    def self.all_ratings
        self.all.map(&:rating).uniq
    end
end