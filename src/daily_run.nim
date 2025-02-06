
import daily_run/[syntax, compile, ctl_utils]

export syntax, compile, ctl_utils


when isMainModule:
  import std/parseopt
  from std/os import getAppFilename, quoteShell, lastPathPart
  from std/strutils import format
  proc echoHelp =
    echo """
$1 -h,--help
$1 [-r,--run] [opts_for_nim] file
  """.format getAppFilename().lastPathPart
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
      of "help", "h":
        echoHelp()
        quit QuitSuccess
      else:
        args.add quoteShell(key & ':' & val)
    of cmdEnd:
      doAssert false, "unreachable"
  assert filename.len != 0
  compileFile filename, run
