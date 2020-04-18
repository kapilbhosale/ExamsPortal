import React from 'react';
import CountdownTimer from './CountDownTimer';

class SectionList extends React.Component {

  render() {
    const $win = $(window);
    const MEDIAQUERY = {
      desktopXL: 1200,
      desktop: 992,
      tablet: 768,
      mobile: 575,
    };
    function isMobileDevice() {
      console.log("WINDOW WIDTH", $win.width())
      return $win.width() < MEDIAQUERY.mobile;
    }

    const { timeLeftMessage, timeIsUp, currentSection, changeSection, sections,
      remainingTimeAlert, syncWithBackend, updateTimeSpentOnQuestion } = this.props;
    return (
      <div className="row gray-border-bottom">
        <div className="col-md-10 col-sm-10 col-xs-12" style={{zIndex: "99"}}>
          <ul className="nav nav-pills sections-nav">
            {
              sections.map((section, idx) => {
                return (
                  <li key={idx} role="presentation" className={ currentSection === section ? "active" : "" }>
                    <a href="#" onClick={ (e) => changeSection(e) } className='menu' style={{padding: '6px 12px', fontSize: '16px'}}>
                      { section }
                    </a>
                  </li>
                );
              })
            }
          </ul>
        </div>
        {isMobileDevice() && <span>&nbsp;</span>}
        <CountdownTimer
            startedAt={ this.props.startedAt }
            timeInMinutes={ this.props.timeInMinutes }
            currentTime={ this.props.currentTime }
            remainingTimeAlert={ remainingTimeAlert }
            timeLeftMessage={timeLeftMessage}
            timeIsUp={timeIsUp}
            syncWithBackend={syncWithBackend}
            updateTimeSpentOnQuestion={ updateTimeSpentOnQuestion }
        />
      </div>
    );
  }
}

export default SectionList;
