
import std/tempfiles
import std/os

const pkgDir = currentSourcePath().parentDir().parentDir()
func prepare(s: string): string =
  "import r\"" & pkgDir/"daily_run.nim\"\n" &
    s & "\nmainloop()"

proc compileFile*(fn: string, run: bool = false, arg: openArray[string] = []) =
  let
    res = prepare readFile fn
    tfn = genTempPath("daily_run_res", ".nim")
  writeFile tfn, res
  defer: removeFile tfn
  var oExe = fn.changeFileExt(ExeExt)
  assert 0 == execShellCmd "nim c -o:" & oExe & arg.quoteShellCommand & " --hints:off " & tfn
  if run:
    if oExe.parentDir() == "":  # is bare path
      oExe = "."/oExe
    echo execShellCmd oExe
    
