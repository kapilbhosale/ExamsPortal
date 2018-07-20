import Immutable from 'immutable';
import actionTypes from '../constants/examSolverConstants';

export const $$initialState = Immutable.fromJS({
  currentQuestionIndex: 0,
  totalQuestions: 13,
  questions: [{
    title: '<ol class="c4 lst-kix_t3gzkgsex1j8-0 start" start="1"><li class="c2 c3"><span class="c1 c0">Which of the following is not correct statement for periodic classification of elements? &nbsp;</span></li></ol>',
    options: [
      '<p class="c2"><span class="c1 c0">The properties of elements are the periodic functions of their atomic number.</span></p>',
      '<p class="c2"><span class="c1 c0">Non &ndash; metallic elements are less in number than metallic elements.</span></p>',
      '<p class="c2"><span class="c1 c0">The first ionization energies of elements along a period do not vary in regular manner with increase in atomic number.</span></p>',
      '<p class="c2"><span class="c1 c0">For transition elements, the last electron enters into (n &ndash; 2) d &ndash; subshell.</span></p>'],
    answerProps: {
      isAnswered: false,
      visited: true,
      needReview: false,
      answer: 1
    }
  },{ // 2
    title: '<ol class="c4 lst-kix_z66j5kez7t2d-0 start" start="2"><li class="c2 c3"><span class="c1 c0">A sudden large jump between the values of second and third ionization energies of an element would be associated with which of the following electronic configuration? &nbsp; </span></li></ol>',
    options: [
      '<p class="c2"><span class="c0"></span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 111.00px; height: 24.00px;"><img alt="" src="assets/images_exam_1/image18.png" style="width: 111.00px; height: 24.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span><span class="c6">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>',
      '<p class="c2"><span class="c0"></span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 111.00px; height: 24.00px;"><img alt="" src="assets/images_exam_1/image21.png" style="width: 111.00px; height: 24.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span></p>',
      '<p class="c2"><span class="c0"></span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 88.00px; height: 24.00px;"><img alt="" src="assets/images_exam_1/image7.png" style="width: 88.00px; height: 24.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span><span class="c6">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>',
      '<p class="c2"><span class="c0"></span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 96.00px; height: 24.00px;"><img alt="" src="assets/images_exam_1/image13.png" style="width: 96.00px; height: 24.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span></p>'],
    answerProps: {
      isAnswered: false,
      visited: false,
      needReview: false,
      answer: 1
    }
  },{ // 3
    title: '<ol class="c4 lst-kix_ghjdfzl651et-0 start" start="3"><li class="c2 c3"><span class="c1 c0">Which one of the following groupings represents a collection of isoelectronic species? &nbsp;(At. Nos .: Cs &ndash; 55, Br &ndash; 35)</span></li></ol>',
    options: [
      '<p class="c2"><span class="c0"></span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 103.00px; height: 24.00px;"><img alt="" src="assets/images_exam_1/image23.png" style="width: 103.00px; height: 24.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span><span class="c7">&nbsp;</span><span class="c1 c0">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>',
      '<p class="c2"><span class="c0"> </span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 79.00px; height: 23.00px;"><img alt="" src="assets/images_exam_1/image2.png" style="width: 79.00px; height: 23.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span></p>',
      '<p class="c2"><span class="c0"> </span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 72.00px; height: 23.00px;"><img alt="" src="assets/images_exam_1/image17.png" style="width: 72.00px; height: 23.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span><span class="c1 c0">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>',
      '<p class="c2"><span class="c0"> </span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 83.00px; height: 23.00px;"><img alt="" src="assets/images_exam_1/image14.png" style="width: 83.00px; height: 23.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span></p>'
    ],
    answerProps: {
      isAnswered: false,
      visited: false,
      needReview: false,
      answer: 1
    }
  },{ // 4
    title: '<ol class="c4 lst-kix_ytqu4jrtcbsv-0 start" start="4"><li class="c2 c3"><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 22.97px; height: 20.00px;"><img alt="" src="assets/images_exam_1/image4.png" style="width: 22.97px; height: 20.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span><span class="c0">&nbsp;and </span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 24.00px; height: 21.00px;"><img alt="" src="assets/images_exam_1/image1.png" style="width: 24.00px; height: 21.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span><span class="c1 c0">&nbsp;ions are isoelectronic. Which of the statements is not correct? &nbsp; </span></li></ol>',
    options: [
      '<p class="c2"><span class="c0"> Both </span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 23.00px; height: 20.00px;"><img alt="" src="assets/images_exam_1/image4.png" style="width: 23.00px; height: 20.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span><span class="c0">&nbsp;and </span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 24.00px; height: 21.00px;"><img alt="" src="assets/images_exam_1/image1.png" style="width: 24.00px; height: 21.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span><span class="c1 c0">&nbsp;ions contain 18 electrons.</span></p>',
      '<p class="c2"><span class="c0"> Both </span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 23.00px; height: 20.00px;"><img alt="" src="assets/images_exam_1/image4.png" style="width: 23.00px; height: 20.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span><span class="c0">&nbsp;and </span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 24.00px; height: 21.00px;"><img alt="" src="assets/images_exam_1/image1.png" style="width: 24.00px; height: 21.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span><span class="c1 c0">&nbsp;ions have same configuration.</span></p>',
      '<p class="c2"><span class="c0"> </span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 23.00px; height: 20.00px;"><img alt="" src="assets/images_exam_1/image4.png" style="width: 23.00px; height: 20.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span><span class="c0">&nbsp;ion is bigger than </span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 24.00px; height: 21.00px;"><img alt="" src="assets/images_exam_1/image1.png" style="width: 24.00px; height: 21.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span><span class="c1 c0">&nbsp;ion is ionic size.</span></p>',
      '<p class="c2"><span class="c0"> </span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 24.00px; height: 21.00px;"><img alt="" src="assets/images_exam_1/image1.png" style="width: 24.00px; height: 21.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span><span class="c0">&nbsp;ion is bigger than </span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 23.00px; height: 20.00px;"><img alt="" src="assets/images_exam_1/image4.png" style="width: 23.00px; height: 20.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span><span class="c1 c0">&nbsp;ion in size.</span></p>'
    ],
    answerProps: {
      isAnswered: false,
      visited: false,
      needReview: false,
      answer: 1
    }
  },{ // 5
    title: '<ol class="c4 lst-kix_f5lbk9pt02k3-0 start" start="5"><li class="c2 c3"><span class="c1 c0">Which of the following statements regarding the variation of atomic radii in the periodic table is not true?</span></li></ol>',
    options: [
      '<p class="c2"><span class="c1 c0"> In a group, there is continuous increase in size with increase in atomic number.</span></p>',
      '<p class="c2"><span class="c1 c0"> In 4f &ndash; series, there is a continuous decrease in size with increase in atomic number.</span></p>',
      '<p class="c2"><span class="c1 c0"> the size of inert gases is larger than halogens.</span></p>',
      '<p class="c2"><span class="c0"> In 3</span><span class="c0 c8">rd</span><span class="c1 c0">&nbsp;period, the size of atoms increases with increase in atomic number.</span></p>'
    ],
    answerProps: {
      isAnswered: false,
      visited: false,
      needReview: false,
      answer: 1
    }
  },{ // 6
    title: '<ol class="c4 lst-kix_16jwsyg2bo35-0 start" start="6"><li class="c2 c3"><span class="c1 c0">Which of the following is not a periodic property for the elements? </span></li></ol>',
    options: [
      '<p class="c2"><span class="c1 c0"> Electronegativity&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>',
      '<p class="c2"><span class="c1 c0"> Atomic size</span></p>',
      '<p class="c2"><span class="c1 c0"> Occurrence in nature&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>',
      '<p class="c2"><span class="c1 c0"> Ionization energy</span></p>'
    ],
    answerProps: {
      isAnswered: false,
      visited: false,
      needReview: false,
      answer: 1
    }
  },{ // 7
    title: '<ol class="c4 lst-kix_lrbu2hc8h017-0 start" start="7"><li class="c2 c3"><span class="c1 c0">Which of the following statements is true about the variation of density of elements in the periodic table? </span></li></ol>',
    options: [
      '<p class="c2"><span class="c1 c0"> In a period from left to right density first increases upto the middle and then strts decreasing.</span></p>',
      '<p class="c2"><span class="c1 c0"> In a group on moving down the density decreases from top to bottom.</span></p>',
      '<p class="c2"><span class="c1 c0"> A less closely packed solid has higher density.</span></p>',
      '<p class="c2"><span class="c1 c0"> Density of elements is not a periodic property.</span></p>'
    ],
    answerProps: {
      isAnswered: false,
      visited: false,
      needReview: false,
      answer: 1
    }
  },{ // 8
    title: '<ol class="c4 lst-kix_5ltos5434750-0 start" start="8"><li class="c2 c3"><span class="c1 c0">The correct order of acidic character of oxides in third period of periodic table is &nbsp;</span></li></ol>',
    options: [
      '<p class="c2"><span class="c0"> </span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 171.00px; height: 21.00px;"><img alt="" src="assets/images_exam_1/image16.png" style="width: 171.00px; height: 21.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span></p>',
      '<p class="c2"><span class="c0"> </span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 171.00px; height: 21.00px;"><img alt="" src="assets/images_exam_1/image15.png" style="width: 171.00px; height: 21.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span></p>',
      '<p class="c2"><span class="c0"> </span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 171.00px; height: 21.00px;"><img alt="" src="assets/images_exam_1/image20.png" style="width: 171.00px; height: 21.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span></p>',
      '<p class="c2"><span class="c0"> </span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 171.00px; height: 21.00px;"><img alt="" src="assets/images_exam_1/image11.png" style="width: 171.00px; height: 21.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span></p>'
    ],
    answerProps: {
      isAnswered: false,
      visited: false,
      needReview: false,
      answer: 1
    }
  },{ // 9
    title: '<ol class="c4 lst-kix_39wbwk7b1djn-0 start" start="9"><li class="c2 c3"><span class="c0">Consider the isoelectronic species, </span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 88.00px; height: 24.00px;"><img alt="" src="assets/images_exam_1/image22.png" style="width: 88.00px; height: 24.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span><span class="c0">&nbsp;and </span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 27.00px; height: 21.00px;"><img alt="" src="assets/images_exam_1/image24.png" style="width: 27.00px; height: 21.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span><span class="c0 c1">&nbsp;the correct order of increasing length of their radii is.</span></li></ol>',
    options: [
      '<p class="c2"><span class="c0"> </span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 119.00px; height: 20.00px;"><img alt="" src="assets/images_exam_1/image9.png" style="width: 119.00px; height: 20.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span><span class="c6">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>',
      '<p class="c2"><span class="c0"> </span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 131.00px; height: 22.00px;"><img alt="" src="assets/images_exam_1/image6.png" style="width: 131.00px; height: 22.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span></p>',
      '<p class="c2"><span class="c0"> </span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 125.00px; height: 21.00px;"><img alt="" src="assets/images_exam_1/image5.png" style="width: 125.00px; height: 21.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span><span class="c6">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>',
      '<p class="c2"><span class="c0"> </span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 132.00px; height: 22.00px;"><img alt="" src="assets/images_exam_1/image8.png" style="width: 132.00px; height: 22.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span></p>'
    ],
    answerProps: {
      isAnswered: false,
      visited: false,
      needReview: false,
      answer: 1
    }
  },{ // 10
    title: '<ol class="c4 lst-kix_8bnlqh6lso62-0 start" start="10"><li class="c2 c3"><span class="c1 c0">The first ionization enthalpies of Na, Mg, Al and Si are in the order.</span></li></ol>',
    options: [
      '<p class="c2"><span class="c1 c0"> &nbsp;Na &lt; Mg &gt; Al &lt; Si&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>',
      '<p class="c2"><span class="c1 c0"> Na &gt; Mg &gt; Al &gt; Si</span></p>',
      '<p class="c2"><span class="c1 c0"> Na &lt; Mg &lt; Al &lt; Si&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></p>',
      '<p class="c2"><span class="c1 c0"> Na &gt; Mg&gt; Al &lt; Si</span></p>'
    ],
    answerProps: {
      isAnswered: false,
      visited: false,
      needReview: false,
      answer: 1
    }
  },{ // 11
    title: '<ol class="c4 lst-kix_psjm00bsbse0-0 start" start="22"><li class="c2 c3"><span class="c1 c0">Part of the periodic table showing p &ndash; block is depicted below. What are the elements shown in thezig &ndash; zag boxes called? What is the nature of the elements outside this boundary on the right side of the table?</span></li></ol><p class="c9"><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 76.00px; height: 73.00px;"><img alt="C:\\Documents and Settings\\DEV\\Local Settings\\Temporary Internet Files\\Content.Word\\3-46.bmp" src="assets/images_exam_1/image10.png" style="width: 76.00px; height: 73.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span></p>',
    options: [
      '<p class="c2"><span class="c1 c0"> Metalloids, non &ndash; metals</span></p>',
      '<p class="c2"><span class="c1 c0"> Transition elements, metalloids</span></p>',
      '<p class="c2"><span class="c1 c0"> Metals, non &ndash; metals</span></p>',
      '<p class="c2"><span class="c1 c0"> Non &ndash; metals, noble gases</span></p>'
    ],
    answerProps: {
      isAnswered: false,
      visited: false,
      needReview: false,
      answer: 1
    }
  },{ // 12
    title: '<ol class="c4 lst-kix_mpfdnljw2ui-0 start" start="28"><li class="c2 c3"><span class="c1 c0">What are the two radii shown as &lsquo;a&rsquo; and &lsquo;b&rsquo; in the figure known as? &nbsp;</span></li></ol><p class="c9"><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 126.00px; height: 60.00px;"><img alt="C:\\Documents and Settings\\DEV\\Local Settings\\Temporary Internet Files\\Content.Word\\3-50.bmp" src="assets/images_exam_1/image19.png" style="width: 126.00px; height: 60.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span></p>',
    options: [
      '<p class="c2"><span class="c1 c0"> a = Atomic radius, b = Molecular radius</span></p>',
      '<p class="c2"><span class="c1 c0"> a = Covalent radius, b = van der Waals&rsquo; radius</span></p>',
      '<p class="c2"><span class="c1 c0"> a = Ionic radius, b = Covalent radius</span></p>',
      '<p class="c2"><span class="c1 c0"> a = Covalent radius, b = Atomic radius</span></p>'
    ],
    answerProps: {
      isAnswered: false,
      visited: false,
      needReview: false,
      answer: 1
    }
  },{ // 13
    title: '<ol class="c4 lst-kix_avs0v18voip7-0 start" start="30"><li class="c2 c3"><span class="c1 c0">In the given graph, a periodic property &reg; is plotted against atomic numbers (Z) of the lements. Which property is shown in the graph and how is it correlated with reactivity of the elements? &nbsp;</span></li></ol><p class="c9"><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 124.00px; height: 98.00px;"><img alt="C:\\Documents and Settings\\DEV\\Local Settings\\Temporary Internet Files\\Content.Word\\3-51.bmp" src="assets/images_exam_1/image12.png" style="width: 124.00px; height: 98.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span></p>',
    options: [
      '<p class="c2"><span class="c0"> Ionisation enthalpy in a group, reactivity dectreases from a</span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 19.00px; height: 15.00px;"><img alt="" src="assets/images_exam_1/image3.png" style="width: 19.00px; height: 15.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span><span class="c1 c0">&nbsp;e.</span></p>',
      '<p class="c2"><span class="c0"> Ionisation enthalpy in a group, reactivity increases from a </span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 19.00px; height: 15.00px;"><img alt="" src="assets/images_exam_1/image3.png" style="width: 19.00px; height: 15.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span><span class="c1 c0">&nbsp;e.</span></p>',
      '<p class="c2"><span class="c0"> Atomic radius in a group, reactivity decreases from &nbsp;a</span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 19.00px; height: 15.00px;"><img alt="" src="assets/images_exam_1/image3.png" style="width: 19.00px; height: 15.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span><span class="c1 c0">&nbsp;e.</span></p>',
      '<p class="c2"><span class="c0"> Metallic character in a group, reactivity increases from a</span><span style="overflow: hidden; display: inline-block; margin: 0.00px 0.00px; border: 0.00px solid #000000; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px); width: 19.00px; height: 15.00px;"><img alt="" src="assets/images_exam_1/image3.png" style="width: 19.00px; height: 15.00px; margin-left: 0.00px; margin-top: 0.00px; transform: rotate(0.00rad) translateZ(0px); -webkit-transform: rotate(0.00rad) translateZ(0px);" title=""></span><span class="c1 c0">e</span></p>'
    ],
    answerProps: {
      isAnswered: false,
      visited: false,
      needReview: false,
      answer: 1
    }
  }
  ],
});

export default function examSolverReducer($$state = $$initialState, action) {
  const { type, val } = action;
  switch (type) {
    case actionTypes.INCREMENT_CURRENT_QUESTION_INDEX: {
      let questions = $$state.get('questions').toJS();
      if (questions[val.questionIndex].answerProps.answer !== 1) {
        questions[val.questionIndex].answerProps.isAnswered = true;
      } else {
        questions[val.questionIndex].answerProps.isAnswered = false;
      }
      let nextIndex = $$state.get('currentQuestionIndex');
      if (($$state.get('currentQuestionIndex') + 1) < $$state.get('totalQuestions')) {
        nextIndex = $$state.get('currentQuestionIndex') + 1;
      }
      return $$state.set('currentQuestionIndex', nextIndex).set('questions', Immutable.fromJS(questions));
    }
    case actionTypes.ANSWER_QUESTION: {
      let questions = $$state.get('questions').toJS();
      questions[val.questionIndex].answerProps.answer = val.answerIndex;
      return $$state.set('questions', Immutable.fromJS(questions));
    }
    case actionTypes.CLEAR_ANSWER: {
      let questions = $$state.get('questions').toJS();
      questions[val.questionIndex].answerProps.answer = 1;
      questions[val.questionIndex].answerProps.isAnswered = false;
      return $$state.set('questions', Immutable.fromJS(questions));
    }
    case actionTypes.JUMP_TO_QUESTION: {
      return $$state.set('currentQuestionIndex', val.questionIndex);
    }
    case actionTypes.MARK_FOR_REVIEW: {
      let questions = $$state.get('questions').toJS();
      questions[val.questionIndex].answerProps.needReview = true;
      let nextIndex = $$state.get('currentQuestionIndex');
      if (($$state.get('currentQuestionIndex') + 1) < $$state.get('totalQuestions')) {
        nextIndex = $$state.get('currentQuestionIndex') + 1;
      }
      return $$state.set('currentQuestionIndex', nextIndex).set('questions', Immutable.fromJS(questions));
    }
    case actionTypes.MARK_VISITED: {
      let questions = $$state.get('questions').toJS();
      questions[val.questionIndex].answerProps.visited = true;
      return $$state.set('questions', Immutable.fromJS(questions));
    }
    case actionTypes.LOAD_EXAM_DATA: {
      return $$state.set('questions', Immutable.fromJS(val.questions)).set('currentQuestionIndex', val.currentQuestionIndex);
    }
    default:
      return $$state;
  }
}
