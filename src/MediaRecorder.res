type event
type blobEvent = {data: AudioBlob.t}
type fn
type mediaRecorder = {@set "ondataavailable": blobEvent => unit}
type property = {
  value: blobEvent => unit,
  writable: bool,
}
@new external create: MediaStream.stream => mediaRecorder = "MediaRecorder"

@send external _requestData: (mediaRecorder, unit) => AudioBlob.t = "requestData"

@send external _start: mediaRecorder => unit = "start"
let start = (mediaRecorder, ~onDataAvailable) => {
  mediaRecorder["ondataavailable"] = onDataAvailable
  mediaRecorder->_start
  mediaRecorder
}

@send external _stop: mediaRecorder => unit = "stop"
let stop = mediaRecorder => {
  mediaRecorder->_stop
  mediaRecorder
}

@send external _pause: mediaRecorder => unit = "pause"
let pause = mediaRecorder => {
  mediaRecorder->_pause
  mediaRecorder
}

@send external _resume: mediaRecorder => unit = "resume"
let resume = mediaRecorder => {
  mediaRecorder->_resume
  mediaRecorder
}

let requestData = mediaRecorder => mediaRecorder->_requestData
