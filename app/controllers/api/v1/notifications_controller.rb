# frozen_string_literal: true

class Api::V1::NotificationsController < Api::V1::ApiController

  def index
    json_data = [
      {
        title: 'Welcome to Online Exams and Video portals',
        description: 'We are pleased to announce that, today we welcome all students to this online portal. We welcome your suggestions to improve your experience',
        added_on: '27 April 2020'
      }
    ]
    render json: json_data, status: :ok
  end
end
