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
    dispatch(loading(true));
    const store = getState().$$examSolverStore;
    const dataJSON = JSON.parse(localStorage.getItem(`${store.get('studentId')}-${store.get('examId')}-store`));
    $.ajax({
      url: '/students/sync/' + store.get('examId'),
      method: 'put',
      data: { questions: dataJSON.questionsBySections, exam_id: store.get('examId') },
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
      error: (data) => {
        console.log('error sync!');
        dispatch(loading(false));
        alert('Error submitting exam');
      },
    });
  };
}

export function syncAnswers() {
  return (dispatch, getState) => {
    const store = getState().$$examSolverStore;
    localStorage.clear();
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
      data: { questions: dataJSON.questionsBySections, exam_id: store.get('examId') },
      success: (data) => { console.log('success sync!'); },
      error: (data) => { console.log('error sync!'); },
    });
  }
}

export function changeSection(e) {
  return (dispatch, getState) => {
    dispatch({ type: actionTypes.SECTION_CHANGED, val: e.target.text });
  }
}

export function onTick(e) {
  return (dispatch, getState) => {
    // console.log(e);
  }
}

export function loading(val) {
  return {
    type: actionTypes.LOADING,
    val: val
  }
}

export function initialize() {
  return (dispatch, getState) => {
    const store = getState().$$examSolverStore;
    dispatch(loading(true));
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
          dispatch(loading(false));
        } else {
          dispatch({ type: actionTypes.LOAD_EXAM_DATA, val: data});
          let questionCounts = {};
          data.toJS().sections.forEach((section) => {
            questionCounts[section] = {
              answered: 0,
              notAnswered: 0,
              marked: 0,
              notVisited: data.questions ? data.questions.length : 0,
            }
          });
          dispatch(updateQuestionsCount(questionCounts));
          dispatch(loading(false));
        }
      }
    });
  };
}

export function updateQuestionsCount(sectionQuestionsCount) {
  return {
    type: actionTypes.UPDATE_QUESTIONS_COUNT,
    val: sectionQuestionsCount,
  };
}

function getQuestionsCount(state) {
  const { $$examSolverStore } = state;
  const store = $$examSolverStore;
  const currentSection = store.get('currentSection');
  const sections = store.get('questionsBySections')
  let sectionwiseCount = {};
    sections.forEach((questions, section_name) => {
      let notVisited = 0, answered = 0, marked = 0, notAnswered = 0;
      questions.toJS().forEach((question) => {
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
      sectionwiseCount[section_name] = {
        answered: answered,
        notAnswered: notAnswered,
        marked: marked,
        notVisited: notVisited
      };
    })
  return (sectionwiseCount);
}

export function setNavigationMap(value) {
  return {
    type: actionTypes.SET_NAVIGATION_MAP,
    val: value,
  };
}
