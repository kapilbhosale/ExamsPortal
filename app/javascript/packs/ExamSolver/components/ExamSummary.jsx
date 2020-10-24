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

  render() {
    const {total_question, total_score, time_spent, section_data, topper_total, total_marks} = this.formatData();
    return(
      <div>
        <div className="text-center">
          <p>Quick Result Summary</p>
        </div>
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
    );
  }
}
export default ExamSummary;

