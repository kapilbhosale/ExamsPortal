import React from 'react';

class Question extends React.Component {

  render() {
    const { title, options, currentQuestionIndex, answerQuestion, answerProps, cssStyle} = this.props;
    const onMultiSelectAnswerChanged = (value) => {
      let answer = answerProps.answer;
      if (answer === null) {
        answerQuestion(currentQuestionIndex, [value]);
      } else {
        if ( answer.indexOf(value) === -1) {
          answer.push(value)
          answerQuestion(currentQuestionIndex, answer);
        } else {
          answerQuestion(currentQuestionIndex, answer.filter(function(val, index, arr){ return val != value }));
        }
      }
    }

    const renderMultiSelectOptions = () => {
      return (
        options.map((option, idx) => {
          return (
            <div key={idx} className="radio">
              <label>
                <input
                  type="checkbox"
                  value={ option.id }
                  checked={ isOptionSelected(option.id) }
                  onChange={ (e) => { onMultiSelectAnswerChanged(parseInt(e.target.value)) } }
                />
                <div dangerouslySetInnerHTML={{ __html: option.data }} />
              </label>
            </div>
          )
        })
      );
    }

    const isOptionSelected = (optionId) => {
      console.log('checked==== '+findAnswer(optionId));
      return findAnswer(optionId);
    }

    const findAnswer = (optionId) => {
      if (answerProps.answer === null) {
        return false;
      } else if (answerProps.answer.indexOf(optionId) === -1) {
        return false;
      }
      return true;
    }

    const renderSingleSelectOptions = () => {
      return (
        options.map((option, idx) => {
          return (
            <div key={idx} className="radio">
              <label>
                <input
                  type="radio"
                  value={ option.id }
                  checked={ isOptionSelected(option.id) }
                  onChange={ (e) => { answerQuestion(currentQuestionIndex, [parseInt(e.target.value)]) } }
                />
                <div dangerouslySetInnerHTML={{ __html: option.data }} />
              </label>
            </div>
          )
        })
      )
    }

    const renderInputOption = () => {
      return(
        <div>
          <input
            type="text"
            value={ answerProps.answer !== null ? answerProps.answer.join() : null }
            onChange={ (e) => { answerQuestion(currentQuestionIndex, [e.target.value]) } }
          />
        </div>
      );
    }

    const renderOptions = () => {
      const type = "input";
      if ( type === "singleSelect") {
        return (renderSingleSelectOptions());
      } else if (type === "multiSelect") {
        return (renderMultiSelectOptions());
      } else if (type === "input") {
        return (renderInputOption());
      }

    }
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
              renderOptions()
            }

          </div>
        </div>
      </div>
    );
  }
}

export default Question;

