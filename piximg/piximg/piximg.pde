String[] fileNames; 
int imgIdx;
int imgProgress;

void setup() {
  size(512,512);
  frameRate(8);
  
  loadImgs();
  imgIdx = 0;
  imgProgress = 1;
}

void draw() {
  background(0);
  drawImage();
}

void loadImgs() {
  String path = sketchPath();
  path = path + "\\images";
  File file = new File(path); 
  if (file.isDirectory()) {
    fileNames = file.list();
  }
}

void drawImage() {
  String fileName = fileNames[imgIdx];
  PImage image = loadImage("\\images\\" + fileName);
  
  loadPixels();
  image.loadPixels();
  
  int ppr = getPPR(image, imgProgress);
  
  ColorSquare[][] boxes = breakIntoBoxes(image, imgProgress);
  for (int i = 0; i < boxes.length; i++) {
    for (int j = 0; j < boxes[i].length; j++) {
       for (int k = 0; k < boxes[i][j].getWidth(); k++) {
         for (int l = 0; l < boxes[i][j].getHeight(); l++) {
           int loc = (i * ppr + k) + (j * ppr + l) * image.width;
           pixels[loc] = boxes[i][j].get(k,l);
         }
       }
    }
  }

  updatePixels();
  
  if (frameCount % 10 == 0) {
    imgIdx = (imgIdx + 1) % 3;
  }
  imgProgress *= 2;
   if (imgProgress > width) {
     imgProgress = 1; 
   }
}

ColorSquare[][] breakIntoBoxes(PImage image, int numBoxesPerRow) {
  image.loadPixels();
  ColorSquare[][] boxes = new ColorSquare[numBoxesPerRow][numBoxesPerRow];
  
  int ppr = getPPR(image, numBoxesPerRow);
  
  for (int i = 0; i < numBoxesPerRow; i++) {
    for (int j = 0; j < numBoxesPerRow; j++) {
       boxes[i][j] = new ColorSquare(ppr,i,j,image);
       boxes[i][j].processColor();
    }
  }
  
  return boxes;
}

int getPPR(PImage image, int numBoxesPerRow) {
  int ppr = image.width;
  while (numBoxesPerRow > 1) {
    ppr /= 2;
    numBoxesPerRow /= 2;
  }
  return ppr;
}

class ColorSquare {
   color[][] __pixels;
   int __height; 
   int __width; 
   
   ColorSquare(int ppr, int boxX, int boxY, PImage image) {
     this.__width = this.__height = ppr;
     this.__pixels = new color[this.__width][this.__height];
     
     image.loadPixels();
     
     for (int x = (this.__width * boxX), i = 0; x < (this.__width * (boxX + 1)); x++, i++) {
       for (int y = (this.__height * boxY), j = 0; y < (this.__height * (boxY + 1)); y++, j++) {
         this.__pixels[i][j] = image.pixels[x + y * image.width]; 
       }
     }
   }
   
   private boolean __inBounds(int i, int j) {
     return (i < this.__width) && (j < this.__height); 
   }
   
   color get(int i, int j) {
     if (this.__inBounds(i,j)) {
       return this.__pixels[i][j];
     } else {
       return -1;
     }
   }
   
   void set(int i, int j, color c) {
     if (this.__inBounds(i,j)) {
       this.__pixels[i][j] = c; 
     }
   }
   
   void processColor() {
     int r, g, b;
     r = 0; 
     g = 0;
     b = 0;
     for (int i = 0; i < this.__width; i++) {
       for (int j = 0; j < this.__height; j++) {
         color pixel = this.get(i,j);
         r += red(pixel);
         g += green(pixel);
         b += blue(pixel);
       }
     }
     
     r /= this.__width * this.__height;
     g /= this.__width * this.__height;
     b /= this.__width * this.__height;
     
     color newColor = color(r,g,b);
     
     for (int i = 0; i < this.__width; i++) {
       for (int j = 0; j < this.__height; j++) {
         this.set(i,j,newColor);
       }
     }
   }
   
   int getWidth() {
     return this.__width;
   }
   
   int getHeight() {
     return this.__height;
   }
}
