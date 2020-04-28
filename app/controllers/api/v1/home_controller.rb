# frozen_string_literal: true

class Api::V1::HomeController < Api::V1::ApiController
  skip_before_action :authenticate

  def dashboard_data
    exam_portal_link = "#{helpers.full_domain_path}/students/auto-auth"
    exam_portal_link += "?r=#{current_student&.roll_number}&m=#{current_student.parent_mobile}"

    json_data = {
      'top_banners_data' => top_banners_data,
      'bottom_list_data' => [],
      'about_us_link' => 'https://saraswaticoachingclasses.in/',
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
        img_url: 'https://smart-exams-production.s3.ap-south-1.amazonaws.com/apks/saraswati-banner-2.jpg',
        on_click: 'https://saraswaticoachingclasses.in/'
      },
      {
        img_url: 'https://smart-exams-production.s3.ap-south-1.amazonaws.com/apks/sarawati-banner.jpg',
        on_click: nil
      },
    ]
  end

  def gallery
    json_data = [
      {
        img_url: 'https://smart-exams-production.s3.ap-south-1.amazonaws.com/apks/saraswati-banner-2.jpg',
      },
      {
        img_url: 'http://saraswaticoachingclasses.in/wp-content/uploads/2019/06/Screenshot-2019-06-10-at-8.55.43-AM.png',
      },
      {
        img_url: 'http://saraswaticoachingclasses.in/wp-content/uploads/2019/06/Screenshot-2019-06-09-at-9.06.51-AM.png',
      },
      {
        img_url: 'http://saraswaticoachingclasses.in/wp-content/uploads/2018/06/gauri-thakre-akola.png'
      }
    ]
    render json: json_data, status: :ok
  end

  def app_version
    render json: { version_code: "1.0.0", force_update: true }, status: :ok
  end
end
