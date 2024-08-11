
import daily_run/[syntax, compile, ctl_utils]

export syntax, compile, ctl_utils

when isMainModule:
  from std/os import quoteShell
  import std/parseopt
  var
    run = false
    filename: string
    args: seq[string]
  for kind, key, val in getopt(shortNoVal = {'r'}, longNoVal = @["run"]):
    case kind
    of cmdArgument:
      filename = key
    of cmdLongOption, cmdShortOption:
      case key
      of "run", "r":
        run = true
      else:
        args.add quoteShell(key & ':' & val)
    of cmdEnd:
      doAssert false, "unreachable"
  assert filename.len != 0
  compileFile filename, run
