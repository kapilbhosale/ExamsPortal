import PropTypes from 'prop-types';
import React, { Component } from 'react';
import Modal from 'react-modal';

export default class TestSubmitModal extends React.Component {
  static propTypes = {
    cancelHandler: PropTypes.func.isRequired,
    sectionWiseSummary: PropTypes.object,
    submitTest: PropTypes.func.isRequired,
  };

  constructor(props) {
    super(props);
  }

  render() {
    const {
      cancelHandler,
      sectionWiseSummary,
      submitTest,
    } = this.props;

    const customStyles = {
      overlay: {
        zIndex: 10,
      },
      content: {
        width: '50%',
        top: '35%',
        left: '50%',
        right: 'auto',
        bottom: 'auto',
        marginRight: '-50%',
        transform: 'translate(-50%, -50%)',
      },
    };

    const showTestSummary = () => {
      const summary = this.props.sectionWiseSummary;
      debugger
    }

    const renderTableHeaders = () => {
      const headersNames = ['Section Name', 'Answered', 'Not Answered'];
      const tableHeaders = headersNames.map((headersName) => {
        return (
          <th key={ `${headersName}` }>
            { `${ headersName }` }
          </th>
        );
      });
      return (
        <thead>
          <tr>
            { tableHeaders }
          </tr>
        </thead>
      );
    }

    const renderTableBody = () => {
      const summary = this.props.sectionWiseSummary;
      let tableDataRows = [];
      let totalAnswered = 0, totalNotAnswered = 0;
      this.props.sectionWiseSummary.map((answerProps, section_name) => {
        totalAnswered = totalAnswered + answerProps.get('answered');
        totalNotAnswered = totalNotAnswered + answerProps.get('notAnswered');
        tableDataRows.push(
          <tr key={ `data_row_${ section_name }` }>
            <td> { section_name } </td>
            <td> { answerProps.get('answered') } </td>
            <td> { answerProps.get('notAnswered') } </td>
          </tr>
        );
      });
      tableDataRows.push(
        <tr key={ `data_row_total` }>
          <td> { 'Total' } </td>
          <td> { totalAnswered } </td>
          <td> { totalNotAnswered } </td>
        </tr>
      )
      return (
        <tbody>
          { tableDataRows }
        </tbody>
      );
    }

    return (
      <Modal isOpen={ true } contentLabel='Close Call' style={ customStyles }>
        <div className='padding-bottom-10 margin-left-30'>
          <h1 className='text-red text-center'> Submit Exam </h1>
        </div>
        <div className='row'>
          <div className='col-md-12'>
            <div className="container">
              <table className='table table-bordered'>
                { renderTableHeaders() }
                { renderTableBody() }
              </table>
            </div>
          </div>
        </div>
        <div className='row'>
          Still, do you want to submit exam?
        </div>
        <div className='text-center'>
          <button className='btn btn-info' onClick={ this.props.cancelHandler }>
            Cancel
          </button>
          &nbsp;
          <button
            className='btn btn-danger'
             onClick={ () => { submitTest() } }
          >
            Submit Test
          </button>
        </div>
      </Modal>
    );
  }
}
