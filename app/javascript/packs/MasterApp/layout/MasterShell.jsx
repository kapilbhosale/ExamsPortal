import React, { Component } from 'react';
import PropTypes from 'prop-types';
import window from 'global';
import Immutable from 'immutable';
import { withRouter } from 'react-router';

class MasterShell extends Component {

  componentDidUpdate(prevProps) {
    if (this.props.location !== prevProps.location) {
      window.scrollTo(0, 0);
    }
  }

  render() {
    const { $$masterStore } = this.props;

    return (
      <div className='page-content'>
        <div className='container-fluid'>
          { this.props.children }
        </div>
      </div>
    );
  }
}


MasterShell.propTypes = {
  children: PropTypes.object.isRequired,
  location: PropTypes.object.isRequired,
  $$masterStore: PropTypes.instanceOf(Immutable.Map).isRequired,
  dispatch: PropTypes.func.isRequired,
};

export default withRouter(MasterShell);
