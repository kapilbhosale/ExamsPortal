import PropTypes from 'prop-types';
import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import Immutable from 'immutable';
import { withRouter } from 'react-router';
import * as examSolverActionCreators from '../actions/examSolverActionCreators';
import ShellLeft from "../components/ShellLeft";
import ShellRight from "../components/ShellRight";
import LoadingAnimation from "../components/LoadingAnimation";
import TestSubmitModal from "../components/TestSubmitModal";
import Modal from 'react-modal';
import ExamSummary from "../components/ExamSummary";

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
    if (document.getElementById("mySidenav")) {
      if ($(window).width() < 575) {
        document.getElementById("mySidenav").style.width = "0";
      }
      else {
        document.getElementById("mySidenav").style.width = "320px";
      }
    }
    this.actions().isExamValid();
    this.actions().initialize();
  }

  componentDidUpdate(prevProps) {
    this.actions().syncAnswers();
    const { $$curExamSolverStore } = this.props;
    const { $$prevExamSolverStore } = prevProps;
    if (!$$curExamSolverStore || !$$prevExamSolverStore) {
      this.actions().syncAnswers();
      return;
    }
    const curNotVisitedQuestions = $$curExamSolverStore.getIn(['questionsCountByStatus',  currentSection,'notVisited']);
    const prevNotVisitedQuestions = $$prevExamSolverStore.getIn(['questionsCountByStatus',  currentSection,'notVisited']);

    if (curNotVisitedQuestions !== prevNotVisitedQuestions) {
      this.actions().syncAnswers();
    }
  }

  // componentWillReceiveProps(nextProps){
  //   const prevStore = this.props.$$examSolverStore;
  //   const nextStore = nextProps.$$examSolverStore;
  //   // if(prevStore.get('questionsBy') !== nextStore.get('questions')){
  //     this.actions().syncAnswers();
  //   // }
  // }

  componentWillMount() {
    const $win = $(window);
    const MEDIAQUERY = {
      desktopXL: 1200,
      desktop: 992,
      tablet: 768,
      mobile: 575,
    };
    if ($win.width() < MEDIAQUERY.mobile) {
      this.actions().setNavigationMap(false);
    }
    this.actions().getCurrentServerTime();
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
    const currentSection = $$examSolverStore.get('currentSection');
    const timeInMinutes = $$examSolverStore.get('timeInMinutes');
    const answeredQuestions = $$examSolverStore.getIn(['questionsCountByStatus', currentSection, 'answered']);
    const notAnsweredQuestions = $$examSolverStore.getIn(['questionsCountByStatus',  currentSection,'notAnswered']);
    const markedQuestions = $$examSolverStore.getIn(['questionsCountByStatus',  currentSection,'marked']);
    const notVisitedQuestions = $$examSolverStore.getIn(['questionsCountByStatus',  currentSection,'notVisited']);
    const sections = $$examSolverStore.get('sections');
    const modal = $$examSolverStore.get('modal');
    const loading = $$examSolverStore.get('loading');
    const isNavigationMapOpen = $$examSolverStore.get('navigationMapOpen');
    const currentTime = $$examSolverStore.get('currentTime');
    const isTestSubmitModalOpen = $$examSolverStore.get('isTestSubmitModalOpen');
    const sectionWiseSummary = $$examSolverStore.get('questionsCountByStatus');
    const timeLeftMessage = $$examSolverStore.get('timeLeftMessage');
    const examFinished = $$examSolverStore.get('examFinished');
    const examSummary = $$examSolverStore.get('examSummary');

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

    const onFirstQuestion = () => {
      return currentQuestionIndex[currentSection] === 0;
    }

    if(examFinished) {
      return(
        <ExamSummary examSummary={examSummary}/>
      )
    }

    const actions = this.actions();
    if (loading) {
      return <LoadingAnimation height="100px" msg="Loading All Exam data, Please wait, This May take some time."/>;
    } else {
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
                onClick={ actions.submitTest }
                >
                OK
              </button>
            </div>
          </Modal>
          <div className='row'>
            <ShellLeft
              questions={questionsBySections[currentSection] || []}
              currentQuestionIndex={currentQuestionIndex[currentSection]}
              startedAt={startedAt}
              timeInMinutes={timeInMinutes}
              currentSection={currentSection}
              sections={sections}
              isNavigationMapOpen={ isNavigationMapOpen }
              currentTime={ currentTime }
              timeLeftMessage={ timeLeftMessage }
              { ...this.actions() }
              />
            <ShellRight
              questions={ questionsBySections[currentSection] || []}
              totalQuestions={ totalQuestions }
              currentQuestionIndex={currentQuestionIndex[currentSection]}
              answeredQuestions={ answeredQuestions }
              notAnsweredQuestions ={ notAnsweredQuestions }
              markedQuestions={ markedQuestions }
              notVisitedQuestions={ notVisitedQuestions }
              isNavigationMapOpen={ isNavigationMapOpen }
              { ...this.actions() }
            />
          </div>
          <div className='row'>
	    <div className="bottom-menu margin-bottom-10">
	      <div className='col-md-8'>
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
                  disabled={ onFirstQuestion() }
                  >
                </button>
                <button
                  type="button"
                  className="btn btn-success save-next-btn margin-left-5 pull-right"
                  onClick={ () => { actions.saveAndNext(currentQuestionIndex[currentSection]) } }
                  >
                </button>
              </div>
            </div>
          </div>
          <TestSubmitModal
            cancelHandler={ () => { actions.toggleTestSubmitModal(false); } }
            sectionWiseSummary={ sectionWiseSummary }
            submitTest={ actions.submitTest }
            isTestSubmitModalOpen={ isTestSubmitModalOpen }
          />
	</div>
      );
    }
  }
}

ExamSolverContainer.propTypes = {
  dispatch: PropTypes.func.isRequired,
  $$examSolverStore: PropTypes.instanceOf(Immutable.Map).isRequired,
};

export default withRouter(connect(select)(ExamSolverContainer));
