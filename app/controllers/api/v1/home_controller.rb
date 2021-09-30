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
      'org_data' => current_org&.data&.dig('org_data'),
      'badges' => {
        new_videos: nil,
        new_exams: nil,
        new_pdfs: nil
      },
      'student_name' => current_student.name.split(' ').first,
    }
    render json: json_data, status: :ok
  end

  def top_banners_data
    cache_key = "BA-#{current_student.batches.order(:id).ids.join('-')}"
    cached_data = REDIS_CACHE.get(cache_key)

    return JSON.parse(cached_data) if cached_data.present?

    banners_data = []
    banners = Banner.includes(:org).where(active: true).where(org: current_org).includes(:batches, :batch_banners).where(batches: {id: current_student.batches&.ids}).all.order(id: :desc) || []

    banners.each do |banner|
      banners_data << {
        "img_url"=> banner.image.url,
        "on_click"=> banner.on_click_url
      }
    end

    return (banners_data + (current_org.data['top_banners'] || [])) unless current_org.subdomain == 'exams'

    banners_data << {
      "img_url"=>"https://smart-exams-production.s3.ap-south-1.amazonaws.com/apks/default-banner.jpg",
      "on_click"=>"https://rccpattern.com"
    }

    set_batch_ids = [208, 209, 210, 211, 212, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223]
    if (current_student.batches&.ids & [192, 196, 197, 198]).present?
      banners_data << {
        "img_url"=>"https://smart-exams-production.s3.ap-south-1.amazonaws.com/apks/rcc/foundation-banner.jpg",
        "on_click"=>"https://exams.smartclassapp.in/pay_due_fees?student_id=#{current_student.id}"
      }
    else
      if current_student.pending_amount.present?
        if (current_student.batches&.ids & set_batch_ids).present?
          banners_data <<
          {
            "img_url"=>"https://smart-exams-production.s3.ap-south-1.amazonaws.com/apks/rcc/set-banner.jpg",
            "on_click"=>"https://exams.smartclassapp.in/pay_due_fees?student_id=#{current_student.id}&set=true"
          }
          return banners_data
        else
          banners_data <<
          {
            "img_url"=>"https://smart-exams-production.s3.ap-south-1.amazonaws.com/apks/rcc/rcc_fees_reminder.jpg",
            "on_click"=>"https://exams.smartclassapp.in/pay_due_fees?student_id=#{current_student.id}"
          }
        end
      else
        if (current_student.batches&.ids & set_batch_ids).present?
          banners_data <<
          {
            "img_url"=>"https://smart-exams-production.s3.ap-south-1.amazonaws.com/apks/rcc/set-all-reminder.jpg",
            "on_click"=>"https://exams.smartclassapp.in/new-admission?student_id=#{current_student.id}"
          }
          return banners_data
        end
      end

      if (current_student.batches&.ids & [141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156]).present?
        banners_data <<
          {
            'img_url' => 'https://smart-exams-production.s3.ap-south-1.amazonaws.com/apks/rcc/rcc_dispatch_2.png',
            'on_click' => 'https://docs.google.com/forms/d/e/1FAIpQLScFBdTA4VSp-g41qkG0u-ZX_PtGQXvUcqrXVLqMRMlRt_c3Pw/viewform'
          }
      end

      if (current_student.batches&.ids & [250, 253]).present?
        banners_data <<
          {
            'img_url' => 'https://smart-exams-production.s3.ap-south-1.amazonaws.com/apks/rcc/saarthi-banner.jpg',
            'on_click' => 'https://docs.google.com/forms/d/e/1FAIpQLScGrRhV3VFDTKlHyhdtkcd8be-O-LxcOjMktmcVYtup87Mh4A/viewform'
          }
      end

      banners_data <<
        {
          "img_url"=>"https://smart-exams-production.s3.ap-south-1.amazonaws.com/apks/rcc/rcc-banner-29-march.jpg",
          "on_click"=>"https://exams.smartclassapp.in/new-admission"
        }
      banners_data + current_org.data['top_banners']

      REDIS_CACHE.set(cache_key, banners_data.to_json)
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
