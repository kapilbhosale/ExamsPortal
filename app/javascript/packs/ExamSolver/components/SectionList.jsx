import React from 'react';
import CountdownTimer from './CountDownTimer';

class SectionList extends React.Component {

  render() {
    const { timeLeftMessage, timeIsUp, currentSection, changeSection, sections,
      remainingTimeAlert, syncWithBackend } = this.props;
    return (
      <div className="row gray-border-bottom">
        <div className="col-md-10 col-sm-10 col-xs-12">
          <ul className="nav nav-pills sections-nav">
            {
              sections.map((section, idx) => {
                return (
                  <li key={idx} role="presentation" className={ currentSection === section ? "active" : "" }>
                    <a href="#" onClick={ (e) => changeSection(e) } className='menu'>
                      { section }
                    </a>
                  </li>
                );
              })
            }
          </ul>
        </div>
        <CountdownTimer
            startedAt={ this.props.startedAt }
            timeInMinutes={ this.props.timeInMinutes }
            currentTime={ this.props.currentTime }
            remainingTimeAlert={ remainingTimeAlert }
            timeLeftMessage={timeLeftMessage}
            timeIsUp={timeIsUp}
            syncWithBackend={syncWithBackend}
        />
      </div>
    );
  }
}

export default SectionList;
