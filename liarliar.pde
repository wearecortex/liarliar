int rectX, rectY;     // Rectangle 'Yes' Button Dimensions
int circleX, circleY;   // Circle 'No' Button Dimensions
int rectSize = 90;     
int circleSize = 93;   
color yesButtonColor, noButtonColor, baseColor;
color yesButtonHighlight, noButtonHighlight;
color currentColor;
boolean yesButtonOver = false; // Is the mouse over the rectangle?
boolean noButtonOver = false; // Is the mouse over the circle?

String[] questionStrings = { // The questions themselves
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
String questionText = questionStrings[0]; // this variable is updated with the next question every time the user presses a button
int stringIndex = 0; // The index that keeps track of which question we're on
int[] greens = { // The matrix of green values for the question colors, all or nothing
  255, 255, 0, 255, 0, 0, 255, 0, 255, 255, 0, 0, 0, 255, 255, 0, 0, 255, 0, 255, 255, 0, 0
};
int green = greens[0]; // The green value for the questions, initialized to the first green value in greens
int[] reds = { // The matrix of red values for the question colors, all or nothing
  0, 0, 255, 0, 255, 255, 0, 255, 0, 0, 255, 255, 255, 0, 0, 255, 255, 0, 255, 0, 0, 255, 255
};
int red = reds[0]; // The red value for the questions, initialized to the first red value in reds

int savedTime; // Initialize the millisecond timers for the responses
int passedTime;

PrintWriter output; // Initialize the output file

PFont latoFont; // Initialize our font
PImage img, soloLogo; // Initialize the pictures

String typing = ""; // The strings to be used when the user types in their name
String saved = "";

boolean logoPresented = false; // Initialize the flags to false, nothing has happened yet
boolean initialized = false;
boolean instructed = false;
boolean close = false; 


int holdsecond=0; // Initialize the timer


void setup() {
  size(displayWidth, displayHeight); // Fullscreen 
  background(0);
  yesButtonColor = color(0); // Draw the buttons
  yesButtonHighlight = color(100);
  noButtonColor = color(0);
  noButtonHighlight = color(100);
  baseColor = color(102);
  circleX = width/2+circleSize/2+10;
  circleY = height/2;
  rectX = width/2-rectSize-10;
  rectY = height/2-rectSize/2;
  ellipseMode(CENTER);

  savedTime = millis(); // Start the milliseconds timer

  output = createWriter("void.txt"); // Create the output writer, though the file will be changed later

  latoFont= createFont("Lato-Light.tff", 40); // Create the Lato font
  textFont(latoFont);
  img = loadImage("cortexProcessing.png"); // Load the images
  soloLogo = loadImage("cortexLogo.png");

  holdsecond=second(); // Start the seconds timer

}

void draw() {
  background(0);
  if(second()<holdsecond+5){ // Start by displaying the logo for 5s
    image(img, 100, 100);
    //println(second() + " " + holdsecond+5);
  }
  else if (!initialized) { // Next ask the user for the filenameenterName
    enterName();
  } 
  else if(close){ // Check to see if the program is to close - if so, display the logo for 5s and exit
    holdsecond=second();
    while(second()<holdsecond+5){
      image(img, 100, 100);
      exit(); // Stops the program
    }
  }
  else{
    background(0);
    update(mouseX, mouseY); // Check constantly for mouse position
    textSize(40); // Define text size
    fill(red, green, 0); // Define text color based on matrices and index
    textFont(latoFont); // Define font
    text(questionText, 225, 225); // Write the question text
    passedTime = millis() - savedTime;
    if (yesButtonOver) { // Check if the mouse is over the Yes button and highlight it if so
      fill(yesButtonHighlight);
    } 
    else {
      fill(yesButtonColor);
    }
    stroke(255); // Draw the rest of the button
    rect(rectX, rectY, rectSize, rectSize);
    fill(255);
    text('Y', rectX+35, rectY+60);

    if (noButtonOver) { // Check if the mouse is over the No button and highlight it if so
      fill(noButtonHighlight);
    } 
    else {
      fill(noButtonColor);
    }
    stroke(255);

    ellipse(circleX, circleY, circleSize, circleSize); // 
    fill(255);
    text('N', circleX-12, circleY+12);

    image(soloLogo, displayWidth/2 - 100, displayHeight-200); // Display the logo itself at the bottom
  }



}

void enterName() { // The initial screen where the user enters their name, which is then used to save their responses and times
  background(0);
  image(soloLogo, displayWidth/2 - 100, displayHeight-200);
  int indent = 200;
  textFont(latoFont);
  text("To start, please enter your preferred name or pseudonym: ", indent, 275);
  text(typing, displayWidth/2 - 100, 400);
  text(saved, indent, 325);
}

void keyPressed() { // Used in the beginning when the user is specifying their name/pseudonym for the filename
  if (key == '\n' ) {
    saved = typing;
    output = createWriter(saved+".txt");
    typing = ""; 
    initialized = true;
  } 
  else {
    typing = typing + key;
  }
}

void update(int x, int y) { // Basically just keeps track of the mouse, makes the buttons light up if hovered over and preps them to be pressed
  if ( overNo(circleX, circleY, circleSize) ) {
    noButtonOver = true;
    yesButtonOver = false;
  } 
  else if ( overYes(rectX, rectY, rectSize, rectSize) ) {
    yesButtonOver = true;
    noButtonOver = false;
  } 
  else {
    noButtonOver = yesButtonOver = false;
  }
}

void advance(char val) { // This function advances the state of the program, moving forward through the matrices of strings and red/green colors unless the user gives a bad response to the initial questions. 
                        // This function also checks to see if the program has advanced through all strings/colors and signals the main loop to end the program if so
  output.println(stringIndex+1 + " " + val + " " + passedTime); // This writes the question number, True/False, and time passed (in millis) to the output file
  if((stringIndex==0 && val=='N') || (stringIndex==1 && val=='N') || (stringIndex==2 && val=='Y')){ // This checks to see if the user gave a bad answer to the initial questions and halts if so
    stringIndex = stringIndex;
  } 
  else { // This advances the program
    stringIndex = (stringIndex + 1);
    if (stringIndex == questionStrings.length) { // This closes the program if it's advanced through all of the questions
      output.flush(); // Writes the remaining data to the file
      output.close(); // Finishes the file
      holdsecond=second();
      close = true; // Boolean signal for the main loop to close the program
      stringIndex = stringIndex-1; // The string index has to be kept within the dimensions of the matrices otherwise the program crashes
    }
    questionText = questionStrings[stringIndex]; // Advance the string
    red = reds[stringIndex]; // Advance the red color
    green = greens[stringIndex]; // Advance the green color
  }
}

void mousePressed() { // If the user presses the mouse over a button region send that information to the advance() function
  if (noButtonOver) {
    advance('N');
  }
  if (yesButtonOver) {
    advance('Y');
  }
}

boolean overYes(int x, int y, int width, int height) { // Checks if the user is over the Yes button
  if (mouseX >= x && mouseX <= x+width && 
    mouseY >= y && mouseY <= y+height) {
    return true;
  } 
  else {
    return false;
  }
}

boolean overNo(int x, int y, int diameter) { // Checks if the user is over the No button
  float disX = x - mouseX;
  float disY = y - mouseY;
  if (sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
    return true;
  } 
  else {
    return false;
  }
}

