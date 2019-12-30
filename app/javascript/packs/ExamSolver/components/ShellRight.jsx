import React from 'react';

class ShellRight extends React.Component {

  componentDidMount() {
    const $win = $(window);
    const MEDIAQUERY = {
      desktopXL: 1200,
      desktop: 992,
      tablet: 768,
      mobile: 575,
    };
    const mobileDevice = $win.width() < MEDIAQUERY.mobile

    if (this.props.isNavigationMapOpen && mobileDevice) {
      setNavigationMap(false);
      document.getElementById("mySidenav").style.width = "0";
      document.getElementById("mySidenav").style.paddingLeft = 0;
      document.getElementById("mySidenav").style.paddingRight = 0;
    } else {
      document.getElementById("mySidenav").style.width = "320px";
      document.getElementById("mySidenav").style.paddingLeft = "13px";
    }
  }
  render() {
    const { 
      questions,
      totalQuestions,
      jumpToQuestion,
      currentQuestionIndex,
      submitTest,
      answeredQuestions,
      notAnsweredQuestions,
      markedQuestions,
      notVisitedQuestions,
      setNavigationMap,
      isNavigationMapOpen,
      toggleTestSubmitModal } = this.props;
    const closeNav = () => {
      setNavigationMap(false);
      document.getElementById("mySidenav").style.width = "0";
      document.getElementById("mySidenav").style.paddingLeft = 0;
      document.getElementById("mySidenav").style.paddingRight = 0;
    }

    const $win = $(window);
    const MEDIAQUERY = {
      desktopXL: 1200,
      desktop: 992,
      tablet: 768,
      mobile: 575,
    };
    function isMobileDevice() {
      return $win.width() < MEDIAQUERY.mobile;
    }
    const openNav = () => {
      setNavigationMap(true);
      if (isMobileDevice()) {
        document.getElementById("mySidenav").style.width = "100%";
        document.getElementById("mySidenav").style.paddingLeft = "13px";
      }
      else {
        document.getElementById("mySidenav").style.width = "320px";
        document.getElementById("mySidenav").style.paddingLeft = "13px";
      }
    };

    const changeNavigationMapStatus = () => {
      if (isNavigationMapOpen) {
        closeNav();
      }
      else {
        openNav();
      }

    }

    return (
      <div className='container col-md-3'>
        <div className='row'>
          <div className='navigation-map'>
            <div className='sidenav panel' id="mySidenav">
              <div onClick={ () => { changeNavigationMapStatus() }} className='closebtn cursor-pointer'>
                <span
                  className={ `${isNavigationMapOpen ? 'glyphicon glyphicon-chevron-right' : 'glyphicon glyphicon-chevron-left' }` }
                  >
                </span>
              </div>
              <div className='row margin-bottom-20 padding-top-20'>
                <div className='col-md-6'>
                  <span className="label label-default label-sm margin-5">
                    { `Not visited (${notVisitedQuestions})`}
                  </span>
                </div>
                <div className='col-md-6'>
                  <div >
                  <span className="label label-primary label-sm margin-5">
                    { `Marked (${markedQuestions})` }
                  </span>
                  </div>
                </div>
              </div>
              <div className='row margin-bottom-20'>
                <div className='col-md-6'>
                  <span className="label label-success label-sm margin-5">
                    { `Answered (${answeredQuestions})` }
                  </span>
                </div>
                <div className='col-md-6'>
                  <span className="label label-danger label-sm margin-5">
                    { `Not answered (${notAnsweredQuestions})` }
                  </span>
                </div>
              </div>

              <div className='row margin-bottom-20 text-center'>
                <div className="col-md-12">
                  Navigation Map
                </div>
              </div>

              <div className='row' style={{ height: '70vh', overflow: 'scroll' }}>
              <div className='col-md-12'>
                <div className="btn-toolbar form-group text-center margin-bottom-110" role="toolbar" aria-label="...">
                  {
                    questions.map((question, idx) => {
                      const { isAnswered, needReview, visited } = question.answerProps;
                      let dynamicClass = '';
                      if (idx !== currentQuestionIndex) {
                        if (isAnswered) {
                          dynamicClass = 'btn-success';
                        }
                        if (visited && !isAnswered) {
                          dynamicClass = 'btn-danger';
                        }
                        if (needReview) {
                          dynamicClass = 'btn-primary';
                        }
                      } else {
                        dynamicClass = "btn-warning"
                      }
                      return (
                        <button
                          key={idx}
                          type="button"
                          className={ `btn btn-default ${dynamicClass}` }
                          style={{ marginRight: '10px', marginLeft: '5px', marginBottom: '10px', width: '40px', height: '40px' }}
                          onClick={ () => { jumpToQuestion(idx) }}
                        >
                          {idx + 1}
                        </button>
                      )
                    })
                  }
                </div>
              </div>
              </div>

                <div className='row'>
                  <div className='col-md-12 submit-exam'>
                    <button type="button" className="btn btn-block btn-success" onClick={ () => { toggleTestSubmitModal(true) }}>
                      Submit Test
                    </button>
                  </div>
                </div>
            </div>
          </div>
        </div>
      </div>
    );
  }
}

export default ShellRight;
