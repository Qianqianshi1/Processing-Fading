import gifAnimation.*;

GifMaker gifExport;

color FG = #111111;
color BG = #f1f1f1;
color m = #585555;
PGraphics pg;
PImage img;
float posX;
float posY;
float scaling = 1;


void setup(){
  img = loadImage("OriginalImage.jpg");
  pg = createGraphics(800, img.height);
  size(800, img.height - 50, P2D);
  //pixelDensity(2); // set for high resolution, used in fix number
  shapeMode(CENTER);
  rectMode(CENTER);
  textMode(SHAPE); // control text
  
  noCursor(); // hindes the cursor from view
  noStroke(); // disables drawing the stroke
  ellipseMode(CENTER);
  //set gif
  //frameRate(12);
  gifExport = new GifMaker(this, "ExportGIF.gif");
  gifExport.setRepeat(0);

}

void draw(){
  background(BG);
  img.resize((int)800, 0);
  pg.beginDraw();
  pg.background(BG);
  pg.noStroke();
  
  float fader1 = 0.5;
  float fader3 = 1;
  float fader4 = 0.5;
  float fader5 = 0.3;
  float fader6 = 0;
  float pg1res = map(fader3, 0, 1, 1, 900);
  float pg1step = width / pg1res;
  
  for (float x=0; x<img.width; x+=pg1step){
    for (float y=0; y<img.height; y+=pg1step){
      int pixelX = int(x+(posX*scaling));
      int pixelY = int(y+(posY*scaling));
      
      color pixel = img.get(pixelX, pixelY);
      float bri = brightness(pixel);
      pg.fill(pixel);
      
      float size = map(bri, 0, 255, map(fader4, 0, 1, 0, 10), 0);
      pg.pushMatrix();
      pg.translate(x, y);
      pg.rect(0, 0, size, size);
      pg.popMatrix();
    }
  }
  pg.endDraw();
  
  float tilesX = map(fader5, 0, 1, 1, 80);
  float tilesY = map(fader6, 0, 1, 1, 80);
  float tileW = width/tilesX;
  float tileH = width/tilesY;
  
  float rangeX = map(fader1, 0, 1, 0, 220);
  
  float acc = 5;
  
  for (int x = 0; x < tilesX; x++){
    for (int y = 0; y < tilesY; y++){
      int verschiebungX = (int)map(sin(radians(frameCount*acc+(x*11+(y*11)))), -1, 1, -rangeX, rangeX);
      copy(pg, x*(int)tileW+verschiebungX, y*(int)tileH, (int)tileW, (int)tileH, x*(int)tileW, y*(int)tileH, (int)tileW, (int)tileH);
    }
  }
  
  gifExport.setDelay(1);
  gifExport.addFrame();
}

void mousePressed() {
    gifExport.finish();                 // write file
}
