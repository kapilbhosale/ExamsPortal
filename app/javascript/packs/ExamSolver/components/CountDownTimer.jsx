import React from 'react';
import Countdown from 'react-countdown-now';
import ReactCountdownClock from 'react-countdown-clock';

class CountDownTimer extends React.Component {
    constructor(props) {
      super(props);

      this.state = {
          currentQuestionIndex: null,
          timeSpent: 0,
      }
    }

    componentDidMount() {
        // Syncing answers with backend every 10 minutes
        this.syncInterval = setInterval(() => {
            this.props.syncWithBackend();
        }, (10*60*1000));

      this.timeSpentInterval = setInterval( () => {
        this.setState({ timeSpent: this.state.timeSpent + 1 });
      }, 1000);
    }

    componentDidUpdate(prevProps) {
      if (this.props.currentQuestionIndex !== prevProps.currentQuestionIndex) {
        this.props.updateTimeSpentOnQuestion(prevProps.currentQuestionIndex, this.state.timeSpent, prevProps.currentSection);
        this.setState({currentQuestionIndex: this.props.currentQuestionIndex, timeSpent: 0});
      }
    }

    componentWillUnmount() {
        clearInterval(this.syncInterval);
        clearInterval(this.timeSpentInterval);
    }

    dateForCountdown() {
        const { startedAt, timeInMinutes, currentTime } = this.props;
        const currentDateTime = new Date(currentTime).getTime();
        const startedSince = currentDateTime - new Date(startedAt);
        const endTime = currentDateTime + (timeInMinutes * 60 * 1000);
        return ((endTime - startedSince) - currentDateTime)/(1000);
    }

    showAlertIfRequired(e) {
        const { remainingTimeAlert } = this.props;
        const halfTime = this.props.timeInMinutes / 2;
        const halfTimeHour = parseInt(halfTime / 60);
        const halfTimeMinutes = halfTime % 60;
        if (e.hours === halfTimeHour && e.minutes === halfTimeMinutes && e.seconds === 0) {
            remainingTimeAlert('Half time lapsed.');
            setTimeout(() => { remainingTimeAlert(''); }, 10000);
        } else if (e.hours === 0 && e.minutes === 10 && e.seconds === 0) {
            remainingTimeAlert('10 minutes remaining.');
            setTimeout(() => { remainingTimeAlert(''); }, 10000);
        } else if (e.hours === 0 && e.minutes === 3 && e.seconds === 0) {
            remainingTimeAlert('3 minutes remaining.');
            setTimeout(() => { remainingTimeAlert(''); }, 10000);
        }
    }

    render() {
        const { timeLeftMessage, timeIsUp } = this.props;
        return (
            <div className="col-md-2 col-sm-2 col-xs-12 text-right">
              <span className="text-right remaining-time blinking">
                { timeLeftMessage }
              </span>
              <span style={{marginTop: '-45px', marginBottom: '-80px', float: 'right', paddingRight: '80px'}}>
                <ReactCountdownClock seconds={this.dateForCountdown()}
                                     color="#054379"
                                     alpha={0.7}
                                     hideArc
                                     size={150}
                                     weight={4}
                                     fontSize={'30px'}
                                     onComplete={ () => { timeIsUp() }} />
              </span>
            </div>
        );
    }
}

export default CountDownTimer;

