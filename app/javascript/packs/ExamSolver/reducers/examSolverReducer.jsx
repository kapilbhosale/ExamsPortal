import Immutable from 'immutable';
import actionTypes from '../constants/examSolverConstants';

export const $$initialState = Immutable.fromJS({
  currentQuestionIndex: 0,
  totalQuestions: 0,
  questions: [],
  startedAt: new Date(),
  timeInMinutes: 0,
  modal: false,
  studentId: 0,
});

export default function examSolverReducer($$state = $$initialState, action) {
  const { type, val } = action;
  switch (type) {
    case actionTypes.INCREMENT_CURRENT_QUESTION_INDEX: {
      let questions = $$state.get('questions').toJS();
      if (questions[val.questionIndex].answerProps.answer !== 1) {
        questions[val.questionIndex].answerProps.isAnswered = true;
      } else {
        questions[val.questionIndex].answerProps.isAnswered = false;
      }
      questions[val.questionIndex].answerProps.needReview = false;
      let nextIndex = $$state.get('currentQuestionIndex');
      if (($$state.get('currentQuestionIndex') + 1) < $$state.get('totalQuestions')) {
        nextIndex = $$state.get('currentQuestionIndex') + 1;
      }
      return $$state.set('currentQuestionIndex', nextIndex).set('questions', Immutable.fromJS(questions));
    }
    case actionTypes.ANSWER_QUESTION: {
      let questions = $$state.get('questions').toJS();
      questions[val.questionIndex].answerProps.answer = val.answerIndex;
      return $$state.set('questions', Immutable.fromJS(questions));
    }
    case actionTypes.CLEAR_ANSWER: {
      let questions = $$state.get('questions').toJS();
      questions[val.questionIndex].answerProps.answer = 1;
      questions[val.questionIndex].answerProps.isAnswered = false;
      return $$state.set('questions', Immutable.fromJS(questions));
    }
    case actionTypes.JUMP_TO_QUESTION: {
      return $$state.set('currentQuestionIndex', val.questionIndex);
    }
    case actionTypes.MARK_FOR_REVIEW: {
      let questions = $$state.get('questions').toJS();
      questions[val.questionIndex].answerProps.needReview = true;
      let nextIndex = $$state.get('currentQuestionIndex');
      if (($$state.get('currentQuestionIndex') + 1) < $$state.get('totalQuestions')) {
        nextIndex = $$state.get('currentQuestionIndex') + 1;
      }
      return $$state.set('currentQuestionIndex', nextIndex).set('questions', Immutable.fromJS(questions));
    }
    case actionTypes.MARK_VISITED: {
      let questions = $$state.get('questions').toJS();
      questions[val.questionIndex].answerProps.visited = true;
      return $$state.set('questions', Immutable.fromJS(questions));
    }
    case actionTypes.LOAD_EXAM_DATA: {
      return $$state.set('questions', Immutable.fromJS(val.questions))
                    .set('currentQuestionIndex', val.currentQuestionIndex)
                    .set('startedAt', val.startedAt)
                    .set('totalQuestions', val.totalQuestions)
                    .set('studentId', val.studentId)
                    .set('timeInMinutes', val.timeInMinutes);
    }
    case actionTypes.SHOW_TIME_UP_MODAL:
      return $$state.set('modal', val);
    default:
      return $$state;
  }
}
