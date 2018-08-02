import React from 'react';

class ShellRight extends React.Component {
  render() {
    const { 
      questions,
      totalQuestions,
      jumpToQuestion,
      currentQuestionIndex,
      submitTest,
      answeredQuestions,
      notAnsweredQuestions,
      markedQuestions,
      notVisitedQuestions } = this.props;
    const closeNav = () => {
      document.getElementById("mySidenav").style.width = "0";
      document.getElementById("mySidenav").style.paddingLeft = 0;
    }

    return (
      <div >
        <div className='navigation-map'>
          <div className='sidenav panel' id="mySidenav">
            <a href="javascript:void(0)" className="closebtn pull-left" onClick={ () => { closeNav() }}>&times;</a>
            <div className="row form-group">

              <div className='col-md-5 col-sm-4 col-xs-4'>
                <span className="label label-success margin-5">
                  { `Answered (${answeredQuestions})` }
                </span>
              </div>
              <div className='col-md-5 col-sm-4 col-xs-4'>
                <span className="label label-primary margin-5">
                  { `Marked (${markedQuestions})` }
                </span>
              </div>
              <div className='col-md-5 col-sm-4 col-xs-4'>
                <span className="label label-default margin-5">
                  { `Not visited (${notVisitedQuestions})`}
                </span>
              </div>
              <div className='col-md-5 col-sm-4 col-xs-4'>
                <span className="label label-warning margin-5">
                  Current
                </span>
              </div>
              <div className='col-md-5 col-sm-4 col-xs-4'>
                <span className="label label-danger margin-5">
                  { `Not answered (${notAnsweredQuestions})` }
                </span>
              </div>
            </div>

            <div className="form-group text-center">
              Navigation Map
            </div>

            <div className="btn-toolbar form-group text-center" role="toolbar" aria-label="...">
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
              <button type="button" className="btn btn-success" onClick={ () => { submitTest() }}>
                Submit Test
              </button>
            </div>
          </div>
        </div>
      </div>
    );
  }
}

export default ShellRight;
