# frozen_string_literal: true

class Api::V1::MeetingsController < Api::V1::ApiController

  def index
    meetings_data = {
      zoom_app_key: '5oNVTIJJEMjDO4HiQuk0Ao476WcnHwTD43wB',
      zoom_app_secret: 'zi6R0FMfQVhNIjXFUFycm8u0MvGjJhBdeXge',
      zoom_domain: 'zoom.us',
      upcoming: {
        # zoom_meeting_id: '92695080428',
        # password: 'Y4pC4r',
        # datetime: '1595179508',
        # date: '19-july-2020',
        # time: '11.30 PM',
        # subject: 'Chemistry',
        # teacher: 'Prof. Kapil bhosale'
      },
      all: [
        {
          zoom_meeting_id: '92695080428',
          password: 'Y4pC4r',
          datetime: '1595179508',
          date: '19-july-2020',
          time: '11.30 PM',
          subject: 'Chemistry',
          teacher: 'Prof. Kapil bhosale'
        },
        {
          zoom_meeting_id: 91796113988,
          password: '2yj8zL',
          datetime: '1595186772',
          date: '19-july-2020',
          time: '12.30 PM',
          subject: 'Physics',
          teacher: 'Prof. Parth bhosale'
        }
      ]
    }
    render json: meetings_data
  end
end
