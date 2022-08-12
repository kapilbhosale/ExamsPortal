import ReactOnRails from 'react-on-rails';
import React from 'react';
import plyr from 'plyr';

class Ytplayer extends React.Component {
  constructor(props) {
    super(props);
  }

  componentDidMount() {

    // more optinos - https://github.com/sampotts/plyr
    const options = {
      fullscreen: {
        enabled: true,
        iosNative: false
      },
      controls: [
        "play-large",
        "play",
        "progress",
        "duration",
        "mute",
        "volume",
        "settings",
        "fullscreen"
      ],
      autoplay: true,
      storage: { enabled: false }
    };

    const player = plyr.setup("#plyr-video", options);
  }

  componentWillUnmount() {
    plyr.destroy()
  }

  render() {
    return (
      <div>
        <video id="plyr-video" autoplay="autoplay" controls>
          <source src={this.props.url} type="video/mp4" />
        </video>
      </div>
    )
  }
}


ReactOnRails.register({ Ytplayer });

export default Ytplayer;
