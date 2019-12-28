import React from 'react';
import SectionList from './SectionList'
import Question from './Question'

class ShellLeft extends React.Component {

  currentQuestion() {
    const  { currentQuestionIndex, questions } = this.props;
    return questions[currentQuestionIndex];
  }

  render() {
    const { questions, currentQuestionIndex, answerQuestion, markVisited,
            submitTest, startedAt, examFinished, timeInMinutes, timeIsUp, currentSection,
            sections, changeSection, isNavigationMapOpen, currentTime, remainingTimeAlert,
            timeLeftMessage, syncWithBackend } = this.props;
    return (
      <div className={`${isNavigationMapOpen ? 'question-div col-md-9' : 'question-div full-width'}`}>
        <div className='row'>
          <div className='col-md-12'>
            <SectionList
              totalQuestions={questions.length}
              submitTest={submitTest}
              startedAt={startedAt}
              examFinished={ examFinished }
              timeInMinutes={ timeInMinutes }
              timeIsUp={ timeIsUp }
              sections={sections}
              currentSection={currentSection}
              changeSection={changeSection}
              currentTime={ currentTime }
              remainingTimeAlert={ remainingTimeAlert }
              timeLeftMessage={  timeLeftMessage }
              syncWithBackend={ syncWithBackend }
            />
          </div>
          <div className="col-md-12">
            {
              this.currentQuestion() && <Question
                { ...this.currentQuestion() }
                currentQuestionIndex={currentQuestionIndex}
                answerQuestion={ answerQuestion }
                markVisited={ markVisited }
              />
            }
          </div>
        </div>
      </div>
    );
  }
}

export default ShellLeft;
