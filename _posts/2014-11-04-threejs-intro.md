---
layout: post
title: "An intro to spinning boxes with Three.js"
date: 2014-11-04 12:31
categories: categories
---
I often feel nostalgic about the flashy graphics programming I did in college: the mere mention of ray tracers sends my heart racing. To alleviate this heartache, I thought it'd be fun to make something with [Three.js](http://threejs.org).

Three.js promises to lessen the notoriously spirit-crushing learning curve that often comes with graphics programming. It offers a simple API for interacting with WebGL, the 3D graphics part of Javascript.

I'll be writing the code to interact with Three.js in Coffeescript rather than raw Javascript, primarily because Coffeescript rocks. Coffeescript is a tiny compiles-to-Javascript language that makes Javascript easier to use. If you don't know about it, I encourage you to [check it out](http://coffeescript.org).

Let's start out with an HTML page that just includes some of the things we'll need:

{% highlight html %}
<!-- one.html -->
<html>
  <head>
    <title>Three.js demo</title>
    <style>
      body { margin: 0; }
      canvas { width: 100%; height: 100% }
    </style>
  </head>
  <body>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r69/three.min.js"></script>
    <script src="one.js"></script>
  </body>
</html>
{% endhighlight %}

Most of this should seem pretty familiar. A few things worth mentioning are:

- With the styles, we're just creating a body and canvas that occupy the whole page.
- Our Coffeescript file compiles from `one.coffee` to `one.js`, so we're still including raw Javascript.

Let's create our Coffeescript file as well:

{% highlight coffeescript %}
# one.coffee
window.onload = ->
  alert("hello!")
{% endhighlight %}

When you load up `one.html`, you should now be greeted by an annoying alert. We'll fix that, but only after a brief aside about how graphics libraries work.

The beating heart of most graphics libraries is something called the *render loop*. You're probably familiar with the concept that most games try to run at 60 frames per second; this means that we're going through the render loop to *redraw* the scene about 60 times each second. This "60" number comes from the fact that most monitors can only update 60 times per second.

The point of view from which the user sees what's being drawn by the render loop is called the *camera*. The camera's position is what distinguishes a top-down game like Starcraft from a first-person shooter like Call of Duty. Both are 3D games, but Starcraft has a camera up above the action, whereas Call of Duty's camera is right in it.

The view that the camera shows is called the *scene*. The scene consists of all of the objects being drawn as well as things that affect how those objects are drawn (think lighting).

The *renderer* is what takes the 3D scene we've described along with the camera and actually makes a 2D image to place on our screen out of it. It ties everything together.

Let's start with the render loop. What does a render loop look like in Three.js?

{% highlight coffeescript %}
# one.coffee
window.onload = ->
  
  render = -> 
    requestAnimationFrame(render)
    # TODO: Draw scene

  render()
{% endhighlight %}

The above code actually has nothing to do with Three.js - it's how render loops are done in Javascript in general. The important bits are:

- Declaring a render function (creatively called `render` in our case).
- Within that function, calling `requestAnimationFrame` with a function pointer to the render function. This tells WebGL to call the function we passed it the next time that it needs to redraw things.
- Actually drawing the scene in the render function. We still have to do this.
- Calling our render function once to start this loop off.

So now that we have our render function, let's create a scene for it to draw. In our case, a 1x1x1 box will do nicely.

{% highlight coffeescript %}
# one.coffee
window.onload = ->
  scene = new THREE.Scene()

  boxGeometry = new THREE.BoxGeometry(1, 1, 1)
  boxMaterial = new THREE.MeshBasicMaterial({
    color: 0xFF0000
  })
  box = new THREE.Mesh(boxGeometry, boxMaterial)
  scene.add(box)
    
  render = -> 
    requestAnimationFrame(render)

  render()
{% endhighlight %}

Simple enough: first we create the box, then we add it to our scene. All geometry (i.e. each shape) has a default center of (0, 0, 0), so the box is right at our origin.

Each geometry in the scene also needs be associated with a *material*. The material describes things like how shiny the geometry should appear and what color it is.

Next, we need a camera to render our box. 

{% highlight coffeescript %}
# one.coffee
window.onload = ->
  # Create geometry...

  camera = new THREE.PerspectiveCamera(
    50,
    window.innerWidth / window.innerHeight,
    0.1,
    2000)
  camera.position.z = 5

  # Render function...
{% endhighlight %}

Our camera parameters are:

- Our field of view: `50`. The field of view is the number of degrees (vertically) that the camera can see. You can think of this like photography: really wide-angle, fisheye lenses have a huge field of view and can fit much more of the scene into a shot than zoom lenses.
- The aspect ratio: `window.innerWidth / window.innerHeight`. This ratio defines the horizontal field of view relative to the vertical field of view. Unsurprisingly, we find this by just dividing the two.
- The near clipping plane: `0.1`. Things closer to the camera than this distance won't be drawn.
- The far clipping plane: `2000`. Things farther from the camera than this distance won't be drawn.

Then we set the camera slightly above the scene (at `z = 5`).

Lastly, we need a renderer to tie this all together and actually draw the scene. When we create a renderer in Three.js, we're given a DOM element that the renderer is tied to, so we'll want to add that into the DOM as well. That looks like this:

{% highlight coffeescript %}
# one.coffee
window.onload = ->
  # Create geometry...
  # Create camera...

  renderer = new THREE.WebGLRenderer()
  renderer.setSize(window.innerWidth, window.innerHeight)
  document.body.appendChild(renderer.domElement)

  # Render function...
{% endhighlight %}

If you refresh your page, you'll be shocked to see... nada. That's because we still need to update our render function to actually *use* our renderer. Modify the render function to look like this:

{% highlight coffeescript %}
# one.coffee
window.onload = ->
  # Create geometry...
  # Create camera...
  # Create renderer...

  render = -> 
    requestAnimationFrame(render)
    renderer.render(scene, camera)
{% endhighlight %}

This will give you the beautiful:

<iframe frameBorder="0" width="100%" height="100%" src="{{site.basurl}}/js/2014-11-04-threejs-intro/one-square.html"></iframe>

"That's boring!", you might say. Well, we're looking at a box from its top so, to us, it just looks like a rectangle. We can spice this up by rotating the box a little every time we draw, like this:

{% highlight coffeescript %}
# one.coffee
window.onload = ->
  # Create geometry...
  # Create camera...
  # Create renderer...

  render = -> 
    requestAnimationFrame(render)
    renderer.render(scene, camera)
    box.rotation.x += .01
    box.rotation.y += .01
{% endhighlight %}

This looks like:

<iframe frameBorder="0" width="100%" height="100%" src="{{site.basurl}}/js/2014-11-04-threejs-intro/one-rotating.html"></iframe>

Much better! An honest-to-god, rotating box. 
