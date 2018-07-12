import React from 'react';
import { render } from 'react-dom';
import ExamContainer from "../components/ExamContainer";

document.addEventListener('DOMContentLoaded', () => {
  const container = document.body.appendChild(document.createElement('div'));
  render(<ExamContainer/>, container);
});
