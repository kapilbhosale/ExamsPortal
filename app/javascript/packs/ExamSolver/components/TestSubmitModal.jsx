import PropTypes from 'prop-types';
import React, { Component } from 'react';
import Modal from 'react-modal';
import { Offline, Online } from "react-detect-offline";

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
      const headersNames = ['Section', 'Answered', 'Not Ans'];
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
      const questionsBySections = this.props.questionsBySections;
      let tableDataRows = [];
      let totalAnswered = 0;
      let totalNotAnswered = 0;

      Object.keys(questionsBySections).forEach(sectionName => {
        let answered = 0;
        let notAnswered = 0;
        questionsBySections[sectionName].forEach(ansData => {
          ansData.answerProps.isAnswered ? answered += 1 : notAnswered += 1;
        });
        console.log("section_name", sectionName);
        console.log("answered", answered);
        console.log("not ans", notAnswered);
        totalAnswered += answered;
        totalNotAnswered += notAnswered;
        tableDataRows.push(
          <tr key={ `data_row_${ sectionName }` }>
            <td> { sectionName } </td>
            <td className='text-center'> { answered } </td>
            <td className='text-center'> <b>{ notAnswered } </b></td>
          </tr>
        );
      });

      tableDataRows.push(
        <tr>
          <td className='text-right'> { 'Total' } </td>
          <td className='text-center'> { totalAnswered } </td>
          <td className='text-center text-danger'> <h5>{ totalNotAnswered }</h5></td>
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
          <Offline>
            <div className="text-center" style={{padding: '40% 0%'}}>
              <div style={{padding: '10% 0%'}}>
                <h3>No Intenet Connection</h3>
              </div>

              <img src="data:image/png;base64,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"/>

              <p style={{padding: '10% 0%'}}>
                Please connect to Internet, Submit Exam needs Internet
              </p>
              <div className="text-danger" style={{marginTop: '50px'}}>
                <h5>
                  NOTE:: Your Result will not Generate
                </h5>
              </div>
            </div>
          </Offline>
          <Online>
            <div>
              <h4 className='text-red text-center'> Are you Sure to Submit Exam ?</h4>
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
            <div className='row text-center'>
              <div className='col-md-12 mb-3'>
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
          </Online>
        </Modal>
        :
        null
    );
  }
}
