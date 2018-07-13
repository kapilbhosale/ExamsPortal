import React, { Component } from 'react';
import { Switch } from 'react-router-dom';
import { withRouter } from 'react-router';
import PropTypes from 'prop-types';
import Immutable from 'immutable';
import { connect } from 'react-redux';
import Loadable from 'react-loadable';
import { bindActionCreators } from 'redux';
import MasterShell from '../layout/MasterShell';
import * as masterActionCreators from '../actions/masterActionCreators';
import RenderRoute from './RenderRoute';
import PageLoading from "../components/PageLoading";

function select(state) {
  // Which part of the Redux global state does our component want to receive as props?
  // Note the use of `$$` to prefix the property name because the value is of type Immutable.js
  return {
    $$masterStore: state.$$masterStore,
  };
}
// React loadable helps in splitting the JSX views.
// Any import is split by webpack by default as a separate JS file
function MyLoadable(opts) {
  return Loadable(Object.assign({
    loading: PageLoading,
    delay: 200,
    timeout: 10,
  }, opts));
}

const ExamSolver = MyLoadable({
  loader: () => import('../../ExamSolver/startup/ExamSolverApp'),
  render(loaded, props) {
    const ExamApp = loaded.default;
    return (
      <ExamApp { ...props } />
    );
  },
});

class MasterRoutes extends Component {

  componentDidMount() {
    const masterActions = bindActionCreators(masterActionCreators, this.props.dispatch);
    const { updateNextPathName, updateNextState } = masterActions;
    // Some basic global functions pushed to window
    // So that it can be accessed elsewhere
    window.updateNextPathName = updateNextPathName;
    window.updateNextState = updateNextState;
    window.navigateToNextPath = masterActionCreators.navigateToNextPath;
    window.masterDispatch = this.props.dispatch;
    window.rrHistory = this.props.history;
  }

  render() {
    const { $$masterStore, dispatch, location } = this.props;
    return (
      <div>
        <MasterShell location={ location } $$masterStore={ $$masterStore } dispatch={ dispatch }>
          <Switch>
            <RenderRoute
              exact
              path='/'
              component={ ExamSolver }
            />
          </Switch>
        </MasterShell>
      </div>
    );
  }
}

MasterRoutes.propTypes = {
  dispatch: PropTypes.func.isRequired,
  $$masterStore: PropTypes.instanceOf(Immutable.Map).isRequired,
  history: PropTypes.object,
  location: PropTypes.object,
};

export default withRouter(connect(select)(MasterRoutes));
