class Api::V1::TrackersController < Api::V1::ApiController

  def create
    # remove this line of code
    # current_student = Student.last
    tracker = Tracker.find_or_create_by(
      student_id: current_student.id,
      resource_type: tracker_params[:resource_type],
      resource_id: tracker_params[:resource_id],
      event: tracker_params[:event]
    )

    if tracker.data.present?
      if params[:timeSpent].to_i > 10 * 60
        tracker.data = {
          view_count: tracker.data['view_count'] + 1,
          total_duration: tracker.data['total_duration'] + params[:timeSpent]
        }
      end
    else
      tracker.data = {
        view_count: 1,
        total_duration: params[:timeSpent],
      }
    end
    tracker.save
    render json: {}, status: :ok
  end

  private

  def tracker_params
    params.permit(:resource_type, :resource_id, :event)
  end
end
