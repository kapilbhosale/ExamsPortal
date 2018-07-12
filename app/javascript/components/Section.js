import React from 'react';

export default class Section extends React.Component {
  render() {
    return (
      <div className="col-lg-12">
        <div className="col-lg-1">
          <label>Section</label>
        </div>
        <div className="col-lg-11">
          <ul className="nav nav-pills">
            <li role="presentation" className="active"><a href="#">Home</a></li>
            <li role="presentation"><a href="#">Profile</a></li>
            <li role="presentation"><a href="#">Messages</a></li>
          </ul>
        </div>
      </div>
    );
  }
}
