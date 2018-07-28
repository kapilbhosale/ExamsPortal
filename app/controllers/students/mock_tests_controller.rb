class Students::MockTestsController < Students::BaseController
  before_action :authenticate_student!

  def index
    @tests = [
      {

      },
      {

      }
    ]
  end
end
