import React from 'react';

class ShellRight extends React.Component {
  render() {
    return (
      <div className="col-md-3" style={{ backgroundColor: '#e7f9ff' }}>
        <div className="panel" style={{ backgroundColor: '#e7f9ff', marginTop: '15px' }}>
          <div className="form-group">
            <span className="label label-success" style={{ margin: '5px' }}>Answered</span>
            <span className="label label-danger" style={{ margin: '5px' }}>Not answered</span>
            <span className="label label-primary" style={{ margin: '5px' }}>Marked</span>
            <span className="label label-default" style={{ margin: '5px' }}>Not visited</span>
          </div>

          <div className="form-group">
            <label>Section</label>: Physics
          </div>

          <div className="btn-toolbar" role="toolbar" aria-label="...">
            {
              [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50].map((number, idx) => {
                return (
                  <button
                    key={idx}
                    type="button"
                    className="btn btn-default"
                    style={{ marginRight: '5px', marginLeft: '5px', marginBottom: '10px', width: '40px', height: '40px' }}
                  >
                    {number}
                  </button>
                )
              })
            }
          </div>
        </div>
      </div>
    );
  }
}

export default ShellRight;
