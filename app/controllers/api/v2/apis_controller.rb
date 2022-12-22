class Api::V2::ApisController < Api::V2::ApiController

  SUBJECTS = {
    1 => 'Physics',
    2 => 'Biology',
    3 => 'Chemistry',
    4 => 'Mathematics',
    5 => 'General',
    6 => 'Exam Preparations'
  }

  def subjects
    data = []
    SUBJECTS.each do |key, val|
      data << {id: key, name: val, topics_count: rand(80), updated_on: DateTime.now.strftime("%d-%b-%Y %I:%M%p")}
    end

    render json: data
  end

  SOL_PDF_URLS = [
    "https://smart-exams-production.s3.amazonaws.com/uploads/pis/study_pdf/solution_paper/13599/NEET-Answer-Key-2021-by-Embibe-M1-M6.pdf",
    nil,
    nil,
  ]

  PDF_URLS = [
    "https://smart-exams-production.s3.amazonaws.com/uploads/pis/study_pdf/solution_paper/13599/NEET-Answer-Key-2021-by-Embibe-M1-M6.pdf",
    "https://smart-exams-production.s3.amazonaws.com/uploads/pis/study_pdf/solution_paper/13613/GOC_THOERY.pdf"
  ]

  def folders
    subject = SUBJECTS[params[:id].to_i]
    topics = []

    page = (params[:page] || 1).to_i

    start = page == 1 ? 0 : 20 * ( page - 1 )
    upto = page < 6 ? 20 : 10

    1.upto(upto).each do |i|
      topics << {
        id: start + i,
        name: "#{subject} - Chapter: #{start + i}",
        videos: {
          count: rand(50),
          new: rand(4)
        },
        pdf: {
          count: rand(50),
          new: rand(4)
        }
      }
    end


    render json: {
      page: page,
      page_size: 20,
      total_page: 6,
      count: 110,
      data: [
        subject_id: params[:id],
        subject_name: subject,
        topics: topics
      ]
    }
  end

  def pdfs

    subject = SUBJECTS[params[:subject_id].to_i]
    pdfs = []

    page = (params[:page] || 1).to_i

    start = page == 1 ? 0 : 20 * ( page - 1 )
    upto = page < 6 ? 20 : 10

    1.upto(upto).each do |i|
      pdfs << {
        id: start + i,
        name: "#{subject} - Chapter: #{params[:folder_id]} pdf (i)",
        tags: ["11th", "Important"],
        link: PDF_URLS.sample,
        solution: SOL_PDF_URLS.sample,
        updated_on: DateTime.now.strftime("%d-%b-%Y %I:%M%p")
      }
    end


    render json: {
      page: page,
      page_size: 20,
      total_page: 6,
      count: 110,
      data: [
        subject_id: params[:subject_id].to_i,
        subject_name: subject,
        topic_id: params[:folder_id].to_i,
        topic_name: "#{subject} - Chapter: #{params[:folder_id]}",
        pdfs: pdfs
      ]
    }
  end
end
