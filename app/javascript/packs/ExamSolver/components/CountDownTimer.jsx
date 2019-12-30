import React from 'react';
import Countdown from 'react-countdown-now';
import ReactCountdownClock from 'react-countdown-clock';

class CountDownTimer extends React.Component {

    componentDidMount() {
        // Syncing answers with backend every 20 Seconds
        this.syncInterval = setInterval(() => {
            this.props.syncWithBackend();
        }, 40000);
    }

    componentWillUnmount() {
        clearInterval(this.syncInterval);
    }

    dateForCountdown() {
        const { startedAt, timeInMinutes, currentTime } = this.props;
        const currentDateTime = new Date(currentTime).getTime();
        const startedSince = currentDateTime - new Date(startedAt);
        const endTime = currentDateTime + (timeInMinutes * 60 * 1000);
        console.log("**************> " + new Date((endTime - startedSince)));
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

