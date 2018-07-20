import PropTypes from 'prop-types';
import React, { Component } from 'react';
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

  componentDidMount() {
    this.actions().initialize();
  }

  componentWillMount() {
    this.actions();
  }

  actions() {
    return bindActionCreators(examSolverActionCreators, this.props.dispatch);
  }

  render() {
    const { $$examSolverStore } = this.props;
    const questions = $$examSolverStore.get('questions').toJS();
    const currentQuestionIndex = $$examSolverStore.get('currentQuestionIndex');
    const totalQuestions = $$examSolverStore.get('totalQuestions');
    return (
      <div className="">
        <ShellLeft
          questions={questions}
          currentQuestionIndex={currentQuestionIndex}
          { ...this.actions() }
          />
        <ShellRight
          questions={ questions }
          totalQuestions={ totalQuestions }
          currentQuestionIndex={currentQuestionIndex}
          { ...this.actions() }
        />
      </div>
    )
  }
}

ExamSolverContainer.propTypes = {
  dispatch: PropTypes.func.isRequired,
  $$examSolverStore: PropTypes.instanceOf(Immutable.Map).isRequired,
};

export default withRouter(connect(select)(ExamSolverContainer));
