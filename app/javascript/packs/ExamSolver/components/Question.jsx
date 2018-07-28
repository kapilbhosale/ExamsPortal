import React from 'react';

class Question extends React.Component {

  render() {
    const { title, options, currentQuestionIndex, answerQuestion, answerProps, cssStyle} = this.props;
    return (
      <div>
        <style>
          { cssStyle }
        </style>
        <div className="row">
          <div className="col-md-12">
            <b>Question No: { currentQuestionIndex + 1 }</b>
          </div>
        </div>

        <br />

        <div className="row">
          <div className="col-md-12" style={{ fontSize: '20px'}}>
            <p dangerouslySetInnerHTML={{ __html: title}} />
          </div>
        </div>

        <br/>

        <div className="row">
          <div className="col-md-12">

            {
              options.map((option, idx) => {
                return (
                  <div key={idx} className="radio">
                    <label>
                      <input
                        type="radio"
                        value={ option.id }
                        checked={ parseInt(answerProps.answer) === option.id }
                        onChange={ (e) => { answerQuestion(currentQuestionIndex, e.target.value) } }
                      />
                      <div dangerouslySetInnerHTML={{ __html: option.data }} />
                    </label>
                  </div>
                )
              })
            }

          </div>
        </div>
      </div>
    );
  }
}

export default Question;

