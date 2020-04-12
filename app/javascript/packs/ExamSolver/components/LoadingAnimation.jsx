import React from 'react';
import PropTypes from 'prop-types';

export default class LoadingAnimation extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      percentage: 0,
    }
  }

  static propTypes = {
    minimal: PropTypes.bool,
    height: PropTypes.string,
    msg: PropTypes.string,
  }
  componentDidMount() {
    this.syncInterval = setInterval(() => {
      this.setState((prevState) => {
        let newPercentage = prevState.percentage > 100 ? 1 : prevState.percentage + 1
        return {percentage: newPercentage};
      })
    }, (1*1000));
  }

  componentWillUnmount() {
      clearInterval(this.syncInterval);
  }
  render() {
    const { minimal, height, msg } = this.props;
    let loadingClass = '';
    let style = {};
    if (height) {
      style = { height };
    } else if (!minimal) {
      loadingClass = 'full-vh';
    }
    const progressWidth = {
      width: `${this.state.percentage}%`
    }
    return (
      <div className='row'>
        <div className={ `col-md-12 ${ loadingClass }` } style={ style }>
          <ul className='loading-animation'>
            <li />
            <li />
            <li />
          </ul>
        </div>

        <div className="progress" style={{width: '100%'}}>
          <div className="progress-bar" style={progressWidth}>
            {`Questions Loaded: ${this.state.percentage}%`}
          </div>
        </div>

        <div style={{textAlign: 'center'}}>
          <h5>Loading Exam data, Please wait....</h5>
        </div>
      </div>
    );
  }
}
