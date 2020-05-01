import ReactOnRails from 'react-on-rails';
import React from 'react';
import SectionPieChart from '../components/SectionPieChart'

class Summary extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    const out_of = (this.props.total_marks)
    return(
      <div className="text-center col-md-6 col-xs-12">
        <table className="table table-sm table-bordered">
          <tbody>
            <tr>
              <td>Total Score:</td>
              <td>
                <h5>{`${this.props.total_score} / ${out_of}`}</h5>
              </td>
              <td>
                Topper: <span class="badge badge-warning">{this.props.topper_total}</span>
              </td>
            </tr>
            <tr>
              <td>Total Time Spent: </td>
              <td colSpan="2">
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

export default Summary;