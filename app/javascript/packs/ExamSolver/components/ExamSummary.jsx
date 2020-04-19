import React from 'react';
import Summary from '../../Summary'

class ExamSummary extends React.Component {

  formatData = () => {
    const {examSummary} = this.props;
    let total_question = 0;
    let total_score = 0;
    const time_spent = '-';
    const topper_total = "-";
    const section_data = [];
    for (let [key, value] of Object.entries(examSummary)) {
      total_score += value.score;
      total_question += value.count
      section_data.push(
        {
          section_name: key,
          total_question: value.count,
          correct: value.correct,
          incorrect: value.wrong,
          not_answered: value.count - value.ans,
          score: value.score,
          topper_score: '-'
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
      }
    );
  }

  render() {
    const {total_question, total_score, time_spent, section_data, topper_total} = this.formatData();
    return(
      <div>
        <div className="text-center">
          <p>Quick Result Summary</p>
        </div>
        <Summary
          total_question={total_question}
          total_score={total_score}
          time_spent={time_spent}
          section_data={section_data}
          topper_total={topper_total}
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

