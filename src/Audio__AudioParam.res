type t

@get external getDefaultValue: t => float = "defaultValue"
@get external getMaxValue: t => float = "maxValue"
@get external getMinValue: t => float = "minValue"
@get external getValue: t => float = "value"
@set external setValue: (t, float) => unit = "value"

@send external setValueAtTime: (t, ~value: float, ~startTime: float) => unit = "setValueAtTime"
