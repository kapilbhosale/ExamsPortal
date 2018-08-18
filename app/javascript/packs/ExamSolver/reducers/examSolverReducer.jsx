import Immutable from 'immutable';
import actionTypes from '../constants/examSolverConstants';

export const $$initialState = Immutable.fromJS({
  currentQuestionIndex: {},
  totalQuestions: {},
  questionsBySections: {},
  startedAt: new Date(),
  timeInMinutes: 0,
  modal: false,
  studentId: 0,
  sections: [],
  questionsCountByStatus: Immutable.fromJS({}),
  currentSection: null,
  loading: true,
  navigationMapOpen: true,
  currentTime: new Date(),
  isTestSubmitModalOpen: false,
});

export default function examSolverReducer($$state = $$initialState, action) {
  const { type, val } = action;
  switch (type) {
    case actionTypes.INCREMENT_CURRENT_QUESTION_INDEX: {
      let currentSection = $$state.get('currentSection');
      let questionsBySections = $$state.get('questionsBySections').toJS();
      if (questionsBySections[currentSection][val.questionIndex].answerProps.answer !== null) {
        questionsBySections[currentSection][val.questionIndex].answerProps.isAnswered = true;
      } else {
        questionsBySections[currentSection][val.questionIndex].answerProps.isAnswered = false;
      }
      questionsBySections[currentSection][val.questionIndex].answerProps.needReview = false;
      let currentQuestionIndex = $$state.get('currentQuestionIndex').toJS()[currentSection];
      let nextIndex = currentQuestionIndex || 0;
      if (((currentQuestionIndex || 0) + 1) < $$state.get('totalQuestions').toJS()[currentSection]) {
        nextIndex = (currentQuestionIndex || 0) + 1;
      }
      return $$state.setIn(['currentQuestionIndex', currentSection], nextIndex).set('questionsBySections', Immutable.fromJS(questionsBySections));
    }
    case actionTypes.ANSWER_QUESTION: {
      let currentSection = $$state.get('currentSection');
      let questionsBySections = $$state.get('questionsBySections').toJS();
      questionsBySections[currentSection][val.questionIndex].answerProps.answer = val.answerIndex;
      return $$state.set('questionsBySections', Immutable.fromJS(questionsBySections));
    }
    case actionTypes.CLEAR_ANSWER: {
      let currentSection = $$state.get('currentSection');
      let questionsBySections = $$state.get('questionsBySections').toJS();
      questionsBySections[currentSection][val.questionIndex].answerProps.answer = 1;
      questionsBySections[currentSection][val.questionIndex].answerProps.isAnswered = false;
      return $$state.set('questionsBySections', Immutable.fromJS(questionsBySections));
    }
    case actionTypes.JUMP_TO_QUESTION: {
      let currentSection = $$state.get('currentSection');
      return $$state.setIn(['currentQuestionIndex', currentSection], val.questionIndex);
    }
    case actionTypes.MARK_FOR_REVIEW: {
      let currentSection = $$state.get('currentSection');
      let questionsBySections = $$state.get('questionsBySections').toJS();
      questionsBySections[currentSection][val.questionIndex].answerProps.needReview = true;
      let currentQuestionIndex = $$state.get('currentQuestionIndex').toJS()[currentSection];
      let nextIndex = currentQuestionIndex || 0;
      if (((currentQuestionIndex || 0) + 1) < $$state.get('totalQuestions').toJS()[currentSection]) {
        nextIndex = (currentQuestionIndex || 0) + 1;
      }
      return $$state.setIn(['currentQuestionIndex', currentSection], nextIndex).set('questionsBySections', Immutable.fromJS(questionsBySections));
    }
    case actionTypes.MARK_VISITED: {
      let currentSection = $$state.get('currentSection');
      let questionsBySections = $$state.get('questionsBySections').toJS();
      questionsBySections[currentSection][val.questionIndex].answerProps.visited = true;
      return $$state.set('questionsBySections', Immutable.fromJS(questionsBySections));
    }
    case actionTypes.LOAD_EXAM_DATA: {
      return $$state.set('questionsBySections', Immutable.fromJS(val.questionsBySections))
                    .set('currentQuestionIndex', Immutable.fromJS(val.currentQuestionIndex))
                    .set('startedAt', val.startedAt)
                    .set('totalQuestions', Immutable.fromJS(val.totalQuestions))
                    .set('studentId', val.studentId)
                    .set('sections', val.sections)
                    .set('currentSection', val.sections[0])
                    .set('timeInMinutes', val.timeInMinutes);
    }
    case actionTypes.SHOW_TIME_UP_MODAL:
      return $$state.set('modal', val);
    case actionTypes.UPDATE_QUESTIONS_COUNT:
      return $$state.set('questionsCountByStatus', Immutable.fromJS(val));
    case actionTypes.SECTION_CHANGED:
      return $$state.set('currentSection', val);
    case actionTypes.LOADING:
      return $$state.set('loading', val);
    case actionTypes.SET_NAVIGATION_MAP:
      return $$state.set('navigationMapOpen', val);
    case actionTypes.TOGGLE_TEST_SUBMIT_MODAL:
      return $$state.set('isTestSubmitModalOpen', val);
    case actionTypes.UPDATE_TIME_LEFT:
      return $$state.set('timeLeftMessage', val);
    default:
      return $$state;
  }
}
