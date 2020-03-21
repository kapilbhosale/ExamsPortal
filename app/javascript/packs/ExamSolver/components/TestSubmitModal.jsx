import PropTypes from 'prop-types';
import React, { Component } from 'react';
import Modal from 'react-modal';

export default class TestSubmitModal extends React.Component {
  static propTypes = {
    cancelHandler: PropTypes.func.isRequired,
    sectionWiseSummary: PropTypes.object,
    submitTest: PropTypes.func.isRequired,
    isTestSubmitModalOpen: PropTypes.bool.isRequired,
  };

  render() {
    const {
      cancelHandler,
      sectionWiseSummary,
      submitTest,
      isTestSubmitModalOpen,
    } = this.props;

    const $win = $(window);
    const MEDIAQUERY = {
      desktopXL: 1200,
      desktop: 992,
      tablet: 768,
      mobile: 575,
    };
    const mobileDevice = $win.width() < MEDIAQUERY.mobile

    const customStyles = {
      overlay: {
        zIndex: 102,
      },
      content: {
        width: (mobileDevice ? '100%': '50%'),
        top: (mobileDevice ? '35%': '35%'),
        left: (mobileDevice ? '50%': '50%'),
        right: 'auto',
        bottom: 'auto',
        marginRight: (mobileDevice ? '0%': '-50%'),
        transform: 'translate(-50%, -50%)',
      },
    };

    const renderTableHeaders = () => {
      const headersNames = ['Section Name', 'Answered', 'Not Answered'];
      const tableHeaders = headersNames.map((headersName) => {
        return (
          <th key={ headersName }>
            { headersName }
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
      let totalAnswered = 0;
      let totalNotAnswered = 0;
      this.props.sectionWiseSummary.map((answerProps, section_name) => {
        totalAnswered = totalAnswered + answerProps.get('answered');
        const notAnswered = answerProps.get('notAnswered') + answerProps.get('marked') + answerProps.get('notVisited')
        totalNotAnswered = totalNotAnswered + notAnswered;
        tableDataRows.push(
          <tr key={ `data_row_${ section_name }` }>
            <td> { section_name } </td>
            <td className='text-center'> { answerProps.get('answered') } </td>
            <td className='text-center'> { notAnswered } </td>
          </tr>
        );
      });
      tableDataRows.push(
        <tr>
          <td className='text-right'> { 'Total' } </td>
          <td className='text-center'> { totalAnswered } </td>
          <td className='text-center'> { totalNotAnswered } </td>
        </tr>
      )
      return (
        <tbody>
          { tableDataRows }
        </tbody>
      );
    }

    return (
      isTestSubmitModalOpen ?
        <Modal isOpen={ true } contentLabel='Close Call' style={ customStyles }>
          <div>
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
            <div className='col-md-12'>
              Exam submitted once can not be undone. Still, do you want to submit exam?
            </div>
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
        :
        null
    );
  }
}
