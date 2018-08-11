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
    const { submitTest, onTick, timeIsUp, currentSection, changeSection, sections } = this.props;
    return (
      <div className="row gray-border-bottom padding-bottom-15">
        <div className="col-md-8 col-sm-7 col-xs-12">
          <ul className="nav nav-pills sections-nav">
            {
              sections.map((section, idx) => {
                return (
                  <li key={idx} role="presentation" className={ currentSection == section ? "active" : "" }>
                    <a href="#" onClick={ (e) => changeSection(e) }className='menu'>
                      { section }
                    </a>
                  </li>
                );
              })
            }
          </ul>
        </div>
        <div className="col-md-4 col-sm-5 col-xs-12 text-right">
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

