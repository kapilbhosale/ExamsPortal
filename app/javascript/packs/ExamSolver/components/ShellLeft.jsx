import React from 'react';
import SectionList from './SectionList'
import Question from './Question'

class ShellLeft extends React.Component {
  render() {
    const { questions, currentQuestionIndex, saveAndNext, answerQuestion, clearAnswer, markForReview, markVisited, jumpToQuestion } = this.props;
    const currentQuestion = questions[currentQuestionIndex];
    return (
      <div className="col-md-9">
        <SectionList totalQuestions={questions.length} />
        <hr/>
        <Question
          { ...currentQuestion }
          currentQuestionIndex={currentQuestionIndex}
          answerQuestion={ answerQuestion }
          markVisited={ markVisited }
          />
        <hr />

        <div className="row">

          <div className="col-md-8">
            <button type="button" className="btn btn-primary" onClick={ () => { markForReview(currentQuestionIndex) }}>
              Mark for Review & Next
            </button>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <button type="button" className="btn btn-primary" onClick={ () => { clearAnswer(currentQuestionIndex) }}>
              Clear Response
            </button>
          </div>

          <div className="col-md-4">
            <button type="button" className="btn btn-primary" onClick={ () => { jumpToQuestion(currentQuestionIndex - 1) }}>
              Previous
            </button>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <button type="button" className="btn btn-success" onClick={ () => { saveAndNext(currentQuestionIndex) }}>
              Save & Next
            </button>
          </div>

        </div>

      </div>
    );
  }
}

export default ShellLeft;
