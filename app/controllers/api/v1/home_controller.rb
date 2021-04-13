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
    return current_org.data['top_banners'] unless current_org.subdomain == 'exams'

    if current_student.pending_amount.present?
      banners_data <<
        {
          "img_url"=>"https://smart-exams-production.s3.ap-south-1.amazonaws.com/apks/rcc/rcc_fees_reminder.jpg",
          "on_click"=>"https://exams.smartclassapp.in/pay_due_fees?student_id=#{current_student.id}"
        }
    end

    if (current_student.batches&.ids & [192, 196, 197, 198]).present?
      banners_data << {
        "img_url"=>"https://smart-exams-production.s3.ap-south-1.amazonaws.com/apks/rcc/rcc_foundation.png",
        "on_click"=>"https://rccpattern.com"
      }
    else
      banners_data <<
        {
          "img_url"=>"https://smart-exams-production.s3.ap-south-1.amazonaws.com/apks/rcc/rcc-banner-29-march.jpg",
          "on_click"=>"https://exams.smartclassapp.in/new-admission"
        }
      banners_data + current_org.data['top_banners']
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
