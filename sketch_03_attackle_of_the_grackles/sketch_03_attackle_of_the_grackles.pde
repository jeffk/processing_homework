// attackle of the grackles
int frame = 0;
int numgrackles = 10;
int splats_tracked = 200;
int total_splats = 0;
int tacos_eaten = 0;
int taco_drop_chance = 5;
Grackle[] grackles = new Grackle[numgrackles];
PImage splat_image;
PImage taco_truck_image;
PImage taco_image;
PImage g1;
PImage g2;
Splats splats = new Splats(splats_tracked);
Tacos tacos = new Tacos(splats_tracked);
int starttime = 0;
int endtime = 0;
boolean show_splash = true;
boolean crazy_grackles = false;

TacoTruck truck = new TacoTruck(640/2, 480/2);

void setup() {
  size(640, 480);
  background(255);
  frameRate(30);
  splat_image = loadImage("splat-small.png");
  taco_image = loadImage("taco-small.png");
  taco_truck_image = loadImage("tacotruck-small.png");
  g1 = loadImage("grackle1.png");
  g2 = loadImage("grackle2.png");
}

void do_clean() {
  total_splats = 0;
  frame = 0;
  tacos_eaten = 0;
  splats = new Splats(splats_tracked);
  tacos = new Tacos(splats_tracked);
  for (int i = 0; i < numgrackles; i++) {
    grackles[i] = new Grackle(random(height), random(width), constrain(random(7),3, 7));
    grackles[i].g1 = g1;
    grackles[i].g2 = g2;
  }
  starttime = millis();
  endtime = millis()+(1000*30);
  truck.posx = width;
}

void draw() {
  background(255);
  textAlign(CENTER);
  fill(255,0,0);
  if (show_splash) {
    textSize(24);
    text("ATTACKLE of the GRACKLES", width/2, height/20*8);
    text("Use mouse to lead", width/2, height/20*10);
    text("Click to start!", width/2, height/20*12);
    if (keyPressed && key == 's') {
      crazy_grackles = true;
      show_splash = false;
      do_clean();
    } else if (mousePressed == true) {
      show_splash = false;
      do_clean();
    }
    return;
  }
  textSize(16);
  text("ATTACKLE of the GRACKLES", width/2, height/20*1);
  textAlign(RIGHT);
  text(str(tacos_eaten)+" TACOS\n"+ str(total_splats)+" DEATHS", width/100*105, height-35);
  textAlign(LEFT);
  if (((endtime - millis())/1000) > 0) {
    text(str((endtime - millis())/1000)+" SECONDS LEFT", width/100*1, height-15);
  } else {
    text("0 SECONDS LEFT", width/100*1, height-15);
  }

  if (frame >= 30) {
    frame = 0;
  } else {
    frame++;
  }

  splats.draw();
  tacos.draw();
  truck.draw(frame);
  for (int i = 0; i < grackles.length; i++) {
    grackles[i].draw(frame);
  }  
  
  if (((endtime - millis())/1000) > 0) {
    truck.move(frame);
    for (int i = 0; i < grackles.length; i++) {
      grackles[i].move(frame, truck);
    }
  } else {
    crazy_grackles = false;
    fill(255);
    rectMode(CENTER);
    rect(width/2, height/2, width/10*8, height/10*3);
    fill(0);
    textSize(20);
    textAlign(CENTER);
    text("GAME OVER - "+str(tacos_eaten)+" TACOS, "+str(total_splats)+" DEATHS", width/2, height/20*8);
    text("Click to Play Again", width/2, height/20*12);
    String end_text = "";
    if (total_splats <= tacos_eaten && total_splats <= 5 && tacos_eaten >= 5) {
      end_text = "Amazing! Barely any casualties!";
    } else if (total_splats <= tacos_eaten) {
      end_text = "Great job, it was worth it!";
    } else if (total_splats - tacos_eaten <= 20) {
      end_text = "So close, better luck next time!";
    } else {
      end_text = "Oh no, poor grackles!";
    }
    text(end_text, width/2, height/2);
    if (mousePressed == true) {
      do_clean();
    }
  }
}

class Splats {
  float[][] splat_list;
  int splat_count = 0;
  int next_splat = 0;
  
  Splats(int sc) {
    splat_count = sc;
    splat_list = new float[splat_count][2];
  };
  
  void splat(float x, float y) {
    splat_list[next_splat][0] = x;
    splat_list[next_splat][1] = y;
    
    if (next_splat == splat_count-1) {
      next_splat = 0;
    } else {
      next_splat++;
    }
  }
  
  void draw() {
    imageMode(CENTER);
    if (splat_list.length > 0) {
      for (int i = 0; i < splat_list.length; i++) {
        if (splat_list[i][0] > 0 && splat_list[i][1] > 0) {
         image(splat_image, splat_list[i][0], splat_list[i][1], 10, 10);
        }
      }
    }
  }
}

class Tacos {
  float[][] taco_list;
  int taco_count = 0;
  int next_taco = 0;
  
  Tacos(int tc) {
    taco_count = tc;
    taco_list = new float[taco_count][2];
  };
  
  void drop(float x, float y) {
    taco_list[next_taco][0] = x;
    taco_list[next_taco][1] = y;
    
    if (next_taco == taco_count-1) {
      next_taco = 0;
    } else {
      next_taco++;
    }
  }
  
  int nibble(float x, float y) {
    int eaten = 0;
    if (taco_list.length > 0) {
      for (int i = 0; i < taco_list.length; i++) {
        if (taco_list[i][1] != 0 && taco_list[i][1] != 0) {
          if (y-taco_list[i][1] < 10 && y-taco_list[i][1] > -10 && x-taco_list[i][0] < 15 && x-taco_list[i][0] > -15) {
            taco_list[i][0] = 0;
            taco_list[i][1] = 0;
            eaten++;
          }
        }
      }
    }
    return eaten;
  }
  
  void draw() {
    imageMode(CENTER);
    if (taco_list.length > 0) {
      for (int i = 0; i < taco_list.length; i++) {
        if (taco_list[i][1] != 0 && taco_list[i][1] != 0) {
          image(taco_image, taco_list[i][0], taco_list[i][1], 44, 20);
        }
      }
    }
  }
}

class Grackle {
  float posx;
  float posy;
  boolean flapping;
  boolean flying;
  float speed;
  PImage g1;
  PImage g2;
  
  Grackle(float x, float y, float sp) {
    posx = x;
    posy = y;
    speed = sp;
    flapping = false;
    flying = true;
  }
  
  void draw(int frame) {
    imageMode(CENTER);
    if (flying) {
      if (frame % 5 == 0) { 
        flapping = !flapping;
      }
      if (flapping) {
        image(g1, posx, posy, 25, 18);
      } else {
        image(g2, posx, posy, 25, 18);
      }
    }
    // This code draws grackles with shapes, but they aren't
    // as pretty, so I took it out.
    //fill(0);
    //stroke(0);
    //arc(posx-5, posy+0, 32, 29, PI, PI*2, CHORD);
    //arc(posx+19, posy+0, 51, 44, 0, PI, CHORD);
    
    //triangle(posx-35, posy-0, posx-4, posy-0, posx-8, posy-15);
    //triangle(posx+27, posy+16, posx+68, posy-8, posx+21, posy+0);
    //strokeWeight(1);
    //line(posx+22, posy+0, posx+14, posy+30);
    //line(posx+14, posy+30, posx+12, posy+30);
    //line(posx+14, posy+30, posx+16, posy+31);
    //line(posx+14, posy+30, posx+13, posy+31);

    //line(posx+26, posy+0, posx+18, posy+30);
    //line(posx+18, posy+30, posx+16, posy+30);
    //line(posx+18, posy+30, posx+20, posy+31);
    //line(posx+18, posy+30, posx+17, posy+31);
    //stroke(#f6e200);
    //strokeWeight(3);
    //point(posx-4, posy-8);
    //strokeWeight(0);
    //draw_wing(frame);
  }
  
  void move(int frame, TacoTruck truck) {
    int eaten = tacos.nibble(posx, posy);
    tacos_eaten += eaten;
    float theta;
    if (truck.posy-posy < 50 && truck.posy-posy > -50 && truck.posx-posx < 50 && truck.posx-posx > -50) {
      // Run away!
      splats.splat(posx, posy);
      posx = random(width);
      posy = random(height);
      total_splats++;
      
      // This code moves grackles away from the trucks, if you don't want
      // them to get splatted.
      //theta = random(TWO_PI);
      ////theta = atan2(posy-truck.posy, posx-truck.posx);
      //posx = posx+cos(theta)*(speed*5);
      //posy = posy+sin(theta)*(speed*5);
    } else {
      // Try this to attract them to the truck instead
      // of the mouse. ie: Players: 0
      // The only way for the grackles to win is not to play.
      if (crazy_grackles) {
        theta = atan2(truck.posy-posy, truck.posx-posx);
      } else {
        theta = atan2(mouseY-posy, mouseX-posx);
      }
      posx = posx+cos(theta)*speed;
      posy = posy+sin(theta)*speed;

    }
  }

  // Not used since we switched to sprites.
  //void draw_wing(int frame) {
  //  if (flying) {
  //    if (frame % 4 == 0) { 
  //      flapping = !flapping;
  //    }
  //    fill(0);
  //    stroke(0);
  //    if (flapping) {
  //      triangle(posx+17, posy+0, posx+59, posy-29, posx+40, posy+9);
  //    } else {
  //      triangle(posx+41, posy+2, posx+64, posy+30, posx+13, posy+6);
  //    }
  //  }
  //}
}

class TacoTruck {
  float posx;
  float posy;
  float speed = 10;

  TacoTruck(float x, float y) {
    posx = x;
    posy = y;
  }
  
  void move(int frame) {
    if (random(100) <= taco_drop_chance) {
      tacos.drop(posx, posy);
    }
    posx = posx - speed;
    if (posx <= 0) {
      // Randomize the trucks speed, for a little variety.
      speed = constrain(random(12), 8, 12);
      posx = width;
      // Don't put the truck too close to the top or bottom of the screen.
      posy = constrain(random(height),100, height-100);
    }
  }
    
  void draw(int frame) {
    strokeWeight(2);
    stroke(0);
    fill(255);
    imageMode(CENTER);
    image(taco_truck_image, posx, posy, 100, 78);
  }
}