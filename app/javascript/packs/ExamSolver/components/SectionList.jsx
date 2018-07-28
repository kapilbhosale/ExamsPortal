import React from 'react';
import Countdown from 'react-countdown-now';

class ShellList extends React.Component {
  render() {
    const { submitTest } = this.props;
    return (
      <div className="row">
        <div className="col-md-1" style={{ paddingTop: '10px' }}>
        </div>
        <div className="col-md-9">
        </div>
        <div className="col-md-2">
          <span style={{ fontSize: '30px' }}>
            <Countdown
              date={Date.now() + (this.props.totalQuestions * 60 * 1000) }
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

