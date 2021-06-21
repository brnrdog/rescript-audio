type t

@new external create: unit => t = "AudioContext"
@get external getDestination: t => AudioNode.t = "destination"
@send external createGain: t => AudioNode.t = "createGain"
@send
external createMediaElementSource: (t, Dom.element) => AudioNode.t = "createMediaElementSource"
