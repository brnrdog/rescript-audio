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

  let updateAudioElementSrc = src =>
    document
    ->querySelector("audio")
    ->Belt.Option.getUnsafe
    ->setElementAttribute(~attributeName="src", ~attributeValue=src)
}

let chunks: array<AudioBlob.t> = []

let onDataAvailable = (event: MediaRecorder.blobEvent) => {
  event.data->AudioBlob.createFromBlob->AudioBlob.createUrl->Document.updateAudioElementSrc
}

let main = MediaStream.getStream()->thenResolve(v => {
  switch v {
  | MediaStream.Error(e) => Js.log(e)
  | MediaStream.Ok(stream) =>
    let recorder = stream->MediaRecorder.create->MediaRecorder.start(~onDataAvailable)

    let _ = setTimeout(() => {
      let _ = MediaRecorder.pause(recorder)
    }, 3000)

    let _ = setTimeout(() => {
      let _ = MediaRecorder.resume(recorder)
    }, 9000)

    let _ = setTimeout(() => {
      let _ = MediaRecorder.stop(recorder)
    }, 15000)
  }
})
