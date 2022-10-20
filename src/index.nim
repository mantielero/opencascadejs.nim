# nim js -d:nimExperimentalAsyncjsThen -d:release index
import jsffi
import std/asyncjs, sugar
import ocjs
import viewport

{. emit: """
//import initOpenCascade from "opencascade.js";
import initOpenCascade from "./opencascade.full.js";
import * as THREE from 'https://cdn.jsdelivr.net/npm/three@0.121.1/build/three.module.js';
import { OrbitControls } from 'https://cdn.jsdelivr.net/npm/three@0.121.1/examples/jsm/controls/OrbitControls.js';

const makePolygon = (openCascade) => {
  const builder = new openCascade.BRep_Builder();
  const aComp = new openCascade.TopoDS_Compound();
  builder.MakeCompound(aComp);
  const path = [[-50, 0, 0], [50, 0, 0], [50, 100, 0]].map(([x, y, z]) => new openCascade.gp_Pnt_3(x, y, z));
  const makePolygon = new openCascade.BRepBuilderAPI_MakePolygon_3(path[0], path[1], path[2], true);
  const wire = makePolygon.Wire();
  const f = new openCascade.BRepBuilderAPI_MakeFace_15(wire, false);
  builder.Add(aComp, f.Shape());
  return aComp;
}
""".}

type
  TopoDS_Compound* = JsObject

proc initOpenCascade*():Future[JsObject] {.importcpp.} # :Future[void] 


proc addShapeToScene*(
    openCascade:JsObject, 
    shape:TopoDS_Compound, 
    scene:JsObject)  {.importcpp, async.}

proc makePolygon*(openCascade:JsObject):TopoDS_Compound {.importcpp.}


#-----------

let scene = setupThreeJSViewport()


discard initOpenCascade().then( 
  proc (opencascade:JsObject)  {.async.}  =  
    await addShapeToScene(openCascade, makePolygon(openCascade), scene) 
)


#[ type
  BRepBuilderObj* = JsObject
  TopoDS_CompoundObj* = JsObject
  Pnt3Obj* = JsObject

proc newBuilder*():BRepBuilderObj {.importcpp:"new openCascade.BRep_Builder()".}

proc newCompound*():TopoDS_CompoundObj  {.importcpp:"new openCascade.TopoDS_Compound()".}

proc newPnt*(x,y,z:SomeNumber):Pnt3Obj {.importcpp:"new openCascade.gp_Pnt_3(@)".}

proc makePolygon3*(a,b,c:Pnt3Obj; flag:bool): {.importcpp: "new openCascade.BRepBuilderAPI_MakePolygon_3(@)".}

proc makeFace*(wire:JsObject, flag:bool):JsObject {.importcpp:"new openCascade.BRepBuilderAPI_MakeFace_15(@)".}

proc makePolygon1*(openCascade:JsObject):TopoDS_Compound =
  let builder = newBuilder()
  let aComp = newCompound()
  builder.makeCompound(aComp)  #builder.MakeCompound(aComp);
  let points = @[ @[-50, 0 ,0], @[50, 0, 0], @[50, 100, 0]]
  var path = newSeq[JsObject]()
  for p in points:
    path &= newPnt(p[0], p[1], p[2])

  var poly = makePolygon3(path[0], path[1], path[2], true)
  var wire = poly.Wire()
  var face = makeFace(wire, false)

  builder.Add(aComp, f.Shape())
  return aComp
 ]#
