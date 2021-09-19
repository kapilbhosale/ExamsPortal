import ReactOnRails from 'react-on-rails';
import React from 'react';
import plyr from 'plyr';

class Ytplayer extends React.Component {
  constructor(props) {
    super(props);
  }

  componentDidMount() {
    this.player = new plyr('.js-plyr', this.props.options)
    this.player.source = {
      type: 'video',
      sources: [
        {
          src: this.props.url,
          type: 'video/mp4',
          size: 720,
        },
      ],
    }
  }

  componentWillUnmount() {
    this.player.destroy()
  }

  render() {
    return (
      <div>
        <p>player here..</p>
        <video className='js-plyr plyr'>
        </video>
      </div>
    )
  }
}


ReactOnRails.register({ Ytplayer });

export default Ytplayer;
