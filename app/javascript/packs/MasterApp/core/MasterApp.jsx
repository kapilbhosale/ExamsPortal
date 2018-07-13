import React from 'react';
import ReactOnRails from 'react-on-rails';
import { Provider } from 'react-redux';
import ReactDOM from 'react-dom';
import { BrowserRouter } from 'react-router-dom';
import MasterRoutes from '../routes/routes';
import createStore from '../store/masterStore';

// See documentation for https://github.com/reactjs/react-redux.
// This is how you get props from the Rails view into the redux store.
// This code here binds your smart component to the redux store.
// railsContext provides contextual information especially useful for server rendering, such as
// knowing the locale. See the React on Rails documentation for more info on the railsContext
const MasterApp = (props, railsContext, domNodeId) => {
  const store = createStore(props);
  const reactComponent = (
    <Provider store={ store }>
      <BrowserRouter basename={ props.root_path }>
        <MasterRoutes />
      </BrowserRouter>
    </Provider>
  );
  ReactDOM.render(reactComponent, document.getElementById("react-element"));
};

ReactOnRails.register({ MasterApp });
// export default MasterApp;
