import Immutable from 'immutable';
import actionTypes from '../constants/examSolverConstants';

export const $$initialState = Immutable.fromJS({
  currentQuestion: 1,
  totalQuestions: 30,
  questions: [{
    title: '<ol class="c4 lst-kix_t3gzkgsex1j8-0 start" start="1"><li class="c2 c3"><span class="c1 c0">Which of the following is not correct statement for periodic classification of elements? &nbsp;</span></li></ol>',
    options: [
      '<p class="c2"><span class="c1 c0">(a) The properties of elements are the periodic functions of their atomic number.</span></p>',
      '<p class="c2"><span class="c1 c0">(b) Non &ndash; metallic elements are less in number than metallic elements.</span></p>',
      '<p class="c2"><span class="c1 c0">(c) The first ionization energies of elements along a period do not vary in regular manner with increase in atomic number.</span></p>',
      '<p class="c2"><span class="c1 c0">(d) For transition elements, the last electron enters into (n &ndash; 2) d &ndash; subshell.</span></p>'],
    answerProps: {
      isAnswered: false,
      viewed: false,
      needReview: false,
      answer: 1
    }
  },{
    title: '<ol class="c4 lst-kix_z66j5kez7t2d-0 start" start="2"><li class="c2 c3"><span class="c1 c0">A sudden large jump between the values of second and third ionization energies of an element would be associated with which of the following electronic configuration? &nbsp; </span></li></ol>',
    options: [
      '<p class="c2"><span class="c0">(a) </span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 111.00px; height: 24.00px;"><img alt="" src="images/image18.png" style="width: 111.00px; height: 24.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span><span class="c6">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>',
      '<p class="c2"><span class="c0">(b) </span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 111.00px; height: 24.00px;"><img alt="" src="images/image21.png" style="width: 111.00px; height: 24.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span></p>',
      '<p class="c2"><span class="c0">(c) </span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 88.00px; height: 24.00px;"><img alt="" src="images/image7.png" style="width: 88.00px; height: 24.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span><span class="c6">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>',
      '<p class="c2"><span class="c0">(d) </span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 96.00px; height: 24.00px;"><img alt="" src="images/image13.png" style="width: 96.00px; height: 24.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span></p>'],
    answerProps: {
      isAnswered: false,
      viewed: false,
      needReview: false,
      answer: 1
    }
  }],
});

export default function examSolverReducer($$state = $$initialState, action) {
    const { type, val } = action;
    switch (type) {
        default:
            return $$state;
    }
}
