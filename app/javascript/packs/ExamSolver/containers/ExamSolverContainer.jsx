import PropTypes from 'prop-types'; import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import Immutable from 'immutable';
import { withRouter } from 'react-router';
import * as examSolverActionCreators from '../actions/examSolverActionCreators';
import ShellLeft from "../components/ShellLeft";
import ShellRight from "../components/ShellRight";

function select(state) {
  // $$ just indicates that it's Immutable.
  return {
    $$examSolverStore: state.$$examSolverStore,
  };
}

class ExamSolverContainer extends Component {
  constructor(props) {
    super(props);
  }

  componentWillMount() {
    this.actions().initialize();
  }

  actions() {
    return bindActionCreators(examSolverActionCreators, this.props.dispatch);
  }

  render() {
    return (
      <div className="">
        <ShellLeft />
        <ShellRight />
      </div>
    )
  }
}

ExamSolverContainer.propTypes = {
  dispatch: PropTypes.func.isRequired,
  $$examSolverStore: PropTypes.instanceOf(Immutable.Map).isRequired,
};

export default withRouter(connect(select)(ExamSolverContainer));
