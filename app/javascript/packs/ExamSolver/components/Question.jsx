import React from 'react';

class Question extends React.Component {

  render() {
    const $win = $(window);
    const {
      title, options, currentQuestionIndex, answerQuestion,
      answerProps, question_type, is_image, inputAnsweredQuestions,
      examType,
    } = this.props;

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
                <div>
                  {
                    getOptionData(option.is_image, option.data)
                  }
                </div>
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
            <div key={idx} className={`radio text-indent-0 ${isOptionSelected(option.id) ? 'question-selected' : ''}`} style={{padding: '5px'}}>
              <label>
                <input
                  type="radio"
                  value={ option.id }
                  checked={ isOptionSelected(option.id) }
                  onChange={ (e) => { answerQuestion(currentQuestionIndex, [parseInt(e.target.value)]) } }
                  style={{marginTop: '8px'}}
                />
                <div>
                  {
                    getOptionData(option.is_image, option.data)
                  }
                </div>
              </label>
            </div>
          )
        })
      )
    }

    const inputTypeValue = () => {
      if (answerProps.answer !== null) {
        return answerProps.answer.join();
      }
      return '';
    }

    const renderInputOption = () => {
      const inputAnsCount = parseInt(inputAnsweredQuestions);
      return(
        <div className='text-indent-0 padding-top-20'>
          <input
            type="text"
            value={ inputTypeValue() }
            disabled= { inputAnsCount >= 5 && !inputTypeValue()}
            onChange={ (e) => { answerQuestion(currentQuestionIndex, [e.target.value]) } }
          />
          { inputAnsweredQuestions && inputAnsCount >= 5 ? (
            <span className='text-danger text-small'> Maximum 5 Input can be answered, please clear if you want to solve this.</span>
          ) : (
            <span className='text-muted text-medium'> Write answers up to 2 precisions only.</span>
          )}
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

    const getOptionData = (is_image, data) => {
      if (is_image) {
        const img_data = `data:image/png;base64,${data}`
        return (<img src={img_data} style={{width: "90%", maxWidth: ($win.width()-20)}} />)
      }
      return(<div dangerouslySetInnerHTML={{ __html: data}} />);
    }

    const getQestionData = () => {
      if (is_image) {
        const img_data = `data:image/png;base64,${title}`
        return (<img src={img_data}  style={{maxWidth: ($win.width()-20)}} />)
      }
      return(<div dangerouslySetInnerHTML={{ __html: title}} />);
    }

    const getSectionHead = (qIndex) => {
      if (qIndex <= 35) {
        return(
          <div>
            <span style={{fontWeight: 'bold'}}>
              Section A
            </span>
            <br></br>
            <div style={{marginTop: '-10px'}}>
              <span style={{fontSize: 12, fontWeight: '400'}}>
                Total questions: 35, Solve all.
              </span>
            </div>
          </div>
        )
      }

      return(
        <div>
          <span style={{fontWeight: 'bold'}}>
            Section B
          </span>
          <br></br>
          <div style={{marginTop: '-10px'}}>
            <span style={{fontSize: 12, fontWeight: '400'}}>
              Total questions: 15, Solve only 10. You solved <span> 1/10</span>
            </span>
          </div>
        </div>
      )
    }

    return (
      <div>
        {examType === 'neet' && (
          <div className="row" style={{padding: '2px 0px', marginTop: '1px', backgroundColor: 'lightblue'}}>
          <div className="col-md-12">
            {getSectionHead(currentQuestionIndex + 1)}
          </div>
        </div>
        )}
        <div className="row">
          <div className="col-md-12">
            <span className="badge badge-secondary">
              Question No: &nbsp; <b>{ currentQuestionIndex + 1 }</b>
            </span>
          </div>
        </div>
        <br />
        <div className="row question-text-div">
          <div className="col-md-12" style={{ fontSize: '20px'}}>
            <div className='text-indent-0'>
              { getQestionData() }
            </div>
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

