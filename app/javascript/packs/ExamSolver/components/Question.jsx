import React from 'react';

class Question extends React.Component {

  render() {
    const { title, options, currentQuestionIndex, answerQuestion, answerProps, cssStyle, question_type} = this.props;
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
            <div key={idx} className="radio text-indent-0">
              <label>
                <input
                  type="checkbox"
                  value={ option.id }
                  checked={ isOptionSelected(option.id) }
                  onChange={ (e) => { onMultiSelectAnswerChanged(parseInt(e.target.value)) } }
                />
                <div className='display-inline padding-left-10' dangerouslySetInnerHTML={{ __html: option.data }} />
              </label>
            </div>
          )
        })
      );
    }

    const isOptionSelected = (optionId) => {
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
            <div key={idx} className="radio text-indent-0">
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

    const inputTypeValue = () => {
      if (answerProps.answer !== null) {
        console.log('input value--->'+answerProps.answer.join());
        return answerProps.answer.join();
      }
      return '';
    }

    const renderInputOption = () => {
      return(
        <div className='text-indent-0'>
          <input
            type="text"
            value={ inputTypeValue() }
            onChange={ (e) => { answerQuestion(currentQuestionIndex, [e.target.value]) } }
          />
          <span className='text-muted text-medium'> Write answers upto 2 precisions.</span>
        </div>
      );
    }

    const renderOptions = () => {
      if ( question_type === "single_select") {
        return (renderSingleSelectOptions());
      } else if (question_type === "multi_select") {
        return (renderMultiSelectOptions());
      } else if (question_type === "input") {
        return (renderInputOption());
      }

    }
    return (
      <div>
        <div className="row">
          <div className="col-md-12">
            <span class="badge badge-secondary">
              Question No: &nbsp; <b>{ currentQuestionIndex + 1 }</b>
            </span>
          </div>
        </div>
        <br />
        <div className="row question-text-div">
          <div className="col-md-12" style={{ fontSize: '20px'}}>
            <div className='text-indent-0' dangerouslySetInnerHTML={{ __html: title}} />
          </div>
        </div>


        <div className="row options-div">
          <div className="col-md-12" style={{ fontSize: '20px'}}>
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

