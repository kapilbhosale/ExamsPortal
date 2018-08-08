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
    if ($(window).width() < 575) {
      document.getElementById("mySidenav").style.width = "0";
    }
    else {
      document.getElementById("mySidenav").style.width = "350px";
    }
    this.actions().initialize();
  }

  componentWillReceiveProps(nextProps){
    const prevStore = this.props.$$examSolverStore;
    const nextStore = nextProps.$$examSolverStore;
    // if(prevStore.get('questionsBy') !== nextStore.get('questions')){
      this.actions().syncAnswers();
    // }
  }

  componentWillMount() {
    this.actions();
  }

  actions() {
    return bindActionCreators(examSolverActionCreators, this.props.dispatch);
  }

  render() {
    const { $$examSolverStore } = this.props;
    const questionsBySections = $$examSolverStore.get('questionsBySections').toJS();
    const currentQuestionIndex = $$examSolverStore.get('currentQuestionIndex').toJS();
    const totalQuestions = $$examSolverStore.get('totalQuestions');
    const startedAt = $$examSolverStore.get('startedAt');
    const timeInMinutes = $$examSolverStore.get('timeInMinutes');
    const answeredQuestions = $$examSolverStore.getIn(['questionsCountByStatus', 'answered']);
    const notAnsweredQuestions = $$examSolverStore.getIn(['questionsCountByStatus', 'notAnswered']);
    const markedQuestions = $$examSolverStore.getIn(['questionsCountByStatus', 'marked']);
    const notVisitedQuestions = $$examSolverStore.getIn(['questionsCountByStatus', 'notVisited']);
    const currentSection = $$examSolverStore.get('currentSection');

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
        document.getElementById("mySidenav").style.paddingLeft = "50px";
      }
      else {
        document.getElementById("mySidenav").style.width = "350px";
        document.getElementById("mySidenav").style.paddingLeft = "50px";
      }
    };

    const actions = this.actions();
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
          questions={questionsBySections[currentSection]}
          currentQuestionIndex={currentQuestionIndex[currentSection]}
          startedAt={startedAt}
          timeInMinutes={timeInMinutes}
          currentSection={currentSection}
          { ...this.actions() }
          />
        <ShellRight
          questions={ questionsBySections[currentSection] }
          totalQuestions={ totalQuestions }
          currentQuestionIndex={currentQuestionIndex[currentSection]}
          answeredQuestions={ answeredQuestions }
          notAnsweredQuestions ={ notAnsweredQuestions }
          markedQuestions={ markedQuestions }
          notVisitedQuestions={ notVisitedQuestions }
          { ...this.actions() }
        />
        <div className='row'>
          <div className="bottom-menu margin-bottom-10 text-center">
            <button
              type="button"
              className="btn btn-primary mark-review-btn margin-left-5"
              onClick={ () => { actions.markForReview(currentQuestionIndex[currentSection]) } }
            >
            </button>
            <button
              type="button"
              className="btn btn-primary clear-response-btn margin-left-5"
              onClick={ () => { actions.clearAnswer(currentQuestionIndex[currentSection]) } }
            >
            </button>
            <button
              type="button"
              className="btn btn-primary previous-btn margin-left-5"
              onClick={ () => { actions.previousQuestion(currentQuestionIndex[currentSection]) } }
            >
            </button>
            <button
              type="button"
              className="btn btn-success save-next-btn margin-left-5"
              onClick={ () => { actions.saveAndNext(currentQuestionIndex[currentSection]) } }
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
