import React from 'react';
import PropTypes from 'prop-types';

export default class LoadingAnimation extends React.Component {
  static propTypes = {
    minimal: PropTypes.bool,
    height: PropTypes.string,
  }
  render() {
    const { minimal, height } = this.props;
    let loadingClass = '';
    let style = {};
    if (height) {
      style = { height };
    } else if (!minimal) {
      loadingClass = 'full-vh';
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
      </div>
    );
  }
}
