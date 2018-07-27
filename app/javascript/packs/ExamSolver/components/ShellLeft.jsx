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
      <div className="col-md-9 col-sm-12 col-xs-12">
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
        <div className="row">
          <div className='col-md-11 col-sm-10 col-xs-7'>
            <button
              type="button"
              className="btn btn-primary margin-t-b-10"
              onClick={ () => { markForReview(currentQuestionIndex) }}
            >
              Mark for Review & Next
            </button>
            <button
              type="button"
              className="btn btn-primary margin-t-b-10"
              onClick={ () => { clearAnswer(currentQuestionIndex) }}
            >
              Clear Response
            </button>
            <button
              type="button"
              className="btn btn-primary margin-t-b-10"
              onClick={ () => { previousQuestion(currentQuestionIndex) }}
            >
              Previous
            </button>
            <button
              type="button"
              className="btn btn-success margin-t-b-10"
              onClick={ () => { saveAndNext(currentQuestionIndex) }}
            >
              Save & Next
            </button>
          </div>
          <div className='col-md-1 col-sm-2 col-xs-5' id='navigation-map-toggler'>
            <button
              type="button"
              className="btn btn-info"
              data-toggle="collapse"
              data-target="#navigation-map"
            >
              Map
            </button>
          </div>
        </div>

      </div>
    );
  }
}

export default ShellLeft;
