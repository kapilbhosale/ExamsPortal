# frozen_string_literal: true

class Api::V1::HomeController < Api::V1::ApiController
  skip_before_action :authenticate

  def dashboard_data
    exam_portal_link = "#{helpers.full_domain_path}/students/auto-auth"
    exam_portal_link += "?r=#{current_student&.roll_number}&m=#{current_student.parent_mobile}"

    json_data = {
      'top_banners_data' => top_banners_data,
      'bottom_list_data' => [],
      'about_us_link' => 'https://drdhotesacademy.com/',
      'tests_appeared_data' => {
        appeared: 0,
        total: 0,
      },
      'exam_portal_link' => exam_portal_link
    }
    render json: json_data, status: :ok
  end

  def top_banners_data
    [
      {
        img_url: 'https://smart-exams-production.s3.ap-south-1.amazonaws.com/apks/dhote-banner-app.jpg',
        on_click: nil
      },
      {
        img_url: 'https://drdhotesacademy.com/wp-content/uploads/2020/01/newbanner-02.jpg',
        on_click: 'https://drdhotesacademy.com/'
      },
      {
        img_url: 'https://drdhotesacademy.com/wp-content/uploads/2019/02/banner-1.jpg',
        on_click: 'https://drdhotesacademy.com/'
      }
    ]
  end

  def gallery
    json_data = [
      {
        img_url: 'https://drdhotesacademy.com/wp-content/uploads/2020/03/progra-20.jpg',
      },
      {
        img_url: 'https://drdhotesacademy.com/wp-content/uploads/2020/03/progra-01.jpg',
      },
      {
        img_url: 'https://drdhotesacademy.com/wp-content/uploads/2020/03/progra-02.jpg',
      },
      {
        img_url: 'https://drdhotesacademy.com/wp-content/uploads/2020/03/progra-03.jpg',
      },
      {
        img_url: 'https://drdhotesacademy.com/wp-content/uploads/2020/03/progra-04.jpg',
      },
      {
        img_url: 'https://drdhotesacademy.com/wp-content/uploads/2020/03/progra-05.jpg',
      },
      {
        img_url: 'https://drdhotesacademy.com/wp-content/uploads/2020/03/progra-06.jpg',
      },
      {
        img_url: 'https://drdhotesacademy.com/wp-content/uploads/2020/03/progra-08.jpg',
      },
      {
        img_url: 'https://drdhotesacademy.com/wp-content/uploads/2020/03/progra-09.jpg',
      },
      {
        img_url: 'https://drdhotesacademy.com/wp-content/uploads/2020/03/progra-10.jpg',
      },
      {
        img_url: 'https://drdhotesacademy.com/wp-content/uploads/2020/03/progra-11.jpg',
      },
      {
        img_url: 'https://drdhotesacademy.com/wp-content/uploads/2020/03/progra-12.jpg',
      },
      {
        img_url: 'https://drdhotesacademy.com/wp-content/uploads/2020/03/progra-13.jpg',
      },
      {
        img_url: 'https://drdhotesacademy.com/wp-content/uploads/2020/03/progra-14.jpg',
      },
      {
        img_url: 'https://drdhotesacademy.com/wp-content/uploads/2020/03/progra-16.jpg',
      },
      {
        img_url: 'https://drdhotesacademy.com/wp-content/uploads/2020/03/progra-17.jpg',
      },
      {
        img_url: 'https://drdhotesacademy.com/wp-content/uploads/2020/03/progra-18.jpg',
      },
      {
        img_url: 'https://drdhotesacademy.com/wp-content/uploads/2020/03/progra-21.jpg',
      },
      {
        img_url: 'https://drdhotesacademy.com/wp-content/uploads/2020/03/progra-21.jpg',
      },
      {
        img_url: 'https://drdhotesacademy.com/wp-content/uploads/2020/03/progra-23.jpg',
      },
      {
        img_url: 'https://drdhotesacademy.com/wp-content/uploads/2019/02/gal5.jpg',
      },
      {
        img_url: 'https://drdhotesacademy.com/wp-content/uploads/2019/02/gal2.jpg',
      },
      {
        img_url: 'https://drdhotesacademy.com/wp-content/uploads/2019/02/gal6.jpg',
      },
      {
        img_url: 'https://drdhotesacademy.com/wp-content/uploads/2019/02/gal1.jpg',
      },
      {
        img_url: 'https://drdhotesacademy.com/wp-content/uploads/2019/02/gal4.jpg',
      }
    ]
    render json: json_data, status: :ok
  end

  def app_version
    render json: { version_code: "1.0.0", force_update: true }, status: :ok
  end
end
