import actionTypes from '../constants/examSolverConstants';

export function saveAndNext(questionIndex) {
  return (dispatch, getState) => {
    dispatch(markVisit(questionIndex));
    dispatch({
      type: actionTypes.INCREMENT_CURRENT_QUESTION_INDEX,
      val: { questionIndex: questionIndex },
    });
    const questionCounts = getQuestionsCount(getState());
    dispatch(updateQuestionsCount(questionCounts));
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
    const questionCounts = getQuestionsCount(getState());
    dispatch(updateQuestionsCount(questionCounts));
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
    const questionCounts = getQuestionsCount(getState());
    dispatch(updateQuestionsCount(questionCounts));
  };
}

export function markVisited(questionIndex) {
  return (dispatch, getState) => {
    dispatch(markVisit(questionIndex));
    const questionCounts = getQuestionsCount(getState());
    dispatch(updateQuestionsCount(questionCounts));
  };
}

function markVisit(questionIndex) {
  return {
    type: actionTypes.MARK_VISITED,
    val: { questionIndex: questionIndex },
  }
}

// Bad piece of code. Don't try to blame. You're responsible.
export function submitTest() {
  return (dispatch, getState) => {
    const store = getState().$$examSolverStore;
    const dataJSON = JSON.parse(localStorage.getItem(`${store.get('studentId')}-${store.get('examId')}-store`));
    $.ajax({
      url: '/students/sync/' + store.get('examId'),
      method: 'put',
      data: { questions: dataJSON.questions, exam_id: store.get('examId') },
      success: (data) => {
        $.ajax({
          url: '/students/submit/' + store.get('examId'),
          method: 'put',
          data: { id: store.get('examId') },
          success: (data) => {
            window.location = '/students/summary/' + store.get('examId');
          }
        });
      },
      error: (data) => { console.log('error sync!'); },
    });
  };
}

export function syncAnswers() {
  return (dispatch, getState) => {
    const store = getState().$$examSolverStore;
    // console.log(store.get('questions').toJS());
    localStorage.setItem(`${store.get('studentId')}-${store.get('examId')}-store`, JSON.stringify(store.toJS()));
  }
}

export function timeIsUp() {
  // console.log('timeIsUp');
  return (dispatch, getState) => {
    syncWithBackend();
    dispatch({ type: actionTypes.SHOW_TIME_UP_MODAL, val: true });
  }
}

export function syncWithBackend() {
  return (dispatch, getState) => {
    const store = getState().$$examSolverStore;
    const dataJSON = JSON.parse(localStorage.getItem(`${store.get('studentId')}-${store.get('examId')}-store`));
    $.ajax({
      url: '/students/sync/' + store.get('examId'),
      method: 'put',
      async: false,
      data: { questions: dataJSON.questions, exam_id: store.get('examId') },
      success: (data) => { console.log('success sync!'); },
      error: (data) => { console.log('error sync!'); },
    });
  }
}

export function onTick(e) {
  return (dispatch, getState) => {
    // console.log(e);
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
        const localData = localStorage.getItem(`${data.studentId}-${store.get('examId')}-store`);
        if (localData) {
          dispatch({ type: actionTypes.LOAD_EXAM_DATA, val: JSON.parse(localData) });
          const questionCounts = JSON.parse(localData).questionsCountByStatus;
          dispatch(updateQuestionsCount(questionCounts));
        } else {
          dispatch({ type: actionTypes.LOAD_EXAM_DATA, val: data});
          const questionCounts = {
            answered: 0,
            notAnswered: 0,
            marked: 0,
            notVisited: data.questions ? data.questions.length : 0,
          }
          dispatch(updateQuestionsCount(questionCounts));
        }
      }
    });
  };
}

export function updateQuestionsCount(questionCounts) {
  return {
    type: actionTypes.UPDATE_QUESTIONS_COUNT,
    val: { questionCounts: questionCounts },
  };
}


function getQuestionsCount(state) {
  const { $$examSolverStore } = state;
  const store = $$examSolverStore;
  const questions = store.get('questions').toJS();
  let notVisited = 0, answered = 0, marked = 0, notAnswered = 0;
  if (questions.length > 0) {
    questions.map((question) => {
      const answer_props = question.answerProps;
      if (answer_props.visited && !answer_props.isAnswered && !answer_props.needReview) {
        notAnswered = notAnswered + 1;
      }
      if (!answer_props.visited) {
        notVisited = notVisited + 1;
      }
      if (answer_props.isAnswered) {
        answered = answered + 1;
      }
      if (question.answerProps.needReview) {
        marked = marked + 1;
      }
    })
  }
  return (
    {
      answered: answered,
      notAnswered: notAnswered,
      marked: marked,
      notVisited: notVisited
    }
  );
}
