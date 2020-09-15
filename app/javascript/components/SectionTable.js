import ReactOnRails from 'react-on-rails';
import React from 'react';
import { ResponsivePie } from '@nivo/pie'

class SectionTable extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    const section_data = this.props.data;
    let data = [
      {
        "id": `Correct [${section_data.correct}]`,
        "label": "correct",
        "value": section_data.correct,
        "color": "rgb(2, 160, 0)"
      },
      {
        "id": `Wrong [${section_data.incorrect}]`,
        "label": "wrong",
        "value": section_data.incorrect,
        "color": "rgb(195, 0, 0)"
      },
      {
        "id": `Not Sovled [${section_data.not_answered}]`,
        "label": "not_solved",
        "value": section_data.not_answered,
        "color": "gray"
      }
    ];

    if (section_data.input_questions_present) {
      let input_data = [
        {
          "id": `Input Correct [${section_data.correct_input_questions}]`,
          "label": "correct",
          "value": section_data.correct_input_questions,
          "color": "rgb(2, 160, 0, 0.5)"
        },
        {
          "id": `Input Wrong [${section_data.incorrect_input_questions}]`,
          "label": "wrong",
          "value": section_data.incorrect_input_questions,
          "color": "rgb(195, 0, 0, 0.5)"
        },
      ];
      data = data.concat(input_data);
    }

    return(
      <div>
        <table className="table table-sm table-bordered">
          <tbody>
            <tr>
              <td colSpan="6">
                <div className="text-right">
                  <button type="button" className="btn btn-outline-info btn-sm">{ section_data.section_name && section_data.section_name.toUpperCase() }</button>
                </div>
              </td>
            </tr>
            <tr>
              <th>Type</th>
              <th>Correct</th>
              <th>Wrong</th>
              <th>Partial</th>
              <th>Not Solved</th>
              <th>Score</th>
            </tr>
            <tr>
              <td>Single Select
              </td>
              <td>{section_data.correct}</td>
              <td>{section_data.incorrect}</td>
              <td>-</td>
              <td>{section_data.not_answered}</td>
              <td>{(section_data.correct * section_data.extra_data.posetive_marks) - (section_data.incorrect * section_data.extra_data.negative_marks)}</td>
            </tr>
            <tr>
              <td>Multi Select</td>
              <td>{section_data.extra_data.multi_correct_count}</td>
              <td>{section_data.extra_data.multi_incorrect_count}</td>
              <td>{section_data.extra_data.multi_partial_count}</td>
              <td>{section_data.extra_data.multi_not_solved_count}</td>
              <td>{section_data.extra_data.multi_mark_total}</td>
            </tr>
            <tr>
              <td>Input</td>
              <td>{section_data.correct_input_questions}</td>
              <td>{section_data.incorrect_input_questions}</td>
              <td>-</td>
              <td>{section_data.extra_data.input_not_solved_count}</td>
              <td>{section_data.correct_input_questions * section_data.extra_data.posetive_marks}</td>
            </tr>
            <tr>
              <td colSpan="4">Score: </td>
              <td>
                Topper: <span className="badge badge-warning">{section_data.topper_score}</span>
              </td>
              <td>
                <h5>{`${section_data.score} / ${(section_data.section_out_of_marks)}`}</h5>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    )
  }
}

export default SectionTable;