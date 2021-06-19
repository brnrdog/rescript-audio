type mediaDevices
type navigator = {mediaDevices: mediaDevices}
type t

type mediaDevicesConstraints = {
  video: bool,
  audio: bool,
}

@send
external getUserMedia: (mediaDevices, mediaDevicesConstraints) => Js.Promise.t<t> = "getUserMedia"
@val external nav: navigator = "navigator"

type streamResult = Ok(t) | Error(exn)

let getStream = () => {
  open Promise
  nav.mediaDevices
  ->getUserMedia({video: false, audio: true})
  ->then(stream => Ok(stream)->resolve)
  ->catch(err => resolve(Error(err)))
}
