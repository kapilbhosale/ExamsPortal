import ReactOnRails from 'react-on-rails';
import React from 'react';
import Plyr from 'plyr';

class Ytplayer extends React.Component {
  constructor(props) {
    super(props);
    this.state ={
      id: null,
    }
  }

  componentDidMount() {
    const player = new Plyr('#player');
    window.palyer = player;

    fetch("http://exams.lvh.me:3000/students/play-yt-video")
      .then(res => res.json())
      .then(
        (result) => {
          console.log("RESULT", result);
          this.setState({
            id: result.id
          });
        },
        (error) => {
          console.log("ERROR", error);
        }
      )
  }

  render() {
    return(
      <div className="container">
        <div id="player" data-plyr-provider="youtube" data-plyr-embed-id={this.state.id}></div>
      </div>
    );
  }
}

ReactOnRails.register({ Ytplayer });

export default Ytplayer;