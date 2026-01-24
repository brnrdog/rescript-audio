// ReScript Web Audio API bindings
// Provides an idiomatic ReScript interface to the Web Audio API

module Context = {
  type t

  type state =
    | Suspended
    | Running
    | Closed

  type options = {
    latencyHint?: string,
    sampleRate?: float,
  }

  @new external make: unit => t = "AudioContext"
  @new external makeWithOptions: options => t = "AudioContext"

  @get external sampleRate: t => float = "sampleRate"
  @get external currentTime: t => float = "currentTime"
  @get external baseLatency: t => float = "baseLatency"

  @get external stateString: t => string = "state"

  let state = (ctx: t): state => {
    switch stateString(ctx) {
    | "suspended" => Suspended
    | "running" => Running
    | "closed" => Closed
    | _ => Suspended
    }
  }

  @send external resume: t => promise<unit> = "resume"
  @send external suspend: t => promise<unit> = "suspend"
  @send external close: t => promise<unit> = "close"
}

module Param = {
  type t

  @get external value: t => float = "value"
  @set external setValue: (t, float) => unit = "value"
  @get external defaultValue: t => float = "defaultValue"
  @get external minValue: t => float = "minValue"
  @get external maxValue: t => float = "maxValue"

  @send
  external setValueAtTime: (t, ~value: float, ~startTime: float) => t = "setValueAtTime"

  @send
  external linearRampToValueAtTime: (t, ~value: float, ~endTime: float) => t =
    "linearRampToValueAtTime"

  @send
  external exponentialRampToValueAtTime: (t, ~value: float, ~endTime: float) => t =
    "exponentialRampToValueAtTime"

  @send
  external setTargetAtTime: (t, ~target: float, ~startTime: float, ~timeConstant: float) => t =
    "setTargetAtTime"

  @send
  external setValueCurveAtTime: (t, ~values: array<float>, ~startTime: float, ~duration: float) => t =
    "setValueCurveAtTime"

  @send external cancelScheduledValues: (t, ~cancelTime: float) => t = "cancelScheduledValues"

  @send
  external cancelAndHoldAtTime: (t, ~cancelTime: float) => t = "cancelAndHoldAtTime"
}

module Node = {
  type t

  @get external context: t => Context.t = "context"
  @get external numberOfInputs: t => int = "numberOfInputs"
  @get external numberOfOutputs: t => int = "numberOfOutputs"
  @get external channelCount: t => int = "channelCount"
  @set external setChannelCount: (t, int) => unit = "channelCount"

  @send external connect: (t, t) => t = "connect"
  @send external connectToParam: (t, Param.t) => unit = "connect"
  @send external disconnect: t => unit = "disconnect"
  @send external disconnectFrom: (t, t) => unit = "disconnect"
}

module Destination = {
  type t

  @get external maxChannelCount: t => int = "maxChannelCount"

  external asNode: t => Node.t = "%identity"
}

module Gain = {
  type t

  type options = {gain?: float}

  @send external _make: Context.t => t = "createGain"
  @get external gainParam: t => Param.t = "gain"

  let make = (ctx: Context.t, ~options: option<options>=?): t => {
    let gainNode = _make(ctx)
    switch options {
    | Some(opts) => opts.gain->Option.forEach(g => Param.setValue(gainParam(gainNode), g))
    | None => ()
    }
    gainNode
  }

  external asNode: t => Node.t = "%identity"
}

module Oscillator = {
  type t

  type waveform =
    | Sine
    | Square
    | Sawtooth
    | Triangle
    | Custom

  type options = {
    waveform?: waveform,
    frequency?: float,
    detune?: float,
  }

  let waveformToString = (w: waveform): string => {
    switch w {
    | Sine => "sine"
    | Square => "square"
    | Sawtooth => "sawtooth"
    | Triangle => "triangle"
    | Custom => "custom"
    }
  }

  let waveformFromString = (s: string): waveform => {
    switch s {
    | "sine" => Sine
    | "square" => Square
    | "sawtooth" => Sawtooth
    | "triangle" => Triangle
    | "custom" => Custom
    | _ => Sine
    }
  }

  @send external _make: Context.t => t = "createOscillator"
  @get external frequencyParam: t => Param.t = "frequency"
  @get external detuneParam: t => Param.t = "detune"
  @get external _getType: t => string = "type"
  @set external _setType: (t, string) => unit = "type"

  let make = (ctx: Context.t, ~options: option<options>=?): t => {
    let osc = _make(ctx)
    switch options {
    | Some(opts) => {
        opts.waveform->Option.forEach(w => _setType(osc, waveformToString(w)))
        opts.frequency->Option.forEach(f => Param.setValue(frequencyParam(osc), f))
        opts.detune->Option.forEach(d => Param.setValue(detuneParam(osc), d))
      }
    | None => ()
    }
    osc
  }

  let waveform = (osc: t): waveform => waveformFromString(_getType(osc))

  let setWaveform = (osc: t, w: waveform): unit => _setType(osc, waveformToString(w))

  @send external start: t => unit = "start"
  @send external startAt: (t, float) => unit = "start"
  @send external stop: t => unit = "stop"
  @send external stopAt: (t, float) => unit = "stop"

  external asNode: t => Node.t = "%identity"
}

module BiquadFilter = {
  type t

  type filterType =
    | Lowpass
    | Highpass
    | Bandpass
    | Lowshelf
    | Highshelf
    | Peaking
    | Notch
    | Allpass

  let filterTypeToString = (ft: filterType): string => {
    switch ft {
    | Lowpass => "lowpass"
    | Highpass => "highpass"
    | Bandpass => "bandpass"
    | Lowshelf => "lowshelf"
    | Highshelf => "highshelf"
    | Peaking => "peaking"
    | Notch => "notch"
    | Allpass => "allpass"
    }
  }

  let filterTypeFromString = (s: string): filterType => {
    switch s {
    | "lowpass" => Lowpass
    | "highpass" => Highpass
    | "bandpass" => Bandpass
    | "lowshelf" => Lowshelf
    | "highshelf" => Highshelf
    | "peaking" => Peaking
    | "notch" => Notch
    | "allpass" => Allpass
    | _ => Lowpass
    }
  }

  type options = {
    filterType?: filterType,
    frequency?: float,
    detune?: float,
    q?: float,
    gain?: float,
  }

  @send external _make: Context.t => t = "createBiquadFilter"
  @get external frequencyParam: t => Param.t = "frequency"
  @get external detuneParam: t => Param.t = "detune"
  @get external qParam: t => Param.t = "Q"
  @get external gainParam: t => Param.t = "gain"
  @get external _getType: t => string = "type"
  @set external _setType: (t, string) => unit = "type"

  let make = (ctx: Context.t, ~options: option<options>=?): t => {
    let filter = _make(ctx)
    switch options {
    | Some(opts) => {
        opts.filterType->Option.forEach(ft => _setType(filter, filterTypeToString(ft)))
        opts.frequency->Option.forEach(f => Param.setValue(frequencyParam(filter), f))
        opts.detune->Option.forEach(d => Param.setValue(detuneParam(filter), d))
        opts.q->Option.forEach(qVal => Param.setValue(qParam(filter), qVal))
        opts.gain->Option.forEach(g => Param.setValue(gainParam(filter), g))
      }
    | None => ()
    }
    filter
  }

  let filterType = (filter: t): filterType => filterTypeFromString(_getType(filter))
  let setFilterType = (filter: t, ft: filterType): unit => _setType(filter, filterTypeToString(ft))

  external asNode: t => Node.t = "%identity"
}

module Delay = {
  type t

  type options = {
    maxDelayTime?: float,
    delayTime?: float,
  }

  @send external _make: (Context.t, ~maxDelayTime: float=?) => t = "createDelay"
  @get external delayTimeParam: t => Param.t = "delayTime"

  let make = (ctx: Context.t, ~options: option<options>=?): t => {
    let maxDelay = options->Option.flatMap(o => o.maxDelayTime)
    let delay = _make(ctx, ~maxDelayTime=?maxDelay)
    switch options {
    | Some(opts) =>
      opts.delayTime->Option.forEach(dt => Param.setValue(delayTimeParam(delay), dt))
    | None => ()
    }
    delay
  }

  external asNode: t => Node.t = "%identity"
}

module Compressor = {
  type t

  type options = {
    threshold?: float,
    knee?: float,
    ratio?: float,
    attack?: float,
    release?: float,
  }

  @send external _make: Context.t => t = "createDynamicsCompressor"
  @get external thresholdParam: t => Param.t = "threshold"
  @get external kneeParam: t => Param.t = "knee"
  @get external ratioParam: t => Param.t = "ratio"
  @get external reductionDb: t => float = "reduction"
  @get external attackParam: t => Param.t = "attack"
  @get external releaseParam: t => Param.t = "release"

  let make = (ctx: Context.t, ~options: option<options>=?): t => {
    let comp = _make(ctx)
    switch options {
    | Some(opts) => {
        opts.threshold->Option.forEach(t => Param.setValue(thresholdParam(comp), t))
        opts.knee->Option.forEach(k => Param.setValue(kneeParam(comp), k))
        opts.ratio->Option.forEach(r => Param.setValue(ratioParam(comp), r))
        opts.attack->Option.forEach(a => Param.setValue(attackParam(comp), a))
        opts.release->Option.forEach(rel => Param.setValue(releaseParam(comp), rel))
      }
    | None => ()
    }
    comp
  }

  external asNode: t => Node.t = "%identity"
}

module StereoPanner = {
  type t

  type options = {pan?: float}

  @send external _make: Context.t => t = "createStereoPanner"
  @get external panParam: t => Param.t = "pan"

  let make = (ctx: Context.t, ~options: option<options>=?): t => {
    let panner = _make(ctx)
    switch options {
    | Some(opts) => opts.pan->Option.forEach(p => Param.setValue(panParam(panner), p))
    | None => ()
    }
    panner
  }

  external asNode: t => Node.t = "%identity"
}

module Analyser = {
  type t

  type options = {
    fftSize?: int,
    minDecibels?: float,
    maxDecibels?: float,
    smoothingTimeConstant?: float,
  }

  @send external _make: Context.t => t = "createAnalyser"
  @get external fftSize: t => int = "fftSize"
  @set external setFftSize: (t, int) => unit = "fftSize"
  @get external frequencyBinCount: t => int = "frequencyBinCount"
  @get external minDecibels: t => float = "minDecibels"
  @set external setMinDecibels: (t, float) => unit = "minDecibels"
  @get external maxDecibels: t => float = "maxDecibels"
  @set external setMaxDecibels: (t, float) => unit = "maxDecibels"
  @get external smoothingTimeConstant: t => float = "smoothingTimeConstant"
  @set external setSmoothingTimeConstant: (t, float) => unit = "smoothingTimeConstant"

  let make = (ctx: Context.t, ~options: option<options>=?): t => {
    let analyser = _make(ctx)
    switch options {
    | Some(opts) => {
        opts.fftSize->Option.forEach(size => setFftSize(analyser, size))
        opts.minDecibels->Option.forEach(min => setMinDecibels(analyser, min))
        opts.maxDecibels->Option.forEach(max => setMaxDecibels(analyser, max))
        opts.smoothingTimeConstant->Option.forEach(s => setSmoothingTimeConstant(analyser, s))
      }
    | None => ()
    }
    analyser
  }

  @send external getFloatFrequencyData: (t, Float32Array.t) => unit = "getFloatFrequencyData"
  @send external getByteFrequencyData: (t, Uint8Array.t) => unit = "getByteFrequencyData"
  @send external getFloatTimeDomainData: (t, Float32Array.t) => unit = "getFloatTimeDomainData"
  @send external getByteTimeDomainData: (t, Uint8Array.t) => unit = "getByteTimeDomainData"

  external asNode: t => Node.t = "%identity"
}

// Context extensions for getting destination and creating nodes
module ContextExt = {
  @get external destination: Context.t => Destination.t = "destination"
}

// Utility functions for common patterns
module Utils = {
  // Connect a chain of nodes
  let chain = (nodes: array<Node.t>): unit => {
    for i in 0 to Array.length(nodes) - 2 {
      let _ = Node.connect(nodes[i]->Option.getOrThrow, nodes[i + 1]->Option.getOrThrow)
    }
  }

  // Connect a node to the destination
  let toDestination = (ctx: Context.t, node: Node.t): unit => {
    let _ = Node.connect(node, ContextExt.destination(ctx)->Destination.asNode)
  }
}
