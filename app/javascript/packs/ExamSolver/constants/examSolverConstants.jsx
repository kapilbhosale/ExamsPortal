import mirrorCreator from 'mirror-creator';

const actionTypes = mirrorCreator([
  'INCREMENT_CURRENT_QUESTION_INDEX',
  'ANSWER_QUESTION',
  'CLEAR_ANSWER',
  'JUMP_TO_QUESTION',
  'MARK_FOR_REVIEW',
  'MARK_VISITED',
  'SUBMIT_TEST',
]);

export default actionTypes;
