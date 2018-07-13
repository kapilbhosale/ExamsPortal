import React from 'react';
import SectionList from './SectionList'
import Question from './Question'

class ShellLeft extends React.Component {
  render() {
    return (
      <div className="col-md-9">
        <SectionList />
        <hr/>
        <Question
          title="A constructor is called when"
          options={ [ 'An object is declared', 'A class is declared', 'An object is used', 'A class is used', 'None of these'] }
          sequence={1}
        />
        <hr />

        <div className="row">

          <div className="col-md-10">
            <button type="button" className="btn btn-primary">
              Mark for Review & Next
            </button>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <button type="button" className="btn btn-primary">
              Clear Response
            </button>
          </div>

          <div className="col-md-2">
            <button type="button" className="btn btn-success">
              Save & Next
            </button>
          </div>

        </div>

      </div>
    );
  }
}

export default ShellLeft;
