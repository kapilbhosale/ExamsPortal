class Students::VideosController < Students::BaseController
  before_action :authenticate_student!, except: [:index]
  layout 'videos'

  def index
  end

  def lectures
    @chem_videos = [
      {
        id: 1,
        title: "Biomolecules1 - Carbohydrate Classification",
        url: "https://vimeo.com/405985315",
        video_id: "405985315",
        description: "By Shivraj Motegaonkar Sir RCC",
        subject: 'chemistry',
        thumbnail: 'https://smart-exams-production.s3.ap-south-1.amazonaws.com/video-thumbnails/video-1.png'
      },
      {
        id: 2,
        title: "Prepration of glucose Part_II",
        url: "https://vimeo.com/405976840",
        video_id: "405976840",
        description: "",
        subject: 'chemistry',
        thumbnail: 'https://smart-exams-production.s3.ap-south-1.amazonaws.com/video-thumbnails/video-2.png'
      }
    ]
  end

  def show_lecture
    @video_url = "https://player.vimeo.com/video/#{params[:video_id]}?autoplay=1&color=fdbc1d&byline=0&portrait=0"
  end

end
