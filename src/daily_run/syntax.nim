
import std/macros
from std/math import splitDecimal
import std/times
export weeks, days, hours, minutes, seconds, milliseconds
export times.`*`
from std/os import sleep

from std/algorithm import lowerBound, upperBound

type
  Time = tuple[hour: HourRange, minute: MinuteRange]
  TimeOrd = int32  ## in minutes
  Callback = proc()
  CbItem = tuple[ord: TimeOrd, cb: Callback]
using time: Time

func toOrd(time): TimeOrd = time.minute.TimeOrd + time.hour.TimeOrd * 60

func toMilliseconds(t: TimeInterval): int =
  assert t.years == 0
  assert t.months == 0
  result.inc 7*t.weeks
  template inc(fac: int, part) = result = fac * result + t.part
  inc 1, days
  inc 24, hours
  inc 60, minutes
  inc 60, seconds
  inc 1000, milliseconds

var
  interval: TimeInterval = 1.minutes

  callbacks: seq[CbItem]

func cbCmp(x: CbItem; time): int = cmp x.ord, time.toOrd

proc register(time; callback: Callback) =
  callbacks.insert((time.toOrd, callback), callbacks.lowerBound(time, cbCmp))

template after*(time: Time; body) =
  bind register
  register(time, proc() = body)

macro after*(time: static float; body) =
  let tup = time.splitDecimal
  let
    hour = HourRange tup.intpart
    minute = MinuteRange toInt 100 * tup.floatpart
  newCall(
    bindSym"after",
    nnkTupleConstr.newTree(
      newCall(bindSym"HourRange", hour.newLit),
      newCall(bindSym"MinuteRange", minute.newLit)
    ),
    body
  )


proc setInterval*(t: TimeInterval) =
  interval = t

proc mainloop* =
  var idx = 0
  while true:
    sleep toMilliseconds interval
    let
      nowDt = now()
      nowTime: Time = (nowDt.hour, nowDt.minute)
    idx = callbacks.lowerBound(nowTime, cbCmp)
    let le = callbacks.len
    if le != 0 and idx == le:
      # later than the last
      idx.dec 1
    for i in idx..<le:
      callbacks[i].cb()
