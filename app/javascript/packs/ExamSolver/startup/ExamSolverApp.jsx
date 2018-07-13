import React, { Component } from 'react';
import { Provider } from 'react-redux';

import createStore from '../store/examSolverStore';
import ExamSolverContainer from '../containers/ExamSolverContainer';

class ExamSolverApp extends Component {
    constructor(props) {
        super(props);
        this.store = createStore(props);
    }
    render() {
        return (
            <Provider store={ this.store }>
                <ExamSolverContainer />
            </Provider>
        );
    }
}
export default ExamSolverApp;
