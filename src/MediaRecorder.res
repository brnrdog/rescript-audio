type event
type blobEvent = {data: AudioBlob.t}
type fn
type mediaRecorder = {@set "ondataavailable": blobEvent => unit}
type property = {
  value: blobEvent => unit,
  writable: bool,
}
@new external create: MediaStream.t => mediaRecorder = "MediaRecorder"

@send external _requestData: (mediaRecorder, unit) => AudioBlob.t = "requestData"

@send external _start: mediaRecorder => unit = "start"
let start = (mediaRecorder, ~onDataAvailable) => {
  mediaRecorder["ondataavailable"] = onDataAvailable
  mediaRecorder->_start
}

@send external stop: mediaRecorder => unit = "stop"

@send external pause: mediaRecorder => unit = "pause"

@send external resume: mediaRecorder => unit = "resume"

let requestData = mediaRecorder => mediaRecorder->_requestData

let stopFromStream = stream => stream->create->stop
