type event
type blobEvent = {data: AudioBlob.t}
type fn
type mediaRecorder = {@set "ondataavailable": blobEvent => unit}
type property = {
  value: blobEvent => unit,
  writable: bool,
}
@new external create: MediaStream.stream => mediaRecorder = "MediaRecorder"

@send
external _requestData: (mediaRecorder, unit) => AudioBlob.t = "requestData"

@send
external _start: mediaRecorder => unit = "start"
let start = mediaRecorder => {
  Js.log(">> Starting...")
  mediaRecorder->_start
  mediaRecorder
}

@send
external _stop: mediaRecorder => unit = "stop"
let stop = mediaRecorder => {
  mediaRecorder->_stop
  mediaRecorder
}

let onDataAvailable = (mediaRecorder, fn) => {
  mediaRecorder["ondataavailable"] = fn
  mediaRecorder
}

let requestData = mediaRecorder => {
  mediaRecorder->_requestData
}
