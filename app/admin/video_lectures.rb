ActiveAdmin.register VideoLecture do
  permit_params :id, :by, :description, :enabled, :publish_at, :subject_name, :tag,
    :thumbnail, :title, :uploaded_thumbnail, :url, :video_type, :view_limit,
    :created_at, :updated_at, :genre_id, :laptop_vimeo_id, :org_id, :subject_id, :video_id
end
