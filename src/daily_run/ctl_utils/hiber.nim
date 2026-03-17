

const hiberCmd*: string =
  when defined(windows):
    "shutdown /h"
  else:
    "systemctl hibernate"

when defined(dryRunHiber):
  {.hint: "dry run hiber".}
  proc hiber* =
    echo hiberCmd
    quit()
else:
  import std/os
  proc hiber* = discard os.execShellCmd hiberCmd
