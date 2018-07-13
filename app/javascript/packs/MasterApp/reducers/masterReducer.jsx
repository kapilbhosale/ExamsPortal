import Immutable from 'immutable';

import actionTypes from '../constants/masterAppConstants';

export const $$initialState = Immutable.fromJS({
  nextPathName: '/profile',
  nextState: {},
});

export default function masterReducer($$state = $$initialState, action) {
  const { type, val } = action;
  switch (type) {
    case actionTypes.UPDATE_NEXTPATH:
      return $$state.set('nextPathName', val);
    case actionTypes.UPDATE_NEXTSTATE:
      return $$state.set('nextState', val);
    default:
      return $$state;
  }
}
