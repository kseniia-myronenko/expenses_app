class HomePageController < AuthorizedController
  skip_before_action :check_user

  def index; end
end
