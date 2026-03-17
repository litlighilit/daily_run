

import std/os
import std/logging
import ./ctl_utils/[
  hiber,
]
export hiber

const MS_WINDOWS = defined(windows)

when MS_WINDOWS:
  type BOOL = cint  ## typedef int BOOL;
  proc LockWorkStation(): BOOL{.importc, header: "<windows.h>" #["<winuser.h>"]#.}
  proc lockWorkStation: bool = bool LockWorkStation()
proc checkLockCmdAvail: string =
  when MS_WINDOWS: " not impl"
  else:
    template runSh(c: string): int =
      when nimvm: gorgeEx(c).exitCode
      else: execShellCmd c
    if 0 != runSh("command -v loginctl > /dev/null"):
      return "no loginctl found"

template ifLockCmdUnavail(err; body) =
  block:
    let err = checkLockCmdAvail()
    if err.len != 0:
      body


proc lockScreen*() =
  when MS_WINDOWS:
    if not lockWorkStation():
      logging.error "failed to LockWorkStation(): " & osErrorMsg(osLastError())
  else:
    if 0 != execShellCmd "loginctl lock-session":
      logging.error "failed to loginctl lock-session"

when not MS_WINDOWS:
  proc unlockScreen* =
    if 0 != execShellCmd "loginctl unlock-session":
      logging.error "failed to loginctl unlock-session"
