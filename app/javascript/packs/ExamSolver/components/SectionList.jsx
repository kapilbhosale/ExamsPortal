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
                  <li role="presentation" className="active"><a href="#">Home</a></li>
                </ul>
              </div>
            </div>
        );
    }
}

export default ShellList;

