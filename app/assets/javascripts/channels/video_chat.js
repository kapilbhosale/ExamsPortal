App.video_chat = App.cable.subscriptions.create("VideoChatChannel", {
  connected: function () {
    console.log("AC:: ACTION CABLE ==> Connected");
  },
  disconnected: function () {
    console.log("AC:: ACTION CABLE dis-connected");
  },
  received: function (data) {
    console.log("AC:: DATA => ", data);
  }
});