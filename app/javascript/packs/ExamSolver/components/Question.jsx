import React from 'react';

class Question extends React.Component {
  render() {
    const { sequence, title, options } = this.props;
    return (
      <div className="row">

        <div className="row">
          <div className="col-lg-12">
            <b>Question No: {sequence}</b>
          </div>
        </div>

        <br />

        <div className="row">
          <div className="col-lg-12">
            <b>{title}</b>
          </div>
        </div>

        <div className="row">
          <div className="col-lg-12">

            {
              options.map((option, idx) => {
                return (
                  <div key={idx} className="radio">
                    <label>
                      <input
                        type="radio"
                        value={option}
                        checked={idx === 1}
                        onChange={ () => { } }
                      />
                      { option }
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

