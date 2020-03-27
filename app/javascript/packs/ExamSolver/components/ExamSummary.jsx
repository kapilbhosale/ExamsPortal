import React from 'react';

class ExamSummary extends React.Component {

  renderRows = (summaryData) => {
    const returnVals = [];
    let totalScore = 0;
    for (let [key, value] of Object.entries(summaryData)) {
      totalScore += value.score;
      returnVals.push(<tr>
            <td className="summary-table-td">
              {key}
            </td>
            <td className="summary-table-td">
              {value.count}
            </td>
            <td className="summary-table-td">
              {value.ans}
            </td>
            <td className="summary-table-td">
              {value.count - value.ans}
            </td>
            <td className="summary-table-td">
            {value.correct}
            </td>
            <td className="summary-table-td">
            {value.wrong}
            </td>
            <td className="summary-table-td">
            {value.score}
            </td>
          </tr>)
    }
    return({returnVals, totalScore});
  }

  render() {
    const {examSummary} = this.props;
    return (
      <div className="container">
        <div className="row text-center">
          <br/><br/>
          <div className="col-md-12">
              <h6>summary of section(s) answered &nbsp;</h6>
          </div>
          <div className="col-md-12 text-muted">Your answers have been saved successfully.</div>
        </div>
        <div className="row">
      <div className="mx-auto">
        <div className="table">
            <table className="table-stripped summary-table">
              <tr>
                  <th className="summary-table-th text-white">Sec</th>
                  <th className="summary-table-th text-white">No of Q</th>
                  <th className="summary-table-th text-white">Ansrd</th>
                  <th className="summary-table-th text-white">Not-ansrd</th>
                  <th className="summary-table-th text-white">Correct</th>
                  <th className="summary-table-th text-white">Inorrect</th>
                  <th className="summary-table-th text-white">Score</th>
              </tr>
              { this.renderRows(examSummary).returnVals }
            </table>
        </div>
        <br />
        <div className="col-md-12">
            <h4>
              Total Score: { this.renderRows(examSummary).totalScore }
            </h4>
        </div>
        <br /> <br />
        <div className="text-center">
          <a href='/students/tests'>
            <button className="btn btn-success">Continue</button>
          </a>
        </div>
      </div>
    </div>
      </div>
    );
  }
}
export default ExamSummary;

