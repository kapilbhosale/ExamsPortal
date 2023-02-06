class Admin::Api::V2::NotesController < Admin::Api::V2::ApiController
  def index
    @notes = Note.where(org_id: current_org.id)
  end
end
