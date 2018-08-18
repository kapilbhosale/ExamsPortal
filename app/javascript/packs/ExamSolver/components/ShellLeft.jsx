import React from 'react';
import SectionList from './SectionList'
import Question from './Question'

class ShellLeft extends React.Component {

  currentQuestion() {
    const  { currentQuestionIndex, questions } = this.props;
    return questions[currentQuestionIndex];
  }

  render() {
    const { questions, currentQuestionIndex, saveAndNext, answerQuestion, clearAnswer, markForReview, markVisited,
            submitTest, previousQuestion, startedAt, examFinished, timeInMinutes, timeIsUp, currentSection,
            sections, changeSection, isNavigationMapOpen, currentTime } = this.props;
    return (
      <div className={`${isNavigationMapOpen ? 'col-md-9' : 'full-width'}`}>
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
