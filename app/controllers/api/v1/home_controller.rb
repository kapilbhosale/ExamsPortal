# frozen_string_literal: true

class Api::V1::HomeController < Api::V1::ApiController
  skip_before_action :authenticate

  def dashboard_data
    exam_portal_link = "#{helpers.full_domain_path}/students/auto-auth"
    exam_portal_link += "?r=#{current_student&.roll_number}&m=#{current_student.parent_mobile}"

    json_data = {
      'top_banners_data' => top_banners_data,
      'bottom_list_data' => [],
      'about_us_link' => 'https://www.konaleclasses.com/',
      'tests_appeared_data' => {
        appeared: 12,
        total: 25,
      },
      'exam_portal_link' => exam_portal_link
    }
    render json: json_data, status: :ok
  end

  def top_banners_data
    [
      {
        img_url: 'https://smart-exams-production.s3.ap-south-1.amazonaws.com/apks/konale-banner-app.jpg',
        on_click: nil
      },
      {
        img_url: 'https://www.konaleclasses.com/wp-content/uploads/2019/06/topper20191d.jpg',
        on_click: 'https://www.konaleclasses.com/'
      },
      {
        img_url: 'https://www.konaleclasses.com/wp-content/uploads/2019/06/adharsh3sml1d.jpg',
        on_click: 'https://www.konaleclasses.com/'
      }
    ]
  end

  def gallery
    json_data = [
      {
        img_url: 'https://www.konaleclasses.com/wp-content/uploads/2019/06/SANKETBANNERsml1a.jpg',
      },
      {
        img_url: 'https://www.konaleclasses.com/wp-content/uploads/2019/06/topper20191d.jpg',
      },
      {
        img_url: 'https://www.konaleclasses.com/wp-content/uploads/2019/12/Banner1-2020-1.jpg',
      },
      {
        img_url: 'https://www.konaleclasses.com/wp-content/uploads/2019/02/neet2018Banner1-1.jpg'
      }
    ]
    render json: json_data, status: :ok
  end

  def app_version
    render json: { version_code: "1.0.0", force_update: true }, status: :ok
  end
end
