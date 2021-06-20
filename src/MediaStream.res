type mediaDevices
type navigator = {mediaDevices: Js.undefined<mediaDevices>}
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

  switch Js.Undefined.toOption(nav.mediaDevices) {
  | Some(mediaDevices) =>
    mediaDevices
    ->getUserMedia({video: false, audio: true})
    ->then(stream => stream->Ok->resolve)
    ->catch(err => err->Error->resolve)
  | None =>
    "The method getUserMedia not supported in this environment"->Js.Exn.raiseError->Error->resolve
  }
}
