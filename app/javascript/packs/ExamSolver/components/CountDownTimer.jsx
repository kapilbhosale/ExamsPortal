import React from 'react';
import Countdown from 'react-countdown-now';

class CountDownTimer extends React.Component {

    dateForCountdown() {
        const { startedAt, timeInMinutes, currentTime } = this.props;
        const currentDateTime = new Date(currentTime).getTime();
        const startedSince = currentDateTime - new Date(startedAt);
        const endTime = currentDateTime + (timeInMinutes * 60 * 1000);
        return (endTime - startedSince);
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
            <div className="col-md-5 col-sm-5 col-xs-12 text-right">
              <span className="text-right remaining-time blinking">
                { timeLeftMessage }
              </span>
              <span style={{ fontSize: '30px' }}>
                <Countdown
                    date={ this.dateForCountdown() }
                    daysInHours
                    onTick={ (e) => { this.showAlertIfRequired(e) } }
                    onComplete={ () => { timeIsUp() }}
                />
              </span>
            </div> 
        );
    }
}

export default CountDownTimer;

