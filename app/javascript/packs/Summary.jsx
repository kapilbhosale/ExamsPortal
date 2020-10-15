import ReactOnRails from 'react-on-rails';
import React from 'react';
import SectionPieChart from '../components/SectionPieChart'
import SectionTable from '../components/SectionTable'

class Summary extends React.Component {
  constructor(props) {
    super(props);
  }

  summaryData(data) {
    if (!data.is_result_processed) {
      return(
        <div className="text-center col-md-6 col-xs-12">
          <p> Please wait, your final result will be calculated in some time. </p>
        </div>
      );
    }

    const out_of = data.total_marks
    return(
      <div className="text-center col-md-6 col-xs-12">
        <table className="table table-sm table-bordered">
          <tbody>
            <tr>
              <td>Total Score:</td>
              <td>
                <h5>{`${data.total_score} / ${out_of}`}</h5>
              </td>
              <td>
                Topper: <span className="badge badge-warning">{data.topper_total}</span>
              </td>
            </tr>
            <tr>
              <td>Total Time Spent: </td>
              <td colSpan="2">
                <h5>{data.time_spent}</h5>
              </td>
            </tr>
          </tbody>
        </table>
        {
          data.section_data.map((secData) => {
            if (secData.exam_type === 'jee_advance') {
              return <SectionTable key={secData.section_name} data={secData}/>
            } else {
              return <SectionPieChart key={secData.section_name} data={secData}/>
            }
          })
        }
      </div>
    );
  }

  render() {
    return(this.summaryData(this.props));
  }
}

ReactOnRails.register({ Summary });

export default Summary;