// This file is our manifest of all reducers for the app.
// See also /client/app/bundles/LandingPageSearch/store/searchStore.jsx
// A real world app will likely have many reducers and it helps to organize them in one file.

import masterReducer from './masterReducer';
import { $$initialState as $$masterState } from './masterReducer';

export default {
  $$masterStore: masterReducer,
};

export const initialStates = {
  $$masterState,
};
