# frozen_string_literal: true

class Api::V1::HomeController < Api::V1::ApiController
  skip_before_action :authenticate, only: [:gallery, :app_version]

  def dashboard_data
    exam_portal_link = "#{helpers.full_domain_path}/students/auto-auth"
    exam_portal_link += "?r=#{current_student&.roll_number}&m=#{current_student&.parent_mobile}"

    json_data = {
      'top_banners_data' => top_banners_data,
      'bottom_list_data' => [],
      'about_us_link' => current_org.about_us_link || '#',
      'tests_appeared_data' => {
        appeared: 0,
        total: 0,
      },
      'exam_portal_link' => exam_portal_link,
      'org_data' => current_org&.data&.dig('org_data')
    }
    render json: json_data, status: :ok
  end

  def top_banners_data
    banners_data = []
    if current_org.subdomain == 'exams'
      if current_student.pending_amount.present?
        banners_data <<
          {
            "img_url"=>"https://smart-exams-production.s3.ap-south-1.amazonaws.com/apks/rcc/rcc_fees_reminder.jpg",
            "on_click"=>"https://exams.smartclassapp.in/pay_due_fees?student_id=#{current_student.id}"
          }
      end
      if (current_student&.batches&.ids & [90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133]).present?
        banners_data <<
          {
            "img_url"=>"https://smart-exams-production.s3.ap-south-1.amazonaws.com/apks/rcc/study_form.png",
            "on_click"=>"https://docs.google.com/forms/d/e/1FAIpQLSeRV6coW9uEUEcFJInGCtqHhlNTmMrz6Qe8CpKeVl2krNRYxg/viewform"
          }
      end
      banners_data + current_org.data['top_banners']
    else
      current_org.data['top_banners']
    end
  end

  def gallery
    render json: current_org.data['gallery'], status: :ok
  end

  def app_version
    version_code = current_org&.data&.dig('version_code') || '1.0.0'
    render json: { version_code: version_code, force_update: true }, status: :ok
  end
end
