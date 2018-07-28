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

export function examFinished() {
  window.location = '/students/summary';
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

export function previousQuestion(questionIndex) {
  return (dispatch, getState) => {
    dispatch(markVisit(questionIndex));
    dispatch({
      type: actionTypes.JUMP_TO_QUESTION,
      val: { questionIndex: questionIndex - 1 },
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
  console.log('submitTest called');
  return (dispatch, getState) => {
    const store = getState().$$examSolverStore;
    $.ajax({
      url: '/students/submit/' + store.get('examId'),
      method: 'get',
      data: { id: store.get('examId') },
      success: (data) => { window.location = '/students/summary/' + store.get('examId'); }
    });
  };
}

export function syncAnswers() {
  return (dispatch, getState) => {
    console.log('sync is called');
    const store = getState().$$examSolverStore;
    console.log(store.get('questions').toJS());
    $.ajax({
      url: '/students/sync/' + store.get('examId'),
      method: 'get',
      data: { questions: store.get('questions').toJS(), exam_id: store.get('examId') },
      success: (data) => { console.log('success sync!'); },
      error: (data) => { console.log('error sync!'); },
    });
  }
}

export function initialize() {
  return (dispatch, getState) => {
    const store = getState().$$examSolverStore;
    $.ajax({
      url: '/students/exam_data',
      method: 'get',
      data: { id: store.get('examId') },
      success: (data) => {
        dispatch({ type: actionTypes.LOAD_EXAM_DATA, val: data})
      }
    });
  };
}
