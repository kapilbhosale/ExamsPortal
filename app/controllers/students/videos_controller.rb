
class Students::VideosController < Students::BaseController
  before_action :authenticate_student!, except: [:index]
  layout false, only: [:show_lecture]

  def index
  end

  def lectures
    lectures = VideoLecture.includes(:batches)
      .where(batches: {id: current_student.batches})
      .where(enabled: true)
      .order(id: :desc)

    lectures_data = {}
    lectures.each do |lect|
      lectures_data[lect.subject] ||= []
      lectures_data[lect.subject] << lect
    end
    @chem_videos = lectures_data['chem']
    @phy_videos = lectures_data['phy']
    @bio_videos = lectures_data['bio']
    @maths_videos = lectures_data['maths']
  end

  def show_lecture
    @video_url = "https://player.vimeo.com/video/#{params[:video_id]}?autoplay=1&color=fdbc1d&byline=0&portrait=0"
  end
end
