type t
type audioNode

@new external create: unit => t = "AudioContext"
@get external getDestination: t => audioNode = "destination"
@send external connect: (audioNode, audioNode) => audioNode = "connect"
@send external createGain: t => audioNode = "createGain"
@send external createMediaElementSource: (t, Dom.element) => audioNode = "createMediaElementSource"
