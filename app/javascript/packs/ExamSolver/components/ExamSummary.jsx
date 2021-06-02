import React from 'react';
import Summary from '../../Summary'

class ExamSummary extends React.Component {

  formatData = () => {
    const {examSummary} = this.props;
    let total_question = 0;
    let total_score = 0;
    let total_marks = 0;
    const time_spent = '-';
    const topper_total = "-";
    const section_data = [];
    for (let [key, value] of Object.entries(examSummary)) {
      total_score += value.score;
      total_question += value.count
      total_marks += value.section_out_of_marks
      section_data.push(
        {
          section_name: key,
          total_question: value.count,
          correct: value.correct,
          incorrect: value.wrong,
          not_answered: value.count - value.ans,
          score: value.score,
          topper_score: 'NA',
          section_out_of_marks: value.section_out_of_marks,
          input_questions_present: value.input_questions_present,
          correct_input_questions: value.correct_input_questions,
          incorrect_input_questions: value.incorrect_input_questions,
        }
      );
    }
    return(
      {
        total_question,
        total_score,
        time_spent,
        section_data,
        topper_total,
        total_marks,
      }
    );
  }

  resultSyncStatus = () => {
    if (this.props.resultSynced === null) {
      return(
        <div className="text-center">
          <div className="text-center" style={{backgroundColor: '#f1c40f', borderRadius: '10px', padding: '12px 0px 1px 0px'}} >
            <h1>⌛</h1>
            <h5 className="text-white">WAIT, we are storing your result to server.</h5>
          </div>
          <p>
            If you do not wait, your final result will not be calculated and you will be absent or your score will be different than here
          </p>
        </div>
      );
    } else if (this.props.resultSynced) {
      return(
        <div className="text-center" style={{backgroundColor: '#5eba01', padding: '12px 0px 1px 0px', borderRadius: '10px'}} >
          <h5 className="text-white"> 👍 Result Synced with Server.</h5>
        </div>
      );
    } else {
      return(
        <div className="text-center">
          <div className="text-center" style={{backgroundColor: '#f76564', borderRadius: '10px', padding: '12px 0px 1px 0px'}} >
            <h1>😢</h1>
            <h5 className="text-white">Error Storing your result to Server</h5>
          </div>
          <p>
            Check Internet and try storing your result, else your final result will not be calculated and you will be absent or your score will be different than here
          </p>
          <button
            className="btn btn-primary"
            onClick={this.props.reSubmitTest}
            >Store My Result To Server</button>
          <hr/>
        </div>
      );
    }
  }

  render() {
    const {total_question, total_score, time_spent, section_data, topper_total, total_marks} = this.formatData();
    return(
      <div>
        <div className="text-center">
          <p>Quick Result Summary</p>
          {this.resultSyncStatus()}
        </div>
        {
          this.props.resultSynced && (
          <div>
            <Summary
              is_result_processed={true}
              total_question={total_question}
              total_score={total_score}
              time_spent={time_spent}
              section_data={section_data}
              topper_total={topper_total}
              total_marks={total_marks}
            />
            <div className="text-center">
              <a href='/students/tests'>
                <button className="btn btn-success">Continue</button>
              </a>
            </div>
          </div>
        )}
      </div>
    );
  }
}
export default ExamSummary;

