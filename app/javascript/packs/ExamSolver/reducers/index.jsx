// This file is our manifest of all reducers for the app.
// A real world app will likely have many reducers and it helps to organize them in one file.
import examSolverReducer from './examSolverReducer';
import { $$initialState as $$examSolverState} from './examSolverReducer';

export default {
    $$examSolverStore: examSolverReducer,
};

export const initialStates = {
    $$examSolverState,
};
