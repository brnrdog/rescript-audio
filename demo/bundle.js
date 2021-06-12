(() => {
  // lib/es6/src/MediaStream.bs.js
  function getStream(param) {
    return navigator.mediaDevices.getUserMedia({
      video: false,
      audio: true
    }).then(function(stream) {
      return Promise.resolve({
        TAG: 0,
        _0: stream
      });
    });
  }

  // lib/es6/src/MediaRecorder.bs.js
  function start(mediaRecorder) {
    console.log(">> Starting...");
    mediaRecorder.start();
    return mediaRecorder;
  }
  function stop(mediaRecorder) {
    mediaRecorder.stop();
    return mediaRecorder;
  }
  function onDataAvailable(mediaRecorder, fn) {
    mediaRecorder.ondataavailable = fn;
    return mediaRecorder;
  }

  // lib/es6/src/Audio.bs.js
  var chunks = [];
  var main = getStream(void 0).then(function(v) {
    if (v.TAG !== 0) {
      return;
    }
    var recorder = onDataAvailable(start(new MediaRecorder(v._0)), function(v2) {
      chunks.push(v2.data);
      var url = URL.createObjectURL(new Blob(chunks, {
        type: "audio/ogg; codecs=opus"
      }));
      console.log(url);
      return document.querySelector("audio").src = url;
    });
    setTimeout(function(param) {
      stop(recorder);
      console.log(">> Stopped.");
    }, 3e3);
  });
})();
