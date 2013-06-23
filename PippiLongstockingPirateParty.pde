
// IMPORTS

import javax.media.opengl.GL2;
import javax.media.opengl.GL;
import codeanticode.gsvideo.*;
import monclubelec.javacvPro.*; 
import java.awt.*;
import controlP5.*;

// DECLARATIONS

GSCapture cam;
Rectangle[] faceRect; 
OpenCV opencv;
ControlP5 cp5;
RadioButton wig, patch;
PGraphics pg;
//PGraphicsOpenGL pg;
//PGL pgl;
//GL2 gl; 

// VARIABLES

boolean showPippi, showPirate;
PImage img;
int currentPippi = 0;
int currentPirate = 0;
PImage[] pippiHair = new PImage[4];
PImage[] piratePatch = new PImage[4];

int screenW = 640;
int screenH = 480;
int camW = 320;
int camH = 240;
float factor = 2; 

float additional_Scale = 1.0;
int x_offset = 0;
int y_offset = 0;



// SETUP

void setup() {
  // Screen
  size(screenW + 250, screenH, P2D);
  frameRate(60); 
  
  // Buffer
  pg = createGraphics(screenW, screenH);

  // Capture
  cam = new GSCapture(this, camW, camH);
  opencv = new OpenCV(this);
  opencv.allocate(camW, camH);
  cam.start();
  opencv.cascade("/usr/local/share/OpenCV/haarcascades/", "haarcascade_frontalface_alt.xml");

  // Images
  pippiHair[0] = loadImage("Pippi/pippi_0.png");
  pippiHair[1] = loadImage("Pippi/pippi_1.png");
  pippiHair[2] = loadImage("Pippi/pippi_2.png");
  pippiHair[3] = loadImage("Pippi/pippi_3.png");
  
  piratePatch[0] = loadImage("Pirate/pirate_0.png");
  piratePatch[1] = loadImage("Pirate/pirate_1.png");
  piratePatch[2] = loadImage("Pirate/pirate_2.png");
  piratePatch[3] = loadImage("Pirate/pirate_3.png");
  
  // GUI
  cp5 = new ControlP5(this);
  
  // Scale
  cp5.addSlider("additional_Scale").setPosition(screenW + 25, 225).setSize(200, 20).setRange(-1.5, 2.5);
  cp5.getController("additional_Scale").getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  cp5.getController("additional_Scale").getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  // X Offset
  cp5.addSlider("x_offset").setPosition(screenW + 25, 275).setSize(200, 20).setRange(-250, 250);
  cp5.getController("x_offset").getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  cp5.getController("x_offset").getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  // Y Offset
  cp5.addSlider("y_offset").setPosition(screenW + 25, 325).setSize(200, 20).setRange(-250, 250);
  cp5.getController("y_offset").getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  cp5.getController("y_offset").getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  // Pippi Toggle
  cp5.addToggle("showPippi").setPosition(screenW + 25, 25).setSize(200, 20);
  // Pirate Toggle
  cp5.addToggle("showPirate").setPosition(screenW + 25, 125).setSize(200, 20);
  // Pippi Chooser
  wig = cp5.addRadioButton("WIG")
       .setPosition(screenW + 25, 75)
       .setSize(40, 20)
       .setItemsPerRow(4)
       .setSpacingColumn(10)
       .addItem("WIG_1", 0)
       .addItem("WIG_2", 1)
       .addItem("WIG_3", 2)
       .addItem("WIG_4", 3)
       ;
  wig.hideLabels();
  patch = cp5.addRadioButton("PATCH")
     .setPosition(screenW + 25, 175)
     .setSize(40, 20)
     .setItemsPerRow(4)
     .setSpacingColumn(10)
     .addItem("1", 0)
     .addItem("2", 1)
     .addItem("3", 2)
     .addItem("4", 3)
     ;
  patch.hideLabels();
  // Save Bang
  cp5.addBang("SAVE_IMAGE").setPosition(screenW + 25, 375).setSize(200, 75);
  
}

// DRAW

void draw() {
  background(0);

  if (cam.available() == true) {
    // Read Cam
    cam.read();
    
    // Assign Image
    img = cam.get();
    
    // Pass to OpenCV    
    opencv.copy(img);
    
    // Buffer
    pg.beginDraw();
      pg.pushMatrix();
        pg.scale(2.0);
        pg.image(img, 0, 0);
      
        // Faces
        faceRect = opencv.detect(false);
        
        // Scale
        pg.scale(additional_Scale);
        
        if(faceRect.length >= 1) {
          // Pippi Hair
          if(showPippi) {
            float fh = faceRect[0].height;
            float fw = faceRect[0].width;
            float xoffset = 0.92 * fw;
            float yoffset = 0.92 * fh;
            float xoffset2 = -0.1 * fw;    
            float yoffset2 = 0.35 * fh;
            float Iheight = factor * fh + 2 * xoffset;
            float Iwidth = factor * pippiHair[currentPippi].width * fh / pippiHair[currentPippi].height + 2 * yoffset;
            float fx = screenW + xoffset2 + xoffset - factor * faceRect[0].x- Iwidth; 
            float fy = -yoffset2 - yoffset + factor * faceRect[0].y + 0.0 * Iheight;
            pg.image(pippiHair[currentPippi], fx + x_offset, fy + y_offset, Iwidth/2, Iheight/2);
          }
          
          // Pirate Patch
          if(showPirate) {
            float fh = faceRect[0].height;
            float fw = faceRect[0].width;
            float xoffset = 0.92 * fw;
            float yoffset = 0.92 * fh;
            float xoffset2 = -0.1 * fw;    
            float yoffset2 = 0.35 * fh;
            float Iheight = factor * fh + 2 * xoffset;
            float Iwidth = factor * piratePatch[currentPippi].width * fh / piratePatch[currentPippi].height + 2 * yoffset;
            float fx = screenW + xoffset2 + xoffset - factor * faceRect[0].x- Iwidth; 
            float fy = -yoffset2 - yoffset + factor * faceRect[0].y + 0.0 * Iheight;
            pg.image(piratePatch[currentPirate], fx + x_offset, fy + y_offset, Iwidth/4, Iheight/4);
          }
        }
     
      pg.popMatrix();
    pg.endDraw();
  }
  
  // PGrahics
  image(pg, 0, 0);
  
  // CP5
  cp5.draw();
  
  // FPS
  if(frameCount % 600 == 0) {
    int fps = round(frameRate);
    println(" -- The Program is running at " + fps + " FPS -- ");
  }
  
}

// CP5

void controlEvent(ControlEvent theEvent) {
  if(theEvent.isFrom(wig)) {
    currentPippi = int(theEvent.getValue());
  }
  if(theEvent.isFrom(patch)) {
    currentPirate = int(theEvent.getValue());
  }
}

void SAVE_IMAGE() {
    String filename = "Saved/faces_" + nf(day(), 2) + "_"  + nf(hour(), 2) + "-"  + nf(minute(), 2) + "-"  + nf(second(), 2);
    pg.beginDraw();
      pg.save(filename + ".jpg");
    pg.endDraw();
    println("-- Saved A Photo -- ");
}

// STOP

public void stop() {
  delay(2000);
  cam.stop();
  super.stop();
}

