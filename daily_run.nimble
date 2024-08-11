# Package

version       = "0.1.0"
author        = "litlighilit"
description   = "A time-based daily job scheduler using Nim macros"
license       = "MIT"
srcDir        = "src"
installExt    = @["nim"]
bin           = @["daily_run"]


# Dependencies

requires "nim >= 1.6.14"
