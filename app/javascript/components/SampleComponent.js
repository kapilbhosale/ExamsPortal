import React from 'react';
import QuizFooterComponent from  './QuizFooterComponent';

export default class SampleComponent extends React.Component {
  render() {
    return (
      <div>
        <h1>Hi, I'm SampleComponent!</h1>
        <QuizFooterComponent />
      </div>
  );
  }
}
