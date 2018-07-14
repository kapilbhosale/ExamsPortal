import React from 'react';

class ShellRight extends React.Component {
  render() {
    const { questions, totalQuestions, jumpToQuestion, currentQuestionIndex } = this.props;
    return (
      <div className="col-md-3" style={{ backgroundColor: '#e7f9ff' }}>
        <div className="panel" style={{ backgroundColor: '#e7f9ff', marginTop: '15px', border: 'none' }}>
          <div className="form-group">
            <span className="label label-success" style={{ margin: '5px' }}>Answered</span>
            <span className="label label-danger" style={{ margin: '5px' }}>Not answered</span>
            <span className="label label-primary" style={{ margin: '5px' }}>Marked</span>
            <span className="label label-default" style={{ margin: '5px' }}>Not visited</span>
          </div>

          <div className="form-group">
            <label>Section</label>: Physics
          </div>

          <div className="btn-toolbar form-group" role="toolbar" aria-label="..." style={{ textAlign: "center" }}>
            {
              questions.map((question, idx) => {
                const { isAnswered, needReview, visited } = question.answerProps;
                let dynamicClass = '';
                if (idx !== currentQuestionIndex) {
                  if (isAnswered) {
                    dynamicClass = 'btn-success';
                  }
                  if (visited && !isAnswered) {
                    dynamicClass = 'btn-danger';
                  }
                  if (needReview) {
                    dynamicClass = 'btn-primary';
                  }
                } else {
                  dynamicClass = "btn-warning"
                }
                return (
                  <button
                    key={idx}
                    type="button"
                    className={ `btn btn-default ${dynamicClass}` }
                    style={{ marginRight: '10px', marginLeft: '5px', marginBottom: '10px', width: '40px', height: '40px' }}
                    onClick={ () => { jumpToQuestion(idx) }}
                  >
                    {idx + 1}
                  </button>
                )
              })
            }
          </div>
          <div className="text-center">
            <button type="button" className="btn btn-success" >Submit Test</button>
          </div>
        </div>
      </div>
    );
  }
}

export default ShellRight;
