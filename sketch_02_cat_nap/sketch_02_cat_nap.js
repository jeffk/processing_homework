var twitch = 0;
var step = 1;
var frame = 0;
var motes = new Array();
var light = new Array();

for (var i = 0; i < 100; i++) {
	motes[i] = [0,0]
}

// Todo: Standardize on width/100 or something more granular
// for all math so we can actually resize the screen.

function setup() {
  createCanvas(window.innerHeight*.75, window.innerHeight);
  light[0] = createVector(width/100*20, (height/100)*47);
  light[1] = createVector(width/100*50, (height/100)*100);
  light[2] = createVector(width/100*104, (height/100)*100);
  light[3] = createVector(width/100*42, height/100*25);

}

function draw() {
  // We create a frame loop because things move too fast in the draw loop
  // to animate with. This lets us draw at full speed, but slow some things
  // down.
  frame++;
  if (frame >= 100) {
    frame = 0;
  };
  // Clear the background and draw the objects.
  background("#504844");
  draw_floor();
  draw_door();
  draw_window();
  draw_painting();
  draw_rug();
  draw_cat();
  draw_light();
  draw_motes();
}

function draw_floor() {
  fill("#6A625E");
  strokeWeight(0);
  rect(0, height/100*75, width, height);  
}

function draw_door() {
  fill("#484743");
  strokeWeight(0);
  rect(width/100*15, (height/100)*20, width/30*10, height/100*55);
  fill("#363636");
  ellipse(width/20*4, (height/20)*11, width/25, width/25);
}

function draw_window() {
  fill("#E8D794");
  strokeWeight(0);
  rect(width/100*20, (height/100)*25, width/100*10, height/100*10);
  rect((width/100*30)+(width/100)*2, ((height/100)*25), width/10, height/10);
  rect(width/100*20, ((height/100)*35)+((width/100)*2), width/10, height/10);
  rect((width/100*30)+((width/100)*2), ((height/100)*35)+width/50, width/10, height/10);
}

function draw_painting() {
  // It's easier to draw rectangles from the center when we're
  // drawing them centered over each other.
  rectMode(CENTER);
  fill("#413e36");
  strokeWeight(0);
  rect(width/20*15, (height/100)*37, width/20*5, width/20*5);
  fill("#575249");
  rect(width/20*15, (height/100)*37, width/20*4, width/20*4);
  // Reset rectMode back so it doesn't break everything else.
  rectMode(CORNER);
  fill("#504530");
  noStroke();
  ellipse(width/20*15, (height/100)*37, width/20*2, width/20*3);
  fill("#463d2e");
  ellipse(width/20*15, (height/100)*32, width/40*1, width/40*2);
  ellipse(width/20*15, (height/100)*33, width/20*2, width/20*1);
  strokeWeight(0);
}

function draw_rug() {
  // This should probably be a different shape, wider in the front
  // and narrower in the back, but ellipse is what we've got, so it's
  // what we'll use.
  fill("#5D4E2D");
  strokeWeight(0);
  ellipse(width/20*14, (height/30)*27, width/10*4, height/10*2);
}

function draw_motes() {
  strokeWeight(2);
  // We work our way through our motes array...
  for (var i = 0; i < 100; i++) {
    // If the mote's alpha color is > 0 it must be a valid mote.
    if (motes[i][2] > 0) {
      // Drop the alpha till it's 0
      if (frame % 5 == 0) {
        motes[i][2] -= 5;
      }
      // Draw the mote itself
      stroke(234, 204, 31, motes[i][2]);
      point(motes[i][0], motes[i][1]);
    } else {
      // We don't want to draw all the motes at once,
      // and we aren't doing a frame thing, so we pick
      // a random number and use that.
      // 200 to 1 feels right, and makes it feel somewhat
      // organic.
      if (random(200) < 1) {
        // Find a new point inside the light beam.
        var outside = true;
        var x = 0;
        var y = 0;
        while (outside) {
          x = random(width+height);
          y = random(width+height);
          if (containsPoint(light, x, y)) {
            outside = false;
          }
        }
        motes[i][0] = x;
        motes[i][1] = y;
        // Since this gets inserted at the end of the loop,
        // we never actually draw a dot at 255 alpha.
        motes[i][2] = 255;
      }
    }
  }
  // Reset our stroke color so things aren't weird.
  stroke("#2C2C2B");
  strokeWeight(0);
}

function draw_light() {
  // We use a vector shape for our light instead of a quad
  // because we have a handy function to check if an x/y point
  // is inside a shape.
  fill(255,231,95,10);
  // Light beams don't have outlines.
  noStroke();
  beginShape();
  for (i = 0; i < light.length; ++i) {
    vertex(light[i].x,light[i].y);
  }
  endShape(CLOSE);
  stroke(0);
}

function draw_cat() {
  // Meow.
  fill("#2C2C2B");
  noStroke();
  ellipse(width/20*14, height/100*89, width/100*20, height/100*12);
  ellipse(width/100*62, height/100*86, width/100*9, height/100*6);
  triangle(width/100*58, height/100*86, width/100*61, height/100*84, width/100*57, height/100*82);
  triangle(width/100*60, height/100*84, width/100*64, height/100*84, width/50*31, height/100*81);
  strokeWeight(12);
  stroke("#2C2C2B");
  noFill();
  // We move the tail based on the twitch number, which we bounce up
  // and down with some math. We only do it part of the time,
  // because constantly moving the tail looks weird.
  arc(width/100*90, height/100*88, width/100*22, height/500*80+(twitch*3), HALF_PI, PI);
  strokeWeight(0);
  if ((frame % 5 == 0) && (frame > 50)) {
    twitch = twitch + step;
    if (twitch > 10 || twitch < 1) {
      step = step * -1;
    };
  };
}

// I'm just going to say it, I have no idea how this function works.
// Hooray, internet!

// taken from:
// http://hg.postspectacular.com/toxiclibs/src/tip/src.core/toxi/geom/Polygon2D.java
function containsPoint(verts, px, py) {
  var num = verts.length;
  var i, j = num - 1;
  var oddNodes = false;
  for (i = 0; i < num; i++) {
    var vi = verts[i];
    var vj = verts[j];
    if (vi.y < py && vj.y >= py || vj.y < py && vi.y >= py) {
      if (vi.x + (py - vi.y) / (vj.y - vi.y) * (vj.x - vi.x) < px) {
        oddNodes = !oddNodes;
      }
    }
    j = i;
  }
  return oddNodes;
}
