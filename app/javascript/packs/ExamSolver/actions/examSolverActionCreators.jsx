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

export function remainingTimeAlert(message) {
  return (dispatch) => {
    dispatch(timeLeft(message));
  };
}

function timeLeft(message) {
  return {
    type: actionTypes.UPDATE_TIME_LEFT,
    val: message,
  }
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

export function getCurrentServerTime() {
  return (dispatch, getState) => {
    $.ajax({
      url: '/current-server-time',
      method: 'get',
      success: (data) => {
        console.log("==============  Current time from server is : " + data.time);
        dispatch({type: actionTypes.SET_CURRENT_TIME, val: data.time }); 
      },
      error: (data) => {
        console.log("==============  Error : ");
      },
    });
  };
}

// Bad piece of code. Don't try to blame. You're responsible.
export function submitTest() {
  return (dispatch, getState) => {
    dispatch(loading(true));
    const store = getState().$$examSolverStore;
    const studentKey = `${store.get('studentId')}-${store.get('examId')}-store`
    const dataJSON = parseLocalStorageDataForSync(studentKey)
    $.ajax({
      url: '/students/submit/' + store.get('examId'),
      method: 'put',
      data: { id: store.get('examId'), questions: dataJSON },
      success: (data) => {
        window.location = '/students/summary/' + store.get('examId');
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
    const studentKey = `${store.get('studentId')}-${store.get('examId')}-store`
    const dataJSON = parseLocalStorageDataForSync(studentKey)
    $.ajax({
      url: '/students/sync/' + store.get('examId'),
      method: 'put',
      async: false,
      data: { questions: dataJSON, exam_id: store.get('examId') },
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

function isStudentAnsEmpty(studentAns) {
  if (studentAns === null) { return true }
  return(Object.keys(studentAns).length === 0 && studentAns.constructor === Object)
}

function formatDataToOldFormat(data) {
  const questionsData = JSON.parse(data.questions);
  const studentAns = data.student_ans;
  const timeData = data.time_data;

  const questionsBySections = {}
  if (isStudentAnsEmpty(studentAns)) {
    const emptyAnswerProps = {isAnswered: false, visited: false, needReview: false, answer: null}
    questionsData.sections.forEach((section) => {
      questionsBySections[section] =
        questionsData.questionsBySections[section].map((question) => {
          return {...question, answerProps: emptyAnswerProps}
        })
    });
  } else {
    questionsData.sections.forEach((section) => {
      questionsBySections[section] =
        questionsData.questionsBySections[section].map((question) => {
          let sAns = studentAns[question.id]
          let answerProps = {
            isAnswered: sAns.question_props['isAnswered'] === 'true',
            visited: sAns.question_props['visited'] === 'true',
            needReview: sAns.question_props['needReview'] === 'true',
            answer: (sAns.option_id ? Array.of(sAns.option_id) : null)
          }
          return {...question, answerProps}
        })
    });
  }
  const formattedData = {
    ...questionsData,
    questionsBySections,
    ...timeData}
  return (formattedData);
}

export function initialize() {
  return (dispatch, getState) => {
    const store = getState().$$examSolverStore;

    //  DEEPAK check this, store.get('studentId') is getting 0. this is problem.
    // const someLocalData = localStorage.getItem(`${store.get('studentId')}-${store.get('examId')}-store`);
    // if (someLocalData) { return }

    dispatch(loading(true));
    $.ajax({
      url: '/students/exam_data',
      method: 'get',
      data: { id: store.get('examId') },
      success: (data) => {
        data = formatDataToOldFormat(data)
        const localData = localStorage.getItem(`${data.studentId}-${store.get('examId')}-store`);
        if (localData) {
          dispatch({ type: actionTypes.LOAD_EXAM_DATA, val: JSON.parse(localData) });
          const questionCounts = JSON.parse(localData).questionsCountByStatus;
          dispatch(updateQuestionsCount(questionCounts));
          dispatch(loading(false));
        } else {
          dispatch({ type: actionTypes.LOAD_EXAM_DATA, val: data});
          let questionCounts = {};
          data.sections.forEach((section) => {
            questionCounts[section] = {
              answered: 0,
              notAnswered: 0,
              marked: 0,
              notVisited: data.questionsBySections[section] ? data.questionsBySections[section].length : 0,
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
    sectionwiseCount[section_name] = questionsCountByCategory(questions.toJS());
  })
  return (sectionwiseCount);
}

function questionsCountByCategory(questions) {
  let notVisited = 0, answered = 0, marked = 0, notAnswered = 0;
  questions.forEach((question) => {
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
  return(
    {
      answered: answered,
      notAnswered: notAnswered,
      marked: marked,
      notVisited: notVisited
    }
  )
}

export function setNavigationMap(value) {
  return {
    type: actionTypes.SET_NAVIGATION_MAP,
    val: value,
  };
}

export function toggleTestSubmitModal(value) {
  return {
    type: actionTypes.TOGGLE_TEST_SUBMIT_MODAL,
    val: value,
  };
}

function parseLocalStorageDataForSync(studentKey) {
  const dataJSON = JSON.parse(localStorage.getItem(studentKey)).questionsBySections;
  let questionsBySections = { }
  Object.keys(dataJSON).forEach((key) => {
    const questions = dataJSON[`${key}`].map((data, index) => {
      return { id: data.id, answerProps: data.answerProps }
    });
    questionsBySections[key] = questions;
  });
  return questionsBySections;
}
