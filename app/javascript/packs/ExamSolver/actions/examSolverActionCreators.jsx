import actionTypes from '../constants/examSolverConstants';

export function saveAndNext(questionIndex) {
  return (dispatch, getState) => {
    dispatch(markVisit(questionIndex));
    dispatch({
      type: actionTypes.INCREMENT_CURRENT_QUESTION_INDEX,
      val: { questionIndex: questionIndex },
    });
    const globalState = getState();
    const { $$examSolverStore } = globalState;
    const store = $$examSolverStore;
    const questions = store.get('questions').toJS();
    const questionsCount = getQuestionsCount(questions);
    dispatch(updateQuestionsCount(questionsCount));
  };
}

export function answerQuestion(questionIndex, answerIndex) {
  return (dispatch, getState) => {
    dispatch(markVisit(questionIndex));
    dispatch({
      type: actionTypes.ANSWER_QUESTION,
      val: { questionIndex: questionIndex, answerIndex: answerIndex },
    });
    const globalState = getState();
    const { $$examSolverStore } = globalState;
    const store = $$examSolverStore;
    const questions = store.get('questions').toJS();
    const questionsCount = getQuestionsCount(questions);
    dispatch(updateQuestionsCount(questionsCount));
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
    const globalState = getState();
    const { $$examSolverStore } = globalState;
    const store = $$examSolverStore;
    const questions = store.get('questions').toJS();
    const questionsCount = getQuestionsCount(questions);
    dispatch(updateQuestionsCount(questionsCount));
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
    const globalState = getState();
    const { $$examSolverStore } = globalState;
    const store = $$examSolverStore;
    const questions = store.get('questions').toJS();
    const questionsCount = getQuestionsCount(questions);
    dispatch(updateQuestionsCount(questionsCount));
  };
}

export function markVisited(questionIndex) {
  return (dispatch, getState) => {
    dispatch(markVisit(questionIndex));
    const globalState = getState();
    const { $$examSolverStore } = globalState;
    const store = $$examSolverStore;
    const questions = store.get('questions').toJS();
    const questionsCount = getQuestionsCount(questions);
    dispatch(updateQuestionsCount(questionsCount));
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
        } else {
          dispatch({ type: actionTypes.LOAD_EXAM_DATA, val: data});
        }
      }
    });
  };
}

export function updateQuestionsCount(questionCounts) {
  console.log('q count =>'+questionCounts);
  return {
    type: actionTypes.UPDATE_QUESTIONS_COUNT,
    val: { questionCounts: questionCounts },
  }
}



  function getQuestionsCount(questions) {
    const notVisited = notVisitedQuestions(questions);
    const answered = answeredQuestions(questions);
    const marked = markedQuestions(questions);
    const notAnswered = questions.length - answered;
    return (
      {
        answered: answered,
        notAnswered: notAnswered,
        marked: marked,
        notVisited: notVisited
      }
    );
  }

function notVisitedQuestions(questions) {
    const notVisited = questions.map((question) => {
      if (!question.answerProps.visited) {
        return 1;
      }
    })
    return notVisited.filter(f => f === 1).length;
  }

  function answeredQuestions(questions) {
    const answered = questions.map((question) => {
      if (question.answerProps.isAnswered) {
        return 1;
      }
    })
    return answered.filter(f => f === 1).length;
  }

  function markedQuestions(questions) {
    const marked = questions.map((question) => {
      if (question.answerProps.needReview) {
        return 1;
      }
    })
    return marked.filter(f => f === 1).length;
  }
