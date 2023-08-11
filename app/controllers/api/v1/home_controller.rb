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
      latest_videos: VideoLecture.latest_videos(current_student, helpers.full_domain_path),
      batches: current_student.batches.pluck(:name),
      build_number: 86
    }
    render json: json_data, status: :ok
  end

  def top_banners_data
    banners_data = []
    banners = Banner.includes(:org).where(active: true).where(org: current_org).includes(:batches, :batch_banners).where(batches: {id: current_student.batches&.ids}).all.order(id: :desc) || []

    banners.each do |banner|
      banners_data << {
        "img_url"=> banner.image.url,
        "on_click"=> banner.on_click_url
      }
    end

    return (banners_data + (current_org.data['top_banners'] || [])) unless current_org.rcc?

    banners_data << {
      "img_url"=>"#{ENV.fetch('AWS_CLOUDFRONT_URL')}/apks/default-banner.jpg",
      "on_click"=>"https://rccpattern.com"
    }

    set_batch_ids = [208, 209, 210, 211, 212, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223]
    if (current_student.batches&.ids & [192, 196, 197, 198]).present?
      banners_data << {
        "img_url"=>"#{ENV.fetch('AWS_CLOUDFRONT_URL')}/apks/rcc/foundation-banner.jpg",
        "on_click"=>"https://exams.smartclassapp.in/pay_due_fees?student_id=#{current_student.id}"
      }
    else
      if current_student.pending_amount.present?
        if (current_student.batches&.ids & set_batch_ids).present?
          banners_data <<
          {
            "img_url"=>"#{ENV.fetch('AWS_CLOUDFRONT_URL')}/apks/rcc/set-banner.jpg",
            "on_click"=>"https://exams.smartclassapp.in/pay_due_fees?student_id=#{current_student.id}&set=true"
          }
          return banners_data
        else
          banners_data <<
          {
            "img_url"=>"#{ENV.fetch('AWS_CLOUDFRONT_URL')}/apks/rcc/rcc_fees_reminder-1.jpg",
            "on_click"=>"https://exams.smartclassapp.in/pay_due_fees?student_id=#{current_student.id}"
          }
        end
      else
        if (current_student.batches&.ids & set_batch_ids).present?
          banners_data <<
          {
            "img_url"=>"#{ENV.fetch('AWS_CLOUDFRONT_URL')}/apks/rcc/set-all-reminder.jpg",
            "on_click"=>"https://exams.smartclassapp.in/new-admission?student_id=#{current_student.id}"
          }
          return banners_data
        end
      end

      banners_data + (current_org.data['top_banners'] || [])
    end
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
