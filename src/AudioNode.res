type t

@send external connect: (t, t) => t = "connect"
@send external disconnect: t => unit = "disconnect"
