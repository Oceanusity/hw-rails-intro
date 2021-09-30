module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end
end

help_method :sort_colum, :sort_direction
def index
  @projects = Project.order(sort_column + ' ' + sort_direction)
end

private
def sort_column
  Project.column_names.include?(params[:sort]) ? params[:sort] : "client"
end

def sort_direction
  %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"
end
