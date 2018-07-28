import PropTypes from 'prop-types';
import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import Immutable from 'immutable';
import { withRouter } from 'react-router';
import * as examSolverActionCreators from '../actions/examSolverActionCreators';
import ShellLeft from "../components/ShellLeft";
import ShellRight from "../components/ShellRight";
import Modal from 'react-modal';

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

  componentWillReceiveProps(nextProps){
    const prevStore = this.props.$$examSolverStore;
    const nextStore = nextProps.$$examSolverStore;
    if(prevStore.get('questions') !== nextStore.get('questions')){
      this.actions().syncAnswers();
    }
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
    const startedAt = $$examSolverStore.get('startedAt');
    const timeInMinutes = $$examSolverStore.get('timeInMinutes');

    const modal = $$examSolverStore.get('modal');
    const customStyles = {
  content : {
    top                   : '50%',
    left                  : '50%',
    right                 : 'auto',
    bottom                : 'auto',
    marginRight           : '-50%',
    transform             : 'translate(-50%, -50%)'
  }
};
    const $win = $(window);
    const MEDIAQUERY = {
      desktopXL: 1200,
      desktop: 992,
      tablet: 768,
      mobile: 575,
    };
    function isMobileDevice() {
      return $win.width() < MEDIAQUERY.mobile;
    }
    const openNav = () => {
      if (isMobileDevice()) {
        document.getElementById("mySidenav").style.width = "100%";
      }
      else {
        document.getElementById("mySidenav").style.width = "350px";
      }
    };
    
    return (
      <div className="">
       <Modal
          isOpen={modal}
          onAfterOpen={() => {}}
          onRequestClose={() => {}}
          style={customStyles}
          contentLabel="Example Modal"
        >
        Time is up. Please click ok to continue and view results.
        <br/>
        <br/>
        <div className="text-center">
          <button
            className="btn btn-default btn-primary"
            onClick={ this.actions().submitTest }
            >
            OK
          </button>
        </div>
        </Modal>
        <ShellLeft
          questions={questions}
          currentQuestionIndex={currentQuestionIndex}
          startedAt={startedAt}
          timeInMinutes={timeInMinutes}
          { ...this.actions() }
          />
        <ShellRight
          questions={ questions }
          totalQuestions={ totalQuestions }
          currentQuestionIndex={currentQuestionIndex}
          { ...this.actions() }
        />
        <div className='row'>
          <div className="bottom-menu margin-bottom-20">
            <button
              type="button"
              className="btn btn-primary mark-review-btn margin-left-5"
            >
            </button>
            <button
              type="button"
              className="btn btn-primary clear-response-btn margin-left-5"
            >
            </button>
            <button
              type="button"
              className="btn btn-primary previous-btn margin-left-5"
            >
            </button>
            <button
              type="button"
              className="btn btn-success save-next-btn margin-left-5"
            >
            </button>
            <span className="btn btn-success btn-xs pull-right margin-right-5" onClick={ () => { openNav() }}>Map</span>
        </div>
        </div>
      </div>
    )
  }
}

ExamSolverContainer.propTypes = {
  dispatch: PropTypes.func.isRequired,
  $$examSolverStore: PropTypes.instanceOf(Immutable.Map).isRequired,
};

export default withRouter(connect(select)(ExamSolverContainer));
