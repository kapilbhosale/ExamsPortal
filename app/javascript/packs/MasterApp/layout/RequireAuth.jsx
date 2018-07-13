import React, { Component } from 'react';
import PropTypes from 'prop-types';
import { withRouter } from 'react-router';
import { includes } from 'lodash';

class RequireAuth extends Component {
  static propTypes = {
    children: PropTypes.object.isRequired,
    permission: PropTypes.string.isRequired,
    allPermissions: PropTypes.object.isRequired,
  };

  componentWillMount() {
    const { permission, allPermissions, location } = this.props;

    if (!includes(allPermissions, permission)) {
      // navigate away, no permission
    }
  }

  render() {
    return (
      <div>
        {this.props.children}
      </div>
    );
  }
}

export default withRouter(RequireAuth);
