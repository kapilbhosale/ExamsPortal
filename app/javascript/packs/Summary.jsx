import ReactOnRails from 'react-on-rails';
import React from 'react';
import SectionPieChart from '../components/SectionPieChart'

class Summary extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    const no_of_questions = (this.props.total_question * 4)
    return(
      <div className='text-center'>
        <table class="table table-sm table-bordered">
          <tbody>
            <tr>
              <td>Total Score:</td>
              <td>
                <h5>{`${this.props.total_score} / ${no_of_questions}`}</h5>
              </td>
              <td>
                Topper: <span class="badge badge-warning">{this.props.topper_total}</span>
              </td>
            </tr>
            <tr>
              <td>Total Time Spent: </td>
              <td colspan="2">
                <h5>{this.props.time_spent}</h5>
              </td>
            </tr>
          </tbody>
        </table>
        {
          this.props.section_data.map((data) => <SectionPieChart key={data.section_name} data={data}/>)
        }
      </div>
    );
  }
}

ReactOnRails.register({ Summary });