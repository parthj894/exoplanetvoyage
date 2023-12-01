/*
  Honors Further Topics in Physics: Relativity
  Simulation of a Colonization Voyage to Gliese 1002b
  Authors: Brandon Surpris, Ciaran Groom, and Parth Jain
  Date: 2023-12-01
*/

// rotating axes for 3D mode
float xRotation, yRotation;

// position of the ship in pixels
float shipPosX = 260.0;
// position of the ship's exhaust in relation to the ship
float exhaustPosX = 35.0;

// number of seconds that have passed
int time = 0;
// number of years on earth that have passed
float earthYears = 0.0;
float shipYears = 0.0;
// temporary variable for the number of earth years
float tempYears = 0.0;
// position of the spaceship in light years
float position = 0.0;
float properPosition = 0.0;
// acceleration of the ship in ly/y^2
float acceleration = 0.0;
// gamma value
float gamma = 1.0;
// beta value (velocity of the ship / c)
float beta = 0.0;

// shape to encompass the earth image
PShape globe;
// the earth image
PImage earth;
// shape to encompass the earth image in the proper frame
PShape properGlobe;

// shape to encompass the exoplanet image
PShape exoplanet;
// the exoplanet image
PImage gliese;
// shape to encompass the exoplanet image in the proper frame
PShape properExoplanet;

// shape to encompass the starship image
PShape box;
PShape box2;
// the starship image
PImage starship;
PImage shipExhaust;

// determines whether 2D/3D button has been pressed
boolean buttonPressed;

void setup() {

  // to draw the background window
  size(1400, 800, P3D);
  background(0);

  // to set the timer
  frameRate(60);

  // to draw Earth
  earth = loadImage("https://live.staticflickr.com/2570/3883260299_f8b3e41573_h.jpg");
  globe = createShape(SPHERE, 35);
  globe.setStroke(false);
  globe.setTexture(earth);
  
  // to draw Gliese 1002 b
  gliese = loadImage("https://www.nuketown.com/wp-content/uploads/2018/10/donjon-world.gif");
  exoplanet = createShape(SPHERE, 35);
  exoplanet.setStroke(false);
  exoplanet.setTexture(gliese);

  // to draw starship
  starship = loadImage("https://t3.ftcdn.net/jpg/04/98/45/78/360_F_498457876_6FIcGgY6SFAhH5RTJWpXWWtlvcfp4F8w.jpg");
  shipExhaust = loadImage("https://as1.ftcdn.net/v2/jpg/01/01/67/14/1000_F_101671406_Aafb8HlLDr0ze1O4Nk5xbXOT3gVb7Yc7.jpg");
  box = createShape(BOX, 50, 20, 20);
  box.setTexture(starship);
  box2 = createShape(BOX, 20, 20, 20);
  box2.setTexture(shipExhaust);

  // 3D graphics settings
  smooth();
  noStroke();
  lights();

  // text settings
  textAlign(CENTER);
}

void draw() {

  textSize(20);
  background(0);

  // draws 3D Button
  fill(0, 255, 0);
  rect(50, 80, 100, 50);
  fill(0);
  text("2D/3D", 100, 112);
  fill(255);

  if (buttonPressed == true) {
    translate(width/2, height/2);
    yRotation = map(mouseX, 0, width, 0, 360);
    xRotation = map(mouseY, 0, height, 0, 360);
    rotateY(radians(yRotation));
    rotateX(radians(xRotation));
  }

  // draws Earth and its label
  text("Earth", 200, 260, 0);
  translate(200, 200, 0);
  shape(globe);

  // draws Gliese 1002b and its label
  translate(-200, -200, 0);
  text("Gliese 1002 b", 1200, 260);
  translate(1200, 200, 0);
  shape(exoplanet);

  // draws starship
  translate(-1200, -200, 0);
  translate(shipPosX, 200, 0);
  shape(box2);
  translate(exhaustPosX, 0, 0);
  shape(box);

  // halfway line
  translate(-1 * shipPosX, -200, 0);
  stroke(255);
  strokeWeight(3);
  line(-1400, 400, 1400, 400);
  noStroke();

  // real timer
  textSize(25);
  if (time < 30) {
    time = frameCount / 60;
    text("Real Time: " + time + " sec.", 100, 50);
  } else {
    text("VOYAGE COMPLETE!", 100, 50);
  }

  // earth-frame number of years passed
  tempYears  = (frameCount / 60.0) / (30 / 17.63);
  earthYears = fixDec(tempYears, 3);
  if (earthYears < 17.63) {
    text("Earth Time: " + earthYears + " years", 1100, 50);
  } else {
    text("Earth Time: 17.63 years", 1100, 50);
  }

  // earth-frame position
  tempYears  = (frameCount / 60) / (30 / 17.63);
  earthYears = fixDec(tempYears, 3);
  if (earthYears < 8.815) {

    position = firstHalfPos(earthYears);
    position = fixDec(position, 3);
    text("Distance Traveled: " + position + " lightyears", 600, 50);
  } else if (earthYears >= 8.815 && earthYears < 17.63) {

    position = secondHalfPos(earthYears);
    position = fixDec(position, 3);
    text("Distance Traveled: " + position + " lightyears", 600, 50);
  } else {
    text("Distance Traveled: 15.8 lightyears", 600, 50);
  }

  // earth-frame distance remaining
  if (earthYears < 17.63) {
    float distRemaining = 15.8 - position;
    text("Distance Remaining: " + distRemaining + " lightyears", 600, 80);
  } else {
    text("Distance Remaining: 0.0 lightyears", 600, 80);
  }

  // earth-frame gamma
  tempYears  = (frameCount / 60.0) / (30 / 17.63);
  earthYears = fixDec(tempYears, 3);
  if (earthYears < 8.815) {

    gamma = firstHalfGamma(earthYears);
    gamma = fixDec(gamma, 3);
    text("Gamma: " + gamma, 100, 350);
  } else if (earthYears >= 8.815 && earthYears < 17.63) {

    gamma = secondHalfGamma(earthYears);
    gamma = fixDec(gamma, 3);
    text("Gamma: " + gamma, 100, 350);
  } else {
    text("Gamma: 1.0", 100, 350);
  }

  // earth-frame beta and velocity
  if (earthYears < 8.815) {

    beta = firstHalfBeta(earthYears);
    beta = fixDec(beta, 3);
    text("Beta: " + beta, 400, 350);
    text("Velocity: " + beta + "c", 750, 350);
  } else if (earthYears >= 8.815 && earthYears < 17.63) {

    beta = secondHalfBeta(earthYears);
    beta = fixDec(beta, 3);
    text("Beta: " + beta, 400, 350);
    text("Velocity: " + beta + "c", 750, 350);
  } else {
    text("Beta: 0.0", 400, 350);
    text("Velocity: 0.0c", 750, 350);
  }

  // earth-frame acceleration
  if (earthYears < 8.815) {

    acceleration = firstHalfAcc(earthYears);
    acceleration = fixDec(acceleration, 3);
    text("Acceleration: " + acceleration + " ly/yr^2", 1100, 350);
  } else if (earthYears >= 8.815 && earthYears < 17.63) {

    acceleration = secondHalfAcc(earthYears);
    acceleration = fixDec(acceleration, 3);
    text("Acceleration: " + acceleration + " ly/yr^2", 1100, 350);
  } else {
    text("Acceleration: 0.0 ly/yr^2", 1100, 350);
  }

  // number of proper-time years passed
  if (earthYears < 8.815) {

    shipYears = firstHalfShipTime(earthYears);
    shipYears = fixDec(shipYears, 3);
    text("Proper Time: " + shipYears + " years", 1100, 450);
  } else if (earthYears >= 8.815 && earthYears < 17.63) {

    shipYears = secondHalfShipTime(earthYears);
    shipYears = fixDec(shipYears, 3);
    text("Proper Time: " + shipYears + " years", 1100, 450);
  } else {
    text("Proper Time: 5.62 years", 1100, 450);
  }

  // distance in the proper-time frame
  tempYears  = (frameCount / 60) / (30 / 17.63);
  earthYears = fixDec(tempYears, 3);
  if (earthYears < 8.815) {

    properPosition = firstHalfPos(earthYears) / firstHalfGamma(earthYears);
    properPosition = fixDec(properPosition, 3);
    text("Distance Traveled: " + properPosition + " lightyears", 600, 450);
  } else if (earthYears >= 8.815 && earthYears < 17.63) {

    properPosition = secondHalfPos(earthYears) / secondHalfGamma(earthYears);
    properPosition = fixDec(properPosition, 3);
    text("Distance Traveled: " + properPosition + " lightyears", 600, 450);
  } else {
    text("Distance Traveled: 15.8 lightyears", 600, 450);
  }

  // distance remaining in the proper-time frame
  if (earthYears < 17.63) {

    float properDistRemaining = 15.8 - properPosition;
    text("Distance Remaining: " + properDistRemaining + " lightyears", 600, 480);
  } else {
    text("Distance Remaining: 0.0 lightyears", 600, 480);
  }

  // gamma in the proper-time frame
  text("Gamma: 1.0", 100, 750);

  // beta in the proper-time frame
  text("Beta: 0.0", 400, 750);

  // velocity in the proper-time frame
  text("Velocity: 0.0c", 750, 750);

  // acceleration in the proper-time frame
  if (earthYears < 8.815) {

    text("Acceleration: 1.032 ly/y^2", 1100, 750);
  } else if (earthYears >= 8.815 && earthYears < 17.63) {

    text("Acceleration: -1.032 ly/y^2", 1100, 750);
  } else {
    text("Acceleration: 0.0 ly/y^2", 1100, 750);
  }

  tempYears = (frameCount / 60.0) / (30 / 17.63);
  earthYears = fixDec(tempYears, 3);
  // animates the starship
  if (earthYears < 8.815) {

    position = firstHalfPos(earthYears);
    shipPosX = 260 + (position / 15.8) * 840;
  } else if (earthYears >= 8.815 && earthYears < 17.63) {

    position = secondHalfPos(earthYears);
    box2 = createShape(BOX, 50, 20, 20);
    box2.setTexture(starship);
    box = createShape(BOX, 20, 20, 20);
    box.setTexture(shipExhaust);
    shipPosX = 260 + (position / 15.8) * 840;
  }

  // animates the planet in the proper frame
  if (earthYears < 8.815) {
    
    properGlobe = createShape(SPHERE, 35 + 45 * (position / 7.9));
    println(35 + 60 * (position / 7.9));
    properGlobe.setTexture(gliese);
    translate(650, 600);
    shape(properGlobe);
  } else if (earthYears >= 8.815 && earthYears < 17.63) {

    properGlobe = createShape(SPHERE, 125 - 90 * (position / 15.8));
    println(125 - 90 * (position / 15.8));
    properGlobe.setTexture(earth);
    translate(650, 600);
    shape(properGlobe);
  } else {
    properGlobe = createShape(SPHERE, 35);
    properGlobe.setTexture(earth);
    translate(650, 600);
    shape(properGlobe);
  }
}

// calculates earth-frame gamma for the first half of the trip
float firstHalfGamma(float earthYears) {

  float firstHalfGamma = sqrt(1 + (1.065 * earthYears * earthYears));
  return firstHalfGamma;
}

// calculates earth-frame gamma for the second half of the trip
float secondHalfGamma(float earthYears) {

  float secondHalfGamma =
    sqrt(1 + pow((9.15 * .994 - (1.0319 * (earthYears - 8.82))), 2));
  return secondHalfGamma;
}

// calculates earth-frame beta for the first half of the trip
float firstHalfBeta(float earthYears) {

  float firstHalfGamma = firstHalfGamma(earthYears);

  float firstHalfBeta = (sqrt(pow(firstHalfGamma, 2) - 1)) / firstHalfGamma;
  return firstHalfBeta;
}

// calculates beta for the second half of the trip
float secondHalfBeta(float earthYears) {

  float secondHalfGamma = secondHalfGamma(earthYears);

  float secondHalfBeta = (sqrt(pow(secondHalfGamma, 2) - 1)) / secondHalfGamma;
  return secondHalfBeta;
}

// calculates earth-frame position for the first half of the trip
float firstHalfPos(float earthYears) {

  float firstHalfGamma = firstHalfGamma(earthYears);

  float firstHalfPos = (1 / 1.0319) * (firstHalfGamma - 1);
  return firstHalfPos;
}

// calculates earth-frame position for the second half of the trip
float secondHalfPos(float earthYears) {

  float secondHalfGamma = secondHalfGamma(earthYears);

  float secondHalfPos = (7.9 + ((1 / 1.0319) * (9.15 - secondHalfGamma)));
  return secondHalfPos;
}

// calculates earth-frame acceleration for the first half of the trip
float firstHalfAcc(float earthYears) {

  float firstHalfGamma = firstHalfGamma(earthYears);

  float firstHalfAcc = 1.0319 / (pow(firstHalfGamma, 3));
  return firstHalfAcc;
}

// calculates earth-frame acceleration for the second half of the trip
float secondHalfAcc(float earthYears) {

  float secondHalfGamma = secondHalfGamma(earthYears);

  float secondHalfAcc = -1.0319 / (pow(secondHalfGamma, 3));
  return secondHalfAcc;
}

// calculates proper time for the first half of the trip
float firstHalfShipTime(float earthYears) {

  float firstHalfGamma = firstHalfGamma(earthYears);

  float firstHalfShipTime = (1 / 1.0319) * (log(1.032 * earthYears + firstHalfGamma));
  return firstHalfShipTime;
}

// calculates proper time for the second half of the trip
float secondHalfShipTime(float earthYears) {

  float secondHalfGamma = secondHalfGamma(earthYears);

  float secondHalfShipTime = 2.815
    - (1 / 1.0319) * (log(abs((9.0951 - (1.0319 * (earthYears - 8.82)) + secondHalfGamma) / 18.257)));
  return secondHalfShipTime;
}

// rounds any floating point to three decimals
float fixDec(float n, int d) {
  return Float.parseFloat(String.format("%." + d + "f", n));
}

void mouseClicked() {

  if (mouseX >= 50 && mouseX <= 150 && mouseY >= 80 && mouseY <= 130
    && buttonPressed == false) {
    buttonPressed = true;
  } else if (mouseX >= 50 && mouseX <= 150 && mouseY >= 80 && mouseY <= 130
    && buttonPressed == true) {
    buttonPressed = false;
  }
}
