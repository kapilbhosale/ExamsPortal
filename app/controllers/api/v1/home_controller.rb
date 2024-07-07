# frozen_string_literal: true

class Api::V1::HomeController < Api::V1::ApiController
  skip_before_action :authenticate, only: [:gallery]

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
      'org_data' => current_org&.data&.dig('org_data'),
      'badges' => {
        new_videos: nil,
        new_exams: nil,
        new_pdfs: nil
      },
      'student_name' => current_student.name.split(' ').first,
      latest_videos: VideoLecture.latest_videos(current_student, helpers.full_domain_path, request.headers['buildNumber'].to_i),
      batches: current_student.batches.pluck(:name),
      build_number: current_org&.data&.dig('build_number') || 0
    }
    render json: json_data, status: :ok
  end

  def top_banners_data
    banners_data = []
    banners = Banner.includes(:org).where(active: true).where(org: current_org).includes(:batches, :batch_banners).where(batches: {id: current_student.batches&.ids}).all.order(id: :desc) || []

    banners.each do |banner|
      on_click_url = banner.on_click_url.gsub("STUDENT_ID", current_student.id.to_s)
      banners_data << {
        "img_url"=> banner.image.url,
        "on_click"=> on_click_url
      }
    end

    # if student have pending fees
    if current_student.pending_amount.present?
      banners_data << {
        "img_url"=> "https://smart-exams-production-v2.s3.amazonaws.com/uploads/exams/banner/image/122/REP.jpg",
        "on_click"=> "https://exams.smartclassapp.in/pay-due-fees?student_id=#{current_student.id}"
      }
    end

    return (banners_data + (current_org.data['top_banners'] || []))
  end

  def gallery
    render json: current_org.data['gallery'], status: :ok
  end

  def app_version
    version_code = current_org&.data&.dig('version_code') || '1.0.0'
    if params[:code]&.to_f < version_code.to_f
      current_student.reset_apps
    end
    render json: { version_code: version_code, force_update: true }, status: :ok
  end
end
