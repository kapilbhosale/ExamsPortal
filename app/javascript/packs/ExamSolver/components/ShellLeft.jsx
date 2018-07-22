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
      <div className="col-md-9">
        <SectionList totalQuestions={questions.length} submitTest={submitTest} />
        <hr/>
        <Question
          { ...this.currentQuestion() }
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
            <button type="button" className="btn btn-primary" onClick={ () => { previousQuestion(currentQuestionIndex) }}>
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
