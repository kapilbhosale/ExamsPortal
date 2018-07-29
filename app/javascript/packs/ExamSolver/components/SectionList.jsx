import React from 'react';
import Countdown from 'react-countdown-now';

class ShellList extends React.Component {

  dateForCountdown() {
    const { startedAt, timeInMinutes } = this.props;
    // console.log('startedAt: ' + startedAt);
    const startedSince = Date.now() - new Date(startedAt);
    // console.log('startedSince: ' + startedSince);
    const endTime = Date.now() + (timeInMinutes * 60 * 1000);
    // console.log('endTime:' + endTime);
    return (endTime - startedSince);
  }

  render() {
    const { submitTest, onTick, timeIsUp } = this.props;
    return (
      <div className="row">
        <div className="col-md-1" style={{ paddingTop: '10px' }}>
        </div>
        <div className="col-md-9">
        </div>
        <div className="col-md-2">
          <span style={{ fontSize: '30px' }}>
            <Countdown
              date={ this.dateForCountdown() }
              daysInHours
              onComplete={ () => { timeIsUp() }}
            />
          </span>
        </div>
      </div>
    );
  }
}

export default ShellList;

