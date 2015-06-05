int rectX, rectY;     
int circleX, circleY;  
int rectSize = 90;     
int circleSize = 93;   
color rectColor, circleColor, baseColor;
color rectHighlight, circleHighlight;
color currentColor;
boolean rectOver = false;
boolean circleOver = false;

String[] questionStrings = {
  "     The left button means Yes and the right button means No.\n      Do you understand?", // T
  "      Green questions should be answered truthfully. \n      Do you understand?", //T
  "          Red questions should be answered falsely.\n      Do you understand?", //F
  "                Are you sitting down right now?", // F    
  "                Do airplanes have wings?", // T
  "        Did you come here with people you know?", // F
  "             Have you used a computer today?", // T
  "   Do you feel like you drank enough water today?", // T
  "   Do you feel like you got enough sleep last night?", // T
  "                 Are you a vegetarian/vegan?", // F
  "   Did you make more than one social media post today?", // F
  "                 Have you ever been to an opera?", // F
  "Have you ever read a novel more than 400 pages long?", // F
  "If you could, would you have sex with a family member?", // T
  "    Do you think some races are inherently \n                       superior to others?", // T
  "    Do you support sterilizing people \n                          who have an extremely low IQ?", // F
  "                    Do fat people disgust you?", // F
  "                Do you believe in a personal afterlife?", // T
  "            Have you ever cheated on a romantic partner?", // F
  "            Did you enjoy the first time you had sex?", // T
  "            Have you ever peed in a swimming poodl?", // T
  "                  Have you ever stolen anything?", // F
  "                 Have you ever lied about your age?"                                       // F
};
String questionText = questionStrings[0];
int stringIndex = 0;
int[] greens = {
  255, 255, 0, 255, 0, 0, 255, 0, 255, 255, 0, 0, 0, 255, 255, 0, 0, 255, 0, 255, 255, 0, 0
};
int green = greens[0];
int[] reds = {
  0, 0, 255, 0, 255, 255, 0, 255, 0, 0, 255, 255, 255, 0, 0, 255, 255, 0, 255, 0, 0, 255, 255
};
int red = reds[0];

int savedTime;
int passedTime;

PrintWriter output;

PFont latoFont;
PImage img, soloLogo;

String typing = "";
String saved = "";

boolean logoPresented = false;
boolean initialized = false;
boolean instructed = false;

int holdsecond=0;
boolean onOff = true; 

void setup() {
  size(displayWidth, displayHeight);
  background(0);
  rectColor = color(0);
  rectHighlight = color(100);
  circleColor = color(0);
  circleHighlight = color(100);
  baseColor = color(102);
  circleX = width/2+circleSize/2+10;
  circleY = height/2;
  rectX = width/2-rectSize-10;
  rectY = height/2-rectSize/2;
  ellipseMode(CENTER);

  savedTime = millis();

  output = createWriter("void.txt"); 

  latoFont= createFont("Lato-Light.tff", 40);
  textFont(latoFont);
  img = loadImage("cortexProcessing.png");
  soloLogo = loadImage("cortexLogo.png");
  
  holdsecond=second();
  
}

void draw() {
  background(0);
  if(second()<holdsecond+5){
    image(img, 100, 100);
    println(second() + " " + holdsecond+5);
  }
  else if (!initialized) {
    prenup();
  } 
  else{
    background(0);
    update(mouseX, mouseY);
    textSize(40);
    fill(red, green, 0);
    textFont(latoFont);
    text(questionText, 225, 225); 
    passedTime = millis() - savedTime;
    if (rectOver) {
    fill(rectHighlight);
    } else {
      fill(rectColor);
    }
    stroke(255);
    rect(rectX, rectY, rectSize, rectSize);
    fill(255);
    text('Y', rectX+35, rectY+60);
    
    if (circleOver) {
      fill(circleHighlight);
    } else {
      fill(circleColor);
    }
    stroke(255);
    
    ellipse(circleX, circleY, circleSize, circleSize);
    fill(255);
    text('N', circleX-12, circleY+12);
    
    image(soloLogo, displayWidth/2 - 100, displayHeight-200);
    }


  
}

void prenup() { // enter filename, basically
  background(0);
  image(soloLogo, displayWidth/2 - 100, displayHeight-200);
  int indent = 200;
  textFont(latoFont);
  text("To start, please enter your preferred name or pseudonym: ", indent, 275);
  text(typing, displayWidth/2 - 100, 400);
  text(saved, indent, 325);
 }

void keyPressed() {
  if (key == '\n' ) {
    saved = typing;
    output = createWriter(saved+".txt");
    typing = ""; 
    initialized = true;
  } else {
    typing = typing + key;
  }
}

void update(int x, int y) {
  if ( overCircle(circleX, circleY, circleSize) ) {
    circleOver = true;
    rectOver = false;
  } else if ( overRect(rectX, rectY, rectSize, rectSize) ) {
    rectOver = true;
    circleOver = false;
  } else {
    circleOver = rectOver = false;
  }
}

void advance(char val) {
  output.println(stringIndex+1 + " " + val + " " + passedTime);
  stringIndex = (stringIndex + 1);
  if (stringIndex == questionStrings.length) {
    output.flush(); // Writes the remaining data to the file
    output.close(); // Finishes the file
    exit(); // Stops the program
    stringIndex = stringIndex-1;
  }
  questionText = questionStrings[stringIndex];
  red = reds[stringIndex];
  green = greens[stringIndex];
}

void mousePressed() {
  if (circleOver) {
    advance('F');
  }
  if (rectOver) {
    advance('T');
  }
}

boolean overRect(int x, int y, int width, int height) {
  if (mouseX >= x && mouseX <= x+width && 
    mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

boolean overCircle(int x, int y, int diameter) {
  float disX = x - mouseX;
  float disY = y - mouseY;
  if (sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
    return true;
  } else {
    return false;
  }
}
