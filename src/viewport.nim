import jsffi, std/dom
import threejs

proc setupThreeJSViewport*():SceneObj =
  var scene = newScene()
  var camera = newPerspectiveCamera(75.0, clientWidth() / clientHeight(), 0.1, 1000.0);

  var antialias = newJsObject()
  antialias["antialias"] = true
  var renderer = newWebGLRenderer(antialias)
  var viewport = document.getElementById("viewport".cstring)  # const viewport = document.getElementById("viewport");
  #echo $viewport#.getAttribute("id".cstring)
  var viewportRect = viewport.getBoundingClientRect() #   const viewportRect = viewport.getBoundingClientRect();
  renderer.setSize(viewportRect.width, viewportRect.height)
  viewport.appendChild(renderer.domElement)
  
  var light = newAmbientLight(0x404040)
  scene.add(light)
  var directionalLight = newDirectionalLight(0xffffff, 0.5) # const directionalLight = new DirectionalLight(0xffffff, 0.5);
  directionalLight.position.set(0.5, 0.5, 0.5)
  scene.add(directionalLight)

  camera.position.set(0, 50, 100)

  var controls = newOrbitControls(camera, renderer.domElement)
  controls.screenSpacePanning = true
  controls.target.set(0, 50, 0)
  controls.update()


  proc animate(time:float) = 
    discard window.requestAnimationFrame( animate )
 
    # Render the scene
    renderer.render(scene, camera)

  animate(0.0)

  return scene    