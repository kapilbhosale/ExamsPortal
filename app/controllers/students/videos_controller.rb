class Students::VideosController < Students::BaseController
  before_action :authenticate_student!, except: [:index]
  layout 'videos'

  def index
  end

  def lectures
    @videos = [
      {
        id: 1,
        title: "Biomolecules1 - Carbohydrate Classification By Shivraj Motegaonkar Sir RCC",
        url: "https://vimeo.com/405985315",
        video_id: "405985315",
        description: "",
        subject: 'chemistry'
      },
      {
        id: 2,
        title: "Prepration of glucose Part_II",
        url: "https://vimeo.com/405976840",
        video_id: "405976840",
        description: "",
        subject: 'chemistry'
      }
    ]
  end

  def show_lecture
    @video_url = "https://player.vimeo.com/video/#{params[:video_id]}?autoplay=1&color=fdbc1d&byline=0&portrait=0"
  end

end
