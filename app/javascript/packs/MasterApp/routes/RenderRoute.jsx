import React, { Component } from 'react';
import PropTypes from 'prop-types';
import { Route } from 'react-router-dom';
import { withRouter } from 'react-router';
import RequireAuth from '../layout/RequireAuth';
import ExamSolverApp from "../../ExamSolver/startup/ExamSolverApp";

// This is where the magic happens
// Every view has a initial state
// The initial state is loaded via API instead of React on Rails
// This HOC sends the API requests and shows a loading animation till initial
// state is loaded.
class RenderRoute extends Component {
  constructor(props) {
    super(props);
    this.state = this.initialData();
  }

  componentWillReceiveProps(nextProps) {
    // If a new route has been pushed via React Router,
    // get new initial state.
    if (this.props.location !== nextProps.location) {
      this.setState(this.initialData());
      const {
        initialStateRoute,
        api,
        get,
        location,
      } = nextProps;
      this.getNewData(initialStateRoute, api, get, location);
    }
  }

  componentWillMount() {
    const {
      initialStateRoute,
      api,
      get,
      location,
    } = this.props;
    this.getNewData(initialStateRoute, api, get, location);
  }

  initialData() {
    return {
      loading: false,
      data: null,
      error: false,
      status_code: -1,
      message: '',
    };
  }

  getNewData(initialStateRoute, api, get, location) {
    if (initialStateRoute) {
      this.setState({ loading: true });
      let url;
      if (api) {
        url = `/api/v1/initial_states/${ initialStateRoute }`;
      } else {
        url = initialStateRoute;
      }
      if (location.search) {
        url += location.search;
      }
      $.ajax({
        url,
        type: get ? 'GET' : 'POST',
        contentType: 'application/json; charset=utf-8',
        dataType: 'json',
      }).done(data => {
        this.setState({ data, loading: false });
      }).fail((jqXHR, exception) => {
        this.setState({ error: true, loading: false });
        if (jqXHR.responseJSON && jqXHR.responseJSON.redirect_to) {
          window.location = jqXHR.responseJSON.redirect_to;
        } else if (jqXHR.status === 0) {
          this.setState({ message: 'Not connected.\n Verify Network.' });
        } else if (jqXHR.status === 401 || jqXHR.status === 500 || jqXHR.status === 404 || jqXHR.status === 403) {
          this.setState({ message: jqXHR.responseJSON.message, status: jqXHR.status });
        } else if (exception === 'parsererror') {
          this.setState({ message: 'Requested JSON parse failed.', status: 0 });
        } else if (exception === 'timeout') {
          this.setState({ message: 'Time out error.', status: 0 });
        } else if (exception === 'abort') {
          this.setState({ message: 'Request aborted.', status: 0 });
        } else {
          this.setState({ message: `Uncaught Error.\n${ jqXHR.responseText }`, status: jqXHR.status });
        }
      });
    }
  }

  render() {
    const {
      component: Component,
      parent: ParentComponent,
      permissionRequired,
      permission,
      allPermissions,
      globalState,
      initialStateRoute,
      ...rest
    } = this.props;

    if ((initialStateRoute && this.state.data) || !initialStateRoute) {
      return (
        <Route
          { ...rest }
          render={
            (props) => {
              const renderChildren = () => {
                return (
                  <Component
                    { ...props }
                    { ...rest }
                    { ...globalState }
                    { ...this.state.data }
                  />
                );
              };
              const renderComponents = () => {
                if (ParentComponent) {
                  return (
                    <ParentComponent>
                      {renderChildren()}
                    </ParentComponent>
                  );
                }
                return renderChildren();
              };
              if (permissionRequired) {
                return (
                  <RequireAuth permission={ permission } allPermissions={ allPermissions }>
                    {renderComponents()}
                  </RequireAuth>
                );
              }
              return renderComponents();
            }
          }
        />
      );
    }

    return <div />;
  }
}

RenderRoute.propTypes = {
  component: PropTypes.oneOfType([
    PropTypes.element,
    PropTypes.func,
  ]),
  parent: PropTypes.oneOfType([
    PropTypes.element,
    PropTypes.func,
  ]),
  permissionRequired: PropTypes.bool,
  api: PropTypes.bool,
  get: PropTypes.bool,
  permission: PropTypes.string,
  initialStateRoute: PropTypes.string,
  allPermissions: PropTypes.object,
  globalState: PropTypes.object,
};

export default withRouter(RenderRoute);
