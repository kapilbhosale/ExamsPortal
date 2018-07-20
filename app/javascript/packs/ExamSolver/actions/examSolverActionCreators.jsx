import actionTypes from '../constants/examSolverConstants';

export function saveAndNext(questionIndex) {
  return (dispatch, getState) => {
    dispatch(markVisit(questionIndex));
    dispatch({
      type: actionTypes.INCREMENT_CURRENT_QUESTION_INDEX,
      val: { questionIndex: questionIndex },
    });
  };
}

export function answerQuestion(questionIndex, answerIndex) {
  return (dispatch, getState) => {
    dispatch(markVisit(questionIndex));
    dispatch({
      type: actionTypes.ANSWER_QUESTION,
      val: { questionIndex: questionIndex, answerIndex: answerIndex },
    });
  };
}


export function clearAnswer(questionIndex) {
  return (dispatch, getState) => {
    dispatch(markVisit(questionIndex));
    dispatch({
      type: actionTypes.CLEAR_ANSWER,
      val: { questionIndex: questionIndex },
    });
  };
}


export function jumpToQuestion(questionIndex) {
  return (dispatch, getState) => {
    dispatch(markVisit(questionIndex));
    dispatch({
      type: actionTypes.JUMP_TO_QUESTION,
      val: { questionIndex: questionIndex },
    });
  };
}

export function markForReview(questionIndex) {
  return (dispatch, getState) => {
    dispatch(markVisit(questionIndex));
    dispatch({
      type: actionTypes.MARK_FOR_REVIEW,
      val: { questionIndex: questionIndex },
    });
  };
}

export function markVisited(questionIndex) {
  return (dispatch, getState) => {
    dispatch(markVisit(questionIndex));
  };
}

function markVisit(questionIndex) {
  return {
    type: actionTypes.MARK_VISITED,
    val: { questionIndex: questionIndex },
  }
}


export function submitTest() {
  return (dispatch, getState) => {
    window.location = '/students/summary'
    // dispatch({
    //   type: actionTypes.SUBMIT_TEST,
    //   val: {},
    // });
  };
}

export function initialize() {
  return (dispatch, getState) => {
    $.ajax({
      url: '/students/exam_data',
      method: 'get',
      data: {id: window.location.href },
      success: (data) => {
        dispatch({ type: actionTypes.LOAD_EXAM_DATA, val: data})
      }
    });
  };
}
