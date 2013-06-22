

import codeanticode.gsvideo.*;
import monclubelec.javacvPro.*; 
import java.awt.*;

GSCapture cam;
PImage img;
Rectangle[] faceRect; 
OpenCV opencv;

PImage cuurent;
int currImage = 0;
PImage[] pippiHair = new PImage[4];
float factor = 2; 
float max_blur = 3;
int max_blur_img = 20;
PImage[] blurM = new PImage[max_blur_img];

void setup() {
  size(640, 480);
  frameRate(60); 

  // Capture
  cam = new GSCapture(this, width/2, height/2);
  opencv = new OpenCV(this);
  opencv.allocate(width/2, height/2); 
  cam.start();
  opencv.cascade("/usr/local/share/OpenCV/haarcascades/","haarcascade_frontalface_alt.xml");

  // Images
  pippiHair[0] = loadImage("Pippi/pippi_0.png");
  pippiHair[1] = loadImage("Pippi/pippi_1.png");
  pippiHair[2] = loadImage("Pippi/pippi_2.png");
  pippiHair[3] = loadImage("Pippi/pippi_3.png");
  
  createBlur(pippiHair[currImage]);

}

void draw() {
  //background(0);

  if (cam.available() == true) {
    // Read Cam
    cam.read();
    
    // Assign Image
    img = cam.get();
    
    // Pass to OpenCV    
    opencv.copy(img);
    
    //  FLip Image
    scale(2.0);
    //scale(-1,1);
    image(img, 0, 0);
  
    // Faces
    faceRect = opencv.detect(true);
    opencv.drawRectDetect(true);
    
    for(int i = 0; i < faceRect.length; i++ ) {
      float fh = faceRect[i].height;
      float fw = faceRect[i].width;
      float xoffset = 0.92 * fw;
      float yoffset = 0.92 * fh;
      float xoffset2 = -0.1 * fw;    
      float yoffset2 = 0.35 * fh;
      float Iheight = factor * fh + 2 * xoffset;
      float Iwidth = factor * pippiHair[currImage].width * fh / pippiHair[currImage].height + 2 * yoffset;
      float fx = width + xoffset2 + xoffset - factor * faceRect[i].x- Iwidth; 
      float fy = -yoffset2 - yoffset + factor * faceRect[i].y + 0.0 * Iheight;
      float depth_factor = min(max(0, 0.6 * (pippiHair[currImage].height / Iheight) -1.0), 1);
      int tint_factor = int(240 - depth_factor * 60);
      int blur_idx = floor((max_blur_img-1) * depth_factor);
  
      pushStyle();
        tint(tint_factor);
        image(blurM[blur_idx], fx, fy,Iwidth/2, Iheight/2);
      popStyle();
    }

  }
  println(frameRate);
}

public void createBlur(PImage Emask) {
  for (int i = 0; i < blurM.length; i++) {
    float blur_factor = max_blur * pow(i / blurM.length, 2);  
    blurM[i] = new PImage(pippiHair[currImage].width, pippiHair[currImage].height, ARGB);
    blurM[i].copy(pippiHair[currImage], 0, 0, pippiHair[currImage].width, pippiHair[currImage].height, 0, 0, pippiHair[currImage].width, pippiHair[currImage].height);  
    blurM[i].filter(BLUR, blur_factor);
  }
}

public void takePicture() {
  String filename="Saved/faces_" + nf(day(),2) + "_"  + nf(hour(),2) + "-"  + nf(minute(),2) + "-"  + nf(second(),2);
  saveFrame(filename + ".jpg");
  println("taken photo");

}

public void keyPressed() {    
  if(key == ' ') {
    takePicture();
  }
}

public void stop() {
  delay(2000);
  cam.stop();
  super.stop();
}

