# frozen_string_literal: true

class Api::V1::MeetingsController < Api::V1::ApiController

  def index
    meetings_data = {
      upcoming: {
        zoom_meeting_id: 92049513891,
        password: '0XzS9a',
        datetime: '1595179508',
        date: '19-july-2020',
        time: '11.30 PM',
        subject: 'Chemistry',
        teacher: 'Prof. Kapil bhosale'
      },
      all: [
        {
          zoom_meeting_id: 92049513891,
          password: '2yj8zL',
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
