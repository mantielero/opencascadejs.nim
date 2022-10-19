import jsffi

when not defined(js):
  {.error: "This module only works on the JavaScript platform".}

proc initOpenCascade*() {.importcpp.}