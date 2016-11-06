// attackle of the grackles
// Sounds from freesound.org
// https://freesound.org/people/yottasounds/sounds/232135/
// https://freesound.org/people/steffcaffrey/sounds/262308/
// https://freesound.org/people/LOVEBURD/sounds/329612/

// Music is sampled from La Bodeguita de Medio by Laszlo Harsanyi
// http://freemusicarchive.org/music/Harsanyi_Laszlo/Havana_Heat/1_-_La_Bodeguita_del_Medio

var frame = 0;
var numgrackles = 10;
var splats_tracked = 200;
var total_splats = 0;
var tacos_eaten = 0;
var taco_drop_chance = 5;
var grackles = new Array();
var splat_image;
var splash_image;
var header_image;
var taco_truck_image;
var taco_image;
var g1;
var g2;
var splats = new Splats(splats_tracked);
for (var i = 0; i < splats_tracked; i++) {
  splats[i] = [0,0]
}

var tacos = new Tacos(splats_tracked);
for (var i = 0; i < splats_tracked; i++) {
  tacos[i] = [0,0]
}
var splat_sound;
var happy_sound;
var honk_sound;
var music_sound;
var starttime = 0;
var endtime = 0;
var show_splash = true;
var played_horn = false;
var crazy_grackles = false;
var mykey = '';
var kpressed = false;
var mpressed = false;

var truck = new TacoTruck(window.innerWidth/2, window.innerHeight/2);
function preload() {
  happy_sound = loadSound("data/happy.wav");
  honk_sound = loadSound("data/honk.wav");
  music_sound = loadSound("data/La_Bodeguita_del_Medio.mp3");
  splat_sound = loadSound("data/splat.wav");
}

function setup() {
  createCanvas(window.innerWidth, window.innerHeight);
  background(255);
  // frameRate(30);
  splat_image = loadImage("data/splat-small.png");
  splash_image = loadImage("data/splash.png");
  header_image = loadImage("data/header.png");
  taco_image = loadImage("data/taco-small.png");
  taco_truck_image = loadImage("data/tacotruck-small.png");
  g1 = loadImage("data/grackle1.png");
  g2 = loadImage("data/grackle2.png");
}

function do_clean() {
  total_splats = 0;
  frame = 0;
  tacos_eaten = 0;
  splats = new Splats(splats_tracked);
  tacos = new Tacos(splats_tracked);
  for (var i = 0; i < numgrackles; i++) {
    grackles[i] = new Grackle(random(height), random(width), constrain(random(7),3, 7));
    grackles[i].g1 = g1;
    grackles[i].g2 = g2;
  }
  starttime = millis();
  endtime = millis()+(1000*30);
  truck.posx = width;
  music_sound.play();
}

function keyTyped() {
  if (key === 's') {
    mykey = 's';
    kpressed = true;
  }
}

function mousePressed() {
  mpressed = true;
}


function draw() {
  background(255);
  textAlign(CENTER);
  imageMode(CENTER);
  fill(255,0,0);
  if (show_splash) {
    //textSize(24);
    //text("ATTACKLE of the GRACKLES", width/2, height/20*8);
    //text("Use mouse to lead", width/2, height/20*10);
    //text("Click to start!", width/2, height/20*12);
    image(splash_image, width/2, height/2, 640, 480);
    if (!played_horn) {
        honk_sound.play();
        played_horn = true;
    }
    if (kpressed &&  mykey === 's') {
      crazy_grackles = true;
      show_splash = false;
      kpressed = false;
      mykey = '';
      do_clean();
    } else if (mpressed == true) {
      show_splash = false;
      mpressed = false;
      do_clean();
    }
    return;
  }
  image(header_image, width/2, 25, 176, 16);

  textSize(16);
  //text("ATTACKLE of the GRACKLES", width/2, height/20*1);
  textAlign(RIGHT);
  text(str(tacos_eaten)+" TACOS\n"+ str(total_splats)+" DEATHS", width-width/100*1, height-35);
  textAlign(LEFT);
  if (((endtime - millis())/1000) > 0) {
    text(str((endtime - millis())/1000).split(".")[0]+" SECONDS LEFT", width/100*1, height-15);
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
  for (var i = 0; i < grackles.length; i++) {
    grackles[i].draw(frame);
  }  
  
  if (((endtime - millis())/1000) > 0) {
    truck.move(frame);
    for (var i = 0; i < grackles.length; i++) {
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
    var end_text = "";
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
    if (kpressed && key == 's') {
      crazy_grackles = true;
      do_clean();
    } else if (mpressed == true) {
      mpressed = false;
      do_clean();
    }
  }
}

function Splats(sc) {
  this.next_splat = 0;
  this.splat_count = sc;
  this.splat_list = Array();
  for (var i = 0; i < sc; i++) {
    this.splat_list[i] = [0,0]
  }

  this.splat = function(x, y) {
    this.splat_list[this.next_splat][0] = x;
    this.splat_list[this.next_splat][1] = y;
    
    if (this.next_splat == this.splat_count-1) {
      this.next_splat = 0;
    } else {
      this.next_splat++;
    }
  }
  
  this.draw = function() {
    imageMode(CENTER);
    if (this.splat_list.length > 0) {
      for (var i = 0; i < this.splat_list.length; i++) {
        if (this.splat_list[i][0] > 0 && this.splat_list[i][1] > 0) {
         image(splat_image, this.splat_list[i][0], this.splat_list[i][1], 10, 10);
        }
      }
    }
  }
}

function Tacos(tc) {
  this.taco_list = Array();
  this.taco_count = tc;
  this.next_taco = 0;
  for (var i = 0; i < tc; i++) {
    this.taco_list[i] = [0,0]
  }

  this.drop = function(x, y) {
    this.taco_list[this.next_taco][0] = x;
    this.taco_list[this.next_taco][1] = y;
    
    if (this.next_taco == this.taco_count-1) {
      this.next_taco = 0;
    } else {
      this.next_taco++;
    }
  }
  
  this.nibble = function(x, y) {
    var eaten = 0;
    if (this.taco_list.length > 0) {
      for (var i = 0; i < this.taco_list.length; i++) {
        if (this.taco_list[i][1] != 0 && this.taco_list[i][1] != 0) {
          if (y-this.taco_list[i][1] < 10 && y-this.taco_list[i][1] > -10 && x-this.taco_list[i][0] < 15 && x-this.taco_list[i][0] > -15) {
            this.taco_list[i][0] = 0;
            this.taco_list[i][1] = 0;
            happy_sound.play();
            eaten++;
          }
        }
      }
    }
    return eaten;
  }
  
  this.draw = function() {
    imageMode(CENTER);
    if (this.taco_list.length > 0) {
      for (var i = 0; i < this.taco_list.length; i++) {
        if (this.taco_list[i][1] != 0 && this.taco_list[i][1] != 0) {
          image(taco_image, this.taco_list[i][0], this.taco_list[i][1], 44, 20);
        }
      }
    }
  }
}

function Grackle(x, y, sp) {
  this.posx = x;
  this.posy = y;
  this.flapping = false;
  this.flying = true;
  this.speed = sp;
  this.g1;
  this.g2;
  
  this.draw = function(frame) {
    imageMode(CENTER);
    if (this.flying) {
      if (frame % 5 == 0) { 
        this.flapping = !this.flapping;
      }
      if (this.flapping) {
        image(this.g1, this.posx, this.posy, 25, 18);
      } else {
        image(this.g2, this.posx, this.posy, 25, 18);
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
  
  this.move = function(frame, truck) {
    eaten = tacos.nibble(this.posx, this.posy);
    tacos_eaten += eaten;
    var theta;
    if (truck.posy-this.posy < 50 && truck.posy-this.posy > -50 && truck.posx-this.posx < 50 && truck.posx-this.posx > -50) {
      // Run away!
      splats.splat(this.posx, this.posy);
      this.posx = random(width);
      this.posy = random(height);
      splat_sound.play();
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
        theta = atan2(truck.posy-this.posy, truck.posx-this.posx);
      } else {
        theta = atan2(mouseY-this.posy, mouseX-this.posx);
      }
      this.posx = this.posx+cos(theta)*this.speed;
      this.posy = this.posy+sin(theta)*this.speed;

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

function TacoTruck(x, y) {
  this.posx = x;
  this.posy = y;
  this.speed = 10;

  this.move = function(frame) {
    if (random(100) <= taco_drop_chance) {
      tacos.drop(this.posx, this.posy);
    }
    this.posx = this.posx - this.speed;
    if (this.posx <= 0) {
      // Randomize the trucks speed, for a little variety.
      this.speed = constrain(random(12), 8, 12);
      this.posx = width;
      // Don't put the truck too close to the top or bottom of the screen.
      this.posy = constrain(random(height),100, height-100);
    }
  }
    
  this.draw = function(frame) {
    strokeWeight(2);
    stroke(0);
    fill(255);
    imageMode(CENTER);
    image(taco_truck_image, this.posx, this.posy, 100, 78);
  }
}