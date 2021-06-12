type mediaDevices
type navigator = {mediaDevices: mediaDevices}
type stream

type mediaDevicesConstraints = {
  video: bool,
  audio: bool,
}

@send
external getUserMedia: (mediaDevices, mediaDevicesConstraints) => Js.Promise.t<stream> =
  "getUserMedia"
@val external nav: navigator = "navigator"

type streamResult = Ok(stream) | Error(exn)

let getStream = () => {
  open Promise
  nav.mediaDevices->getUserMedia({video: false, audio: true})->then(stream => Ok(stream)->resolve)
}
