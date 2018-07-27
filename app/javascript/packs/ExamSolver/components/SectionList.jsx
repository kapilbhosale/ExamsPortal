import React from 'react';
import Countdown from 'react-countdown-now';

class ShellList extends React.Component {
  render() {
    const { submitTest, startedAt } = this.props;
    const startedSince = Date.now() - new Date(startedAt);
    console.log('startedSince: ' + startedSince);
    const endTime = Date.now() + (this.props.totalQuestions * 60 * 1000);
    console.log('endTime:' + endTime);
    return (
      <div className="row">
        <div className="col-md-1" style={{ paddingTop: '10px' }}>
          <label style={{ display: "inline" }}>Sections</label>
        </div>
        <div className="col-md-9">
          <ul className="nav nav-pills">
            <li role="presentation" className="active"><a href="#">Physics</a></li>
            <li role="presentation"><a href="#">Chemistry</a></li>
            <li role="presentation"><a href="#">Biology</a></li>
          </ul>
        </div>
        <div className="col-md-2">
          <span style={{ fontSize: '30px' }}>
            <Countdown
              date={ endTime - startedSince }
              daysInHours
              onComplete={ () => { submitTest() }}
            />
          </span>
        </div>
      </div>
    );
  }
}

export default ShellList;

