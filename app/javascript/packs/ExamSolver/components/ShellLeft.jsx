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
            submitTest, previousQuestion } = this.props;
    return (
      <div className="col-md-7 col-sm-6 col-xs-12">
        <SectionList totalQuestions={questions.length} submitTest={submitTest} />
        <hr/>
        <div className='row'>
          <Question
            { ...this.currentQuestion() }
            currentQuestionIndex={currentQuestionIndex}
            answerQuestion={ answerQuestion }
            markVisited={ markVisited }
            />
        </div>

      </div>
    );
  }
}

export default ShellLeft;
