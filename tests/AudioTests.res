open Zekr

// Tests for the Audio module type conversions and utilities

let oscillatorWaveformSuite = suite("Oscillator.waveform conversions", [
  test("Sine converts to string correctly", () => {
    assertEqual(Audio.Oscillator.waveformToString(Sine), "sine")
  }),
  test("Square converts to string correctly", () => {
    assertEqual(Audio.Oscillator.waveformToString(Square), "square")
  }),
  test("Sawtooth converts to string correctly", () => {
    assertEqual(Audio.Oscillator.waveformToString(Sawtooth), "sawtooth")
  }),
  test("Triangle converts to string correctly", () => {
    assertEqual(Audio.Oscillator.waveformToString(Triangle), "triangle")
  }),
  test("Custom converts to string correctly", () => {
    assertEqual(Audio.Oscillator.waveformToString(Custom), "custom")
  }),
  test("String 'sine' converts to Sine", () => {
    assertEqual(Audio.Oscillator.waveformFromString("sine"), Audio.Oscillator.Sine)
  }),
  test("String 'square' converts to Square", () => {
    assertEqual(Audio.Oscillator.waveformFromString("square"), Audio.Oscillator.Square)
  }),
  test("String 'sawtooth' converts to Sawtooth", () => {
    assertEqual(Audio.Oscillator.waveformFromString("sawtooth"), Audio.Oscillator.Sawtooth)
  }),
  test("String 'triangle' converts to Triangle", () => {
    assertEqual(Audio.Oscillator.waveformFromString("triangle"), Audio.Oscillator.Triangle)
  }),
  test("String 'custom' converts to Custom", () => {
    assertEqual(Audio.Oscillator.waveformFromString("custom"), Audio.Oscillator.Custom)
  }),
  test("Unknown string defaults to Sine", () => {
    assertEqual(Audio.Oscillator.waveformFromString("unknown"), Audio.Oscillator.Sine)
  }),
])

let biquadFilterTypeSuite = suite("BiquadFilter.filterType conversions", [
  test("Lowpass converts to string correctly", () => {
    assertEqual(Audio.BiquadFilter.filterTypeToString(Lowpass), "lowpass")
  }),
  test("Highpass converts to string correctly", () => {
    assertEqual(Audio.BiquadFilter.filterTypeToString(Highpass), "highpass")
  }),
  test("Bandpass converts to string correctly", () => {
    assertEqual(Audio.BiquadFilter.filterTypeToString(Bandpass), "bandpass")
  }),
  test("Lowshelf converts to string correctly", () => {
    assertEqual(Audio.BiquadFilter.filterTypeToString(Lowshelf), "lowshelf")
  }),
  test("Highshelf converts to string correctly", () => {
    assertEqual(Audio.BiquadFilter.filterTypeToString(Highshelf), "highshelf")
  }),
  test("Peaking converts to string correctly", () => {
    assertEqual(Audio.BiquadFilter.filterTypeToString(Peaking), "peaking")
  }),
  test("Notch converts to string correctly", () => {
    assertEqual(Audio.BiquadFilter.filterTypeToString(Notch), "notch")
  }),
  test("Allpass converts to string correctly", () => {
    assertEqual(Audio.BiquadFilter.filterTypeToString(Allpass), "allpass")
  }),
  test("String 'lowpass' converts to Lowpass", () => {
    assertEqual(Audio.BiquadFilter.filterTypeFromString("lowpass"), Audio.BiquadFilter.Lowpass)
  }),
  test("String 'highpass' converts to Highpass", () => {
    assertEqual(Audio.BiquadFilter.filterTypeFromString("highpass"), Audio.BiquadFilter.Highpass)
  }),
  test("String 'bandpass' converts to Bandpass", () => {
    assertEqual(Audio.BiquadFilter.filterTypeFromString("bandpass"), Audio.BiquadFilter.Bandpass)
  }),
  test("Unknown string defaults to Lowpass", () => {
    assertEqual(Audio.BiquadFilter.filterTypeFromString("unknown"), Audio.BiquadFilter.Lowpass)
  }),
])

let _ = runSuites([oscillatorWaveformSuite, biquadFilterTypeSuite])
