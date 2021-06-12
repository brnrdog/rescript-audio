open Promise

@val external setTimeout: (unit => unit, int) => float = "setTimeout"

let chunks: array<AudioBlob.t> = []

let main = MediaStream.getStream()->thenResolve(v =>
  switch v {
  | MediaStream.Error(_) => ()
  | MediaStream.Ok(stream) =>
    let recorder =
      stream
      ->MediaRecorder.create
      ->MediaRecorder.start
      ->MediaRecorder.onDataAvailable((v: MediaRecorder.blobEvent) => {
        let _ = chunks->Js.Array2.push(v.data)
        let url = chunks->AudioBlob.create({"type": "audio/ogg; codecs=opus"})->AudioBlob.createUrl
        Js.log(url)
        %raw(`document.querySelector("audio").src = url`)
      })
    let _ = setTimeout(() => {
      let _ = recorder->MediaRecorder.stop
      Js.log(">> Stopped.")
    }, 3000)
  }
)
