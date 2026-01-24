# rescript-audio

ReScript bindings for the Web Audio API.

## Installation

```bash
npm install rescript-audio
```

Add to your `rescript.json`:

```json
{
  "dependencies": ["rescript-audio"]
}
```

## Usage

```rescript
// Create an audio context
let ctx = Audio.Context.make()

// Create an oscillator with options
let osc = Audio.Oscillator.make(ctx, ~options={
  waveform: Sine,
  frequency: 440.0,
})

// Create a gain node
let gain = Audio.Gain.make(ctx, ~options={gain: 0.5})

// Connect oscillator -> gain -> destination
Audio.Utils.chain([
  osc->Audio.Oscillator.asNode,
  gain->Audio.Gain.asNode,
  Audio.ContextExt.destination(ctx)->Audio.Destination.asNode,
])

// Start the oscillator
Audio.Oscillator.start(osc)

// Schedule parameter changes
Audio.Gain.gainParam(gain)
->Audio.Param.setValueAtTime(~value=0.5, ~startTime=Audio.Context.currentTime(ctx))
->Audio.Param.linearRampToValueAtTime(~value=0.0, ~endTime=Audio.Context.currentTime(ctx) +. 1.0)
->ignore
```

## API

### Context

```rescript
Audio.Context.make()                    // Create new AudioContext
Audio.Context.makeWithOptions(options)  // Create with options
Audio.Context.sampleRate(ctx)           // Get sample rate
Audio.Context.currentTime(ctx)          // Get current time
Audio.Context.state(ctx)                // Get state: Suspended | Running | Closed
Audio.Context.resume(ctx)               // Resume (returns promise)
Audio.Context.suspend(ctx)              // Suspend (returns promise)
Audio.Context.close(ctx)                // Close (returns promise)
```

### Oscillator

```rescript
// Waveform types: Sine | Square | Sawtooth | Triangle | Custom
Audio.Oscillator.make(ctx, ~options=?)
Audio.Oscillator.frequencyParam(osc)    // Get frequency AudioParam
Audio.Oscillator.detuneParam(osc)       // Get detune AudioParam
Audio.Oscillator.waveform(osc)          // Get current waveform
Audio.Oscillator.setWaveform(osc, w)    // Set waveform
Audio.Oscillator.start(osc)             // Start immediately
Audio.Oscillator.startAt(osc, time)     // Start at time
Audio.Oscillator.stop(osc)              // Stop immediately
Audio.Oscillator.stopAt(osc, time)      // Stop at time
```

### Gain

```rescript
Audio.Gain.make(ctx, ~options=?)
Audio.Gain.gainParam(gain)              // Get gain AudioParam
```

### BiquadFilter

```rescript
// Filter types: Lowpass | Highpass | Bandpass | Lowshelf | Highshelf | Peaking | Notch | Allpass
Audio.BiquadFilter.make(ctx, ~options=?)
Audio.BiquadFilter.frequencyParam(f)
Audio.BiquadFilter.detuneParam(f)
Audio.BiquadFilter.qParam(f)
Audio.BiquadFilter.gainParam(f)
Audio.BiquadFilter.filterType(f)
Audio.BiquadFilter.setFilterType(f, ft)
```

### Delay

```rescript
Audio.Delay.make(ctx, ~options=?)
Audio.Delay.delayTimeParam(d)
```

### Compressor

```rescript
Audio.Compressor.make(ctx, ~options=?)
Audio.Compressor.thresholdParam(c)
Audio.Compressor.kneeParam(c)
Audio.Compressor.ratioParam(c)
Audio.Compressor.attackParam(c)
Audio.Compressor.releaseParam(c)
Audio.Compressor.reductionDb(c)         // Current gain reduction in dB
```

### StereoPanner

```rescript
Audio.StereoPanner.make(ctx, ~options=?)
Audio.StereoPanner.panParam(p)          // -1.0 (left) to 1.0 (right)
```

### Analyser

```rescript
Audio.Analyser.make(ctx, ~options=?)
Audio.Analyser.fftSize(a)
Audio.Analyser.setFftSize(a, size)
Audio.Analyser.frequencyBinCount(a)
Audio.Analyser.getFloatFrequencyData(a, array)
Audio.Analyser.getByteFrequencyData(a, array)
Audio.Analyser.getFloatTimeDomainData(a, array)
Audio.Analyser.getByteTimeDomainData(a, array)
```

### Param (AudioParam)

```rescript
Audio.Param.value(p)                    // Get current value
Audio.Param.setValue(p, v)              // Set value immediately
Audio.Param.setValueAtTime(p, ~value, ~startTime)
Audio.Param.linearRampToValueAtTime(p, ~value, ~endTime)
Audio.Param.exponentialRampToValueAtTime(p, ~value, ~endTime)
Audio.Param.setTargetAtTime(p, ~target, ~startTime, ~timeConstant)
Audio.Param.setValueCurveAtTime(p, ~values, ~startTime, ~duration)
Audio.Param.cancelScheduledValues(p, ~cancelTime)
Audio.Param.cancelAndHoldAtTime(p, ~cancelTime)
```

### Node

```rescript
Audio.Node.connect(source, destination)
Audio.Node.connectToParam(source, param)
Audio.Node.disconnect(node)
Audio.Node.disconnectFrom(node, target)
Audio.Node.numberOfInputs(node)
Audio.Node.numberOfOutputs(node)
```

### Utils

```rescript
Audio.Utils.chain(nodes)                // Connect array of nodes in series
Audio.Utils.toDestination(ctx, node)    // Connect node to destination
```

## Development

```bash
npm install
npm run build
npm test
npm run watch  # Development mode
```

## License

MIT
