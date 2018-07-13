import Immutable from 'immutable';
import actionTypes from '../constants/examSolverConstants';

export const $$initialState = Immutable.fromJS({
  currentQuestion: 1,
  totalQuestions: 30,
  questions: [{
    title: 'What is your name?',
    options: ['Akshay', 'Abhay', 'Kapil', 'Deepak'],
    answerProps: {
      isAnswered: false,
      viewed: false,
      needReview: false,
      answer: 1
    }
  },{
    title: 'Some other question name?',
    options: ['sadsadkshay', 'Asdsdbhay', 'sd', 'sd'],
    answerProps: {
      isAnswered: false,
      viewed: false,
      needReview: false,
      answer: 1
    }
  }],
});

export default function examSolverReducer($$state = $$initialState, action) {
    const { type, val } = action;
    switch (type) {
        default:
            return $$state;
    }
}
