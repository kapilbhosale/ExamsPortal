import window from 'global';
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
      
        dispatch({type: actionTypes.SET_CURRENT_TIME, val: data.time });
      },
      error: (data) => {
        console.log("==============  Error : ");
      },
    });
  };
}

export function updateExamSummary(examID) {
  return (dispatch, getState) => {
    const store = getState().$$examSolverStore;
    let localData = localStorage.getItem(`${store.get('studentId')}-${store.get('examId')}-store`);
    const localSAData = JSON.parse(localData)

    localData = localStorage.getItem(`model-ans-${store.get('examId')}`);
    const localModelAnsData = JSON.parse(localData)
    const resultSummary = {}
    if(localSAData && localModelAnsData) {
      localSAData.sections.forEach((section) => {
        let ans = 0;
        let correct = 0;
        let wrong = 0;
        let score = 0;
        let count = 0;
        let section_out_of_marks = 0;
        let input_questions_present = false;
        let correct_input_questions = 0;
        let incorrect_input_questions = 0;
        localSAData.questionsBySections[section].forEach((question) => {
          let modelAns = localModelAnsData.questions[question.id];
          if (question.answerProps.answer) {
            if ( modelAns.type === 'input') {
              input_questions_present = true
              if ( modelAns.ans === parseFloat(parseFloat(question.answerProps.answer[0]).toFixed(2)) ) {
                correct_input_questions++;
                score += modelAns.pm;
              } else {
                incorrect_input_questions++;
              }
            } else {
              if (modelAns.ans === question.answerProps.answer[0]) {
                correct++;
                score += modelAns.pm;
              } else {
                wrong++;
                score += modelAns.nm;
              }
            }
            ans++;
          }
          count++;
          section_out_of_marks += modelAns.pm;
        })
        resultSummary[section] = {
          ans,
          correct,
          wrong,
          score,
          count,
          section_out_of_marks,
          input_questions_present,
          correct_input_questions,
          incorrect_input_questions
        }
      })
    }
    dispatch({ type: actionTypes.SET_EXAM_SUMMARY, val: resultSummary });
  }
};

// submitTest()
// backend_call => store result success: true|false
// <ResultSummary studentId, examId />
export function submitTest() {
  return (dispatch, getState) => {
    dispatch(loading(true));
    const store = getState().$$examSolverStore;
    const studentKey = `${store.get('studentId')}-${store.get('examId')}-store`
    const dataJSON = parseLocalStorageDataForSync(studentKey)

    const localModelAns = localStorage.getItem(`model-ans-${store.get('examId')}`);

    if (localModelAns && !JSON.parse(localModelAns).jee_advance) {
      $.ajax({
        url: '/students/submit/' + store.get('examId'),
        method: 'put',
        data: { id: store.get('examId'), questions: dataJSON },
      });
      dispatch(updateExamSummary(store.get('examId')));
    } else {
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
    }
  };


// Bad piece of code. Don't try to blame. You're responsible.
// export function submitTest() {
//   return (dispatch, getState) => {
//     dispatch(loading(true));
//     const store = getState().$$examSolverStore;
//     const studentKey = `${store.get('studentId')}-${store.get('examId')}-store`
//     const dataJSON = parseLocalStorageDataForSync(studentKey)
//     $.ajax({
//       url: '/students/submit/' + store.get('examId'),
//       method: 'put',
//       data: { id: store.get('examId'), questions: dataJSON },
//       success: (data) => {
//         window.location = '/students/summary/' + store.get('examId');
//       },
//       error: (data) => {
//         console.log('error sync!');
//         dispatch(loading(false));
//         alert('Error submitting exam');
//       },
//     });
//   };
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
export function updateTimeSpentOnQuestion(questionIndex, timeSpent, section) {
  return (dispatch, getState) => {
    // const store = getState().$$examSolverStore;
    // const currentSection = store.get('currentSection');
    // const currentQuestionIndex = store.get('currentQuestionIndex').toJS();
    // const questionIndex = currentQuestionIndex[currentSection];
    dispatch({
      type: actionTypes.UPDATE_TIME_SPENT_ON_QUESTION,
      val: { questionIndex: questionIndex, timeSpent: timeSpent, section: section},
    });
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
  const modelAns = data.model_ans;
  //  store modelAns data in local storage
  localStorage.setItem(`model-ans-${JSON.parse(modelAns).exam_id}`, modelAns);

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

export function isExamValid() {
  return (dispatch, getState) => {
    const store = getState().$$examSolverStore;
    $.ajax({
      url: `/students/is_exam_valid?t=${new Date().getTime()}`,
      method: 'get',
      data: { id: store.get('examId') },
      success: (data) => {
        if( data.error) {
          window.location = '/students/tests';
        }
      }
    });
  }
};

export function initialize() {
  return (dispatch, getState) => {
    const store = getState().$$examSolverStore;
    const studentId = store.get('studId');
    const localData = localStorage.getItem(`${studentId}-${store.get('examId')}-store`);

    dispatch(loading(true));
    if (localData) {
      dispatch({ type: actionTypes.LOAD_EXAM_DATA, val: JSON.parse(localData) });
      const questionCounts = JSON.parse(localData).questionsCountByStatus;
      dispatch(updateQuestionsCount(questionCounts));
      dispatch(loading(false));
      return;
    }

    let student_ans = null;
    let time_data = null;
    let s3_url = null;
    $.ajax({
      type: 'GET',
      url: '/students/exam_data_s3',
      dataType: 'json',
      data: { id: store.get('examId') },
      success: (data) => {
        student_ans = data.student_ans
        time_data = data.time_data
        s3_url = data.s3_url

        $.ajax({
          type: 'GET',
          url: s3_url,
          dataType: 'json',
          crossDomain: true,
          success: (data) => {
            const preparedData = {
              student_ans: student_ans,
              time_data: time_data,
              questions: data.questions,
              model_ans: data.model_ans,
            }
            processExamData(preparedData, store, dispatch);
          }
        }).fail(function() {
          $.ajax({
            type: 'GET',
            url: '/students/exam_data',
            dataType: 'json',
            data: { id: store.get('examId') },
            success: (data) => {
              processExamData(data, store, dispatch);
            }
          })
        });
        // data processing ends here.
      }
    })
  };
}

function processExamData(data, store, dispatch) {
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