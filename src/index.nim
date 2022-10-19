# nim js -d:nimExperimentalAsyncjsThen index
import jsffi
import std/asyncjs, sugar
import ocjs


type
  TopoDS_Compound* = JsObject

proc initOpenCascade*():Future[JsObject] {.importcpp.} # :Future[void] 

proc setupThreeJSViewport*():JsObject {.importcpp.}  # dist/library.js

proc addShapeToScene*(
    openCascade:JsObject, 
    shape:TopoDS_Compound, 
    scene:JsObject)  {.importcpp, async.}

proc makePolygon*(openCascade:JsObject):TopoDS_Compound {.importcpp.}

#aComp = new openCascade.TopoDS_Compound();
#-----------

let
  scene = setupThreeJSViewport()


discard initOpenCascade().then( 
  proc (opencascade:JsObject)  {.async.}  =  
    await addShapeToScene(openCascade, makePolygon(openCascade), scene) 
)

