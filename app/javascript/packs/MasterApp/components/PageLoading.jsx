import React from 'react';
import PropTypes from 'prop-types';
import LoadingAnimation from './LoadingAnimation';

// Handler page loading animation and page load failed
const PageLoading = ({ isLoading, pastDelay, error }) => {
    if (isLoading && pastDelay) {
        return (
            <LoadingAnimation msg="Loading All Exam data, Please wait, This May take some time."/>
        );
    } else if (error && !isLoading) {
        return <p>Error!</p>;
    }
    return null;
};

PageLoading.propTypes = {
    isLoading: PropTypes.bool.isRequired,
    pastDelay: PropTypes.bool.isRequired,
    error: PropTypes.bool,
};

export default PageLoading;
