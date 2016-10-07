// What's the center of the canvas?
int center = 250;

// Declare a bunch of variables.
boolean complete = false;
float[][][] points = new float[10][30][5];
float[][][][] hard_stuff = new float[10][30][2][3];
float[][][] fluffy_stuff = new float[10][30][2];
float[] fluffy_one = new float[2];
float[] white = new float[3];

void setup() {
  // setup the blank, black canvas
  size(500,500);
  background(0);

  // draw a bunch of random white dots
  strokeWeight(1);
  stroke(255);
  for (int j = 0; j < 100; j = j+1) {
    point(random(500),random(500));
  };

  // draw a random really big dot  
  stroke(180);
  fill(180);
  boolean stuck_in_the_middle = true;
  float secondaryx = 0;
  float secondaryy = 0;
  // Try to ensure big circle a is visible and not completely 
  // behind big circle b. The right way to do this would be radius
  // but it's 1:10pm on Thursday. This usually works.
  while (stuck_in_the_middle) {
    secondaryx = random(400) + 50;
    secondaryy = random(400) + 50;
    if ((secondaryx <= 175 || secondaryx >= 325) && (secondaryy <= 175 || secondaryy >= 325)) {
        stuck_in_the_middle = false;
    };
  };
  ellipse(secondaryx, secondaryy, 75, 75);

  // draw some random grey circles on the big dot  
  stroke(200);
  // This last 0 sets the opacity of the fill to 0, so
  // it's transparent.
  fill(0,0,0,0);
  for (int j = 0; j < 20; j = j+1) {
    ellipse(secondaryx-25+random(50),secondaryy-25+random(50), 5, 5);
    //point();
  };
  
  white[0] = 255;
  white[1] = 255;
  white[2] = 255;

};

void draw() {

  float[] rgb = new float[3];
  // Only do this once.
  if (complete != true) {
    // This loop creates a matrix of x's and y's of points that form concentric
    // circles outwards from the center of the canvas. It populates the points
    // 2 dimensional array with row, column, and the x and y coordinate of the point.
    // It would be interesting to experiment with rows of different column widths
    // for more consistently sized triangles, but that's a problem for another day.
    int a = 0;
    int numPoints=30;
    for (int j = 0; j < 200; j = j+20) {
      // Math borrowed from https://processing.org/discourse/beta/num_1207766233.html
      float angle=TWO_PI/(float)numPoints;
      for(int i = 0; i < numPoints; i++) {
        point(center+(j*sin(angle*i)),center+(j*cos(angle*i)));
        points[a][i][0] = center+(j*sin(angle*i));
        points[a][i][1] = center+(j*cos(angle*i));
      }
      a++;
    };

    // Now that we have our points array, calculate some colors.
    for (int i = 0; i < points.length; i++) {
      for (int j = 0; j < points[i].length; j++) {
        // Do we have a row after this one?
        if (i+2 <= points.length) {
          // Are we at the end of the column (and need to loop back to 0)?
          if (j+1 <= points[i+1].length) {
            // Set a color based on where we are in the array.
            // Each column is made up of two triangles, so we need
            // two entries for each column.
            rgb = blueorgreen(i, j);
            hard_stuff[i][j][0] = rgb;
            rgb = blueorgreen(i, j);
            hard_stuff[i][j][1] = rgb;
            // Should we put some fluffy stuff here?
            fluffy_stuff[i][j][0] = fluffy_or_not(i, j);
            fluffy_stuff[i][j][1] = fluffy_or_not(i, j);
          };
        };
      };
    };
    // Only do the preceeding calculations once.
    complete = true;
  };
  
  if (true) {
    // Now that we have our points array, start drawing triangles.
    for (int i = 0; i < points.length; i++) {
      for (int j = 0; j < points[i].length; j++) {
        // Do we have a row after this one?
        if (i+2 <= points.length) {
          // Are we at the end of the column (and need to loop back to 0)?\
          // I should definitely DRY this up, but it's late, and it works.
          if (j+2 <= points[i+1].length) {
            // Set a color based on where we are in the array.
            if (fluffy_stuff[i][j][0] == 1) {
              rgb = white;
            } else {
              rgb = hard_stuff[i][j][0];
            };
            fill(rgb[0], rgb[1], rgb[2]);
            stroke(rgb[0], rgb[1], rgb[2]);
            // Draw a triangle for half of the box, diagonal sandwich style.
            triangle(points[i][j][0], points[i][j][1],
                 points[i+1][j][0], points[i+1][j][1], 
                 points[i+1][j+1][0], points[i+1][j+1][1]);                 
            if (fluffy_stuff[i][j][1] == 1) {
              rgb = white;
            } else {
              rgb = hard_stuff[i][j][1];
            };
            fill(rgb[0], rgb[1], rgb[2]);
            stroke(rgb[0], rgb[1], rgb[2]);
            // Other half of the sandwich.
            triangle(points[i][j][0], points[i][j][1],
                 points[i+1][j+1][0], points[i+1][j+1][1],
                 points[i][j+1][0], points[i][j+1][1]);
            
          } else {
            // Do the draw again for the last-row
            // edge cases.
            if (fluffy_stuff[i][j][0] == 1) {
              rgb = white;
            } else {
              rgb = hard_stuff[i][j][0];
            };
            fill(rgb[0], rgb[1], rgb[2]);
            stroke(rgb[0], rgb[1], rgb[2]);
            triangle(points[i][j][0], points[i][j][1],
                 points[i+1][j][0], points[i+1][j][1], 
                 points[i+1][0][0], points[i+1][0][1]);                 
            if (fluffy_stuff[i][j][1] == 1) {
              rgb = white;
            } else {
              rgb = hard_stuff[i][j][1];
            };
            fill(rgb[0], rgb[1], rgb[2]);
            stroke(rgb[0], rgb[1], rgb[2]);
            triangle(points[i][j][0], points[i][j][1],
                 points[i+1][0][0], points[i+1][0][1],
                 points[i][0][0], points[i][0][1]);                 
          };
        };
      };
    };
  
  };
  
  // Move our white stuff around the circle and the end of our loop.
  int last = 0;
  for (int i = 0; i < fluffy_stuff.length; i++) {
    // The stuff at the front of the array gets moved to the end.
    fluffy_one = fluffy_stuff[i][0];
    for (int j = 1; j < fluffy_stuff[i].length; j++) {
      fluffy_stuff[i][j-1] = fluffy_stuff[i][j];
      last = j;
    };
    fluffy_stuff[i][last] = fluffy_one;
  };
  // Sleep for a while.
  delay(250);
};

float fluffy_or_not(int x, int y) {
   // Part of the time, draw a white triangle.
   if (int(random(10)) > 8) {
     return 1;
   };
   return 0;
};

// Decide if we want blue or green on this triangle.
float[] blueorgreen(int x, int y) {
   float[] rgb = new float[3];
   if (x <= 2 || (x <= 7 && int(random(x)) < 2)) {
     // If it's in the middle, or with decreasingly probably, up
     // to the 8th row, draw green.
     rgb[0] = 52;
     rgb[1] = 188;
     rgb[2] = 66;
   } else {
     // Otherwise, draw blue.
     rgb[0] = 33;
     rgb[1] = 73;
     rgb[2] = 175;
   };
   return(rgb);
};