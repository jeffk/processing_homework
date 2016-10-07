int twitch = 0;
int step = 1;
int frame = 0;
float[][] motes = new float[100][3];
PVector light[] = new PVector[4];

// Todo: Standardize on width/100 or something more granular
// for all math so we can actually resize the screen.

void setup() {
  size(500,500);

  light[0]=new PVector(width/50*10, (width/50)*21);
  light[1]=new PVector(width/50*28, (width/50)*50);
  light[2]=new PVector(width/50*52, (width/50)*50);
  light[3]=new PVector(width/50*21, width/50*10);

}

void draw() {
  // We create a frame loop because things move too fast in the draw loop
  // to animate with. This lets us draw at full speed, but slow some things
  // down.
  frame++;
  if (frame >= 100) {
    frame = 0;
  };
  // Clear the background and draw the objects.
  background(#504844);
  draw_floor();
  draw_door();
  draw_window();
  draw_painting();
  draw_rug();
  draw_cat();
  draw_light();
  draw_motes();
}

void draw_floor() {
  fill(#6A625E);
  strokeWeight(0);
  rect(0, width/4*3, width, width/1);  
}

void draw_door() {
  fill(#484743);
  strokeWeight(0);
  rect(width/20*3, (width/20)*3, width/30*10, width/10*6);
  fill(#363636);
  ellipse(width/20*4, (width/20)*10, width/25, width/25);
}

void draw_window() {
  fill(#E8D794);
  strokeWeight(0);
  rect(width/10*2, (width/10)*2, width/10, width/10);
  rect((width/10*3)+width/50, ((width/10)*2), width/10, width/10);
  rect(width/10*2, ((width/10)*3)+width/50, width/10, width/10);
  rect((width/10*3)+width/50, ((width/10)*3)+width/50, width/10, width/10);
}

void draw_painting() {
  // It's easier to draw rectangles from the center when we're
  // drawing them centered over each other.
  rectMode(CENTER);
  fill(#413e36);
  strokeWeight(0);
  rect(width/20*15, (width/20)*7, width/20*5, width/20*5);
  fill(#575249);
  rect(width/20*15, (width/20)*7, width/20*4, width/20*4);
  // Reset rectMode back so it doesn't break everything else.
  rectMode(CORNER);
  fill(#504530);
  noStroke();
  ellipse(width/20*15, (width/20)*7, width/20*2, width/20*3);
  fill(#463d2e);
  ellipse(width/20*15, (width/40)*12, width/40*1, width/40*2);
  ellipse(width/20*15, (width/20)*6, width/20*2, width/20*1);
  strokeWeight(0);
}

void draw_rug() {
  // This should probably be a different shape, wider in the front
  // and narrower in the back, but ellipse is what we've got, so it's
  // what we'll use.
  fill(#5D4E2D);
  strokeWeight(0);
  ellipse(width/20*14, (width/30)*27, width/10*4, width/10*2);
}

void draw_motes() {
  strokeWeight(1);
  // We work our way through our motes array...
  for (int i = 0; i < 100; i++) {
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
        boolean outside = true;
        float x = 0;
        float y = 0;
        while (outside) {
          x = random(500);
          y = random(500);
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
  stroke(#2C2C2B);
  strokeWeight(0);
}

void draw_light() {
  // We use a vector shape for our light instead of a quad
  // because we have a handy function to check if an x/y point
  // is inside a shape.
  fill(255,231,95,10);
  // Light beams don't have outlines.
  noStroke();
  beginShape();
  for(PVector v : light) {
    vertex(v.x,v.y);
  }
  endShape(CLOSE);
  stroke(0);
}

void draw_cat() {
  // Meow.
  fill(#2C2C2B);
  noStroke();
  ellipse(width/20*14, width/30*27, width/20*4, width/50*7);
  ellipse(width/50*31, width/50*42, width/50*4, width/50*4);
  triangle(width/100*58, width/100*84, width/100*61, width/100*82, width/100*57, width/100*80);
  triangle(width/50*30, width/50*41, width/50*32, width/50*41, width/50*31, width/50*39);
  strokeWeight(8);
  stroke(#2C2C2B);
  noFill();
  // We move the tail based on the twitch number, which we bounce up
  // and down with some math. We only do it part of the time,
  // because constantly moving the tail looks weird.
  arc(width/50*45, width/50*44, width/50*11, width/500*80+(twitch), HALF_PI, PI);
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
boolean containsPoint(PVector[] verts, float px, float py) {
  int num = verts.length;
  int i, j = num - 1;
  boolean oddNodes = false;
  for (i = 0; i < num; i++) {
    PVector vi = verts[i];
    PVector vj = verts[j];
    if (vi.y < py && vj.y >= py || vj.y < py && vi.y >= py) {
      if (vi.x + (py - vi.y) / (vj.y - vi.y) * (vj.x - vi.x) < px) {
        oddNodes = !oddNodes;
      }
    }
    j = i;
  }
  return oddNodes;
}