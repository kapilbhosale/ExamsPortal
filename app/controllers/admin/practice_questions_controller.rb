class Admin::PracticeQuestionsController < Admin::BaseController

  def index
    @subjects = Subject.all
  end
end
