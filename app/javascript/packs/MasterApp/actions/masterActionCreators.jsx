import window from 'global';
import actionTypes from '../constants/masterAppConstants';

export function updateNextPathName(val) {
  return {
    type: actionTypes.UPDATE_NEXTPATH,
    val,
  };
}

export function updateNextState(val) {
  return {
    type: actionTypes.UPDATE_NEXTSTATE,
    val,
  };
}

export function navigateToNextPath() {
  return (dispatch, getState) => {
    const { $$masterStore } = getState();
    const { nextPathName, nextState } = $$masterStore;
    if (nextPathName) {
      dispatch(updateNextPathName(null));
      dispatch(updateNextState({}));
      const location = {
        pathname: nextPathName,
        state: nextState,
      };
      window.rrHistory.push(location);
    } else {
      window.rrHistory.push('/profile');
    }
  };
}

