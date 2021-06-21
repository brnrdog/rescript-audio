type t

@new external create: unit => t = "AudioContext"
@get external getDestination: t => Audio__AudioNode.t = "destination"
@send external createGain: t => Audio__AudioNode.t = "createGain"
@send
external createMediaElementSource: (t, Dom.element) => Audio__AudioNode.t =
  "createMediaElementSource"
