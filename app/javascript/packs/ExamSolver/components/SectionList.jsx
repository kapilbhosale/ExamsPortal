import React from 'react';

class ShellList extends React.Component {
    render() {
        return (
          <div className="row">
              <div className="col-md-1" style={{ paddingTop: '10px' }}>
                <label style={{ display: "inline" }}>Sections</label>
              </div>
              <div className="col-md-11">
                <ul className="nav nav-pills">
                  <li role="presentation" className="active"><a href="#">Physics</a></li>
                  <li role="presentation"><a href="#">Chemistry</a></li>
                  <li role="presentation"><a href="#">Mathematics</a></li>
                  <li role="presentation"><a href="#">Biology</a></li>
                </ul>
              </div>
            </div>
        );
    }
}

export default ShellList;

