import Immutable from 'immutable';
import actionTypes from '../constants/examSolverConstants';

export const $$initialState = Immutable.fromJS({

});

export default function examSolverReducer($$state = $$initialState, action) {
    const { type, val } = action;
    switch (type) {
        default:
            return $$state;
    }
}
