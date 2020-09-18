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
    if current_org.subdomain == 'exams' && (current_student&.batches&.ids & [1, 4, 10, 16, 17]).present?
      banners_data = [
        {
          "img_url"=>"https://smart-exams-production.s3.ap-south-1.amazonaws.com/apks/rcc/neet_rcc_form.png",
          "on_click"=>"https://docs.google.com/forms/d/e/1FAIpQLSdzFoYGm4elzKrXIWr3Og19a69sacsoZDDikMkfCcrxIdblAg/viewform"
        }
      ]
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
