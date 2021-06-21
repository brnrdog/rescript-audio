open Promise

type audioSelector = {src: string}

@val external setTimeout: (unit => unit, int) => float = "setTimeout"

module Document = {
  @val external document: Dom.document = "document"

  @send
  external querySelector: (Dom.document, string) => option<Dom.element> = "querySelector"

  @send
  external setElementAttribute: (
    Dom.element,
    ~attributeName: string,
    ~attributeValue: 'any,
  ) => unit = "setAttribute"

  @send
  external addEventListener: (
    Dom.element,
    ~eventType: string,
    ~eventListener: Dom.event => unit,
  ) => unit = "addEventListener"

  let setupEventListeners = (~onPause, ~onStart, ~onResume, ~onStop) => {
    let selector = document->querySelector("audio")->Belt.Option.getUnsafe
    let audioContext = AudioContext.create()
    let track = audioContext->AudioContext.createMediaElementSource(selector)
    let gain = audioContext->AudioContext.createGain

    Js.log(audioContext)

    track
    ->AudioContext.connect(gain)
    ->AudioContext.connect(AudioContext.getDestination(audioContext))
    ->Js.log

    let addClickEvent = (selector, listener) =>
      document
      ->querySelector(selector)
      ->Belt.Option.getUnsafe
      ->addEventListener(~eventType="click", ~eventListener=listener)

    addClickEvent("#start", onStart)
    addClickEvent("#pause", onPause)
    addClickEvent("#resume", onResume)
    addClickEvent("#stop", onStop)
  }

  let updateAudioElementSrc = src =>
    document
    ->querySelector("audio")
    ->Belt.Option.getUnsafe
    ->setElementAttribute(~attributeName="src", ~attributeValue=src)
}

let chunks: array<AudioBlob.t> = []

let onDataAvailable = (event: MediaRecorder.blobEvent) => {
  event.data->AudioBlob.createUrlFromBlob->Document.updateAudioElementSrc
}

let main = MediaStream.getStream()->thenResolve(v => {
  switch v {
  | MediaStream.Error(e) => Js.log(e)
  | MediaStream.Ok(stream) =>
    let recorder = stream->MediaRecorder.create
    let onStart = _ => {
      recorder->MediaRecorder.start(~onDataAvailable)
      recorder->MediaRecorder.getState->Js.log
    }
    let onStop = _ => {
      recorder->MediaRecorder.stop
      recorder->MediaRecorder.getState->Js.log
    }
    let onResume = _ => recorder->MediaRecorder.resume
    let onPause = _ => recorder->MediaRecorder.pause
    Document.setupEventListeners(~onStart, ~onPause, ~onResume, ~onStop)
  }
})
