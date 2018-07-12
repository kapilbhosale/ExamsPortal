import React from 'react';
import ExamLeft from "./ExamLeft";
import ExamRight from "./ExamRight";

export default class ExamContainer extends React.Component {
  render() {
    return (
      <div className="container">
        <ExamLeft />
        <ExamRight />
      </div>
    );
  }
}
