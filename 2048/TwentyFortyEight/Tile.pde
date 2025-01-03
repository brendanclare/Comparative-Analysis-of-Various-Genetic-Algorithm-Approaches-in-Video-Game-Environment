class Tile {
  int value;
  int x, y;
  int size;
  color tileColor;

  Tile(int x, int y, int size) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.value = 0;  // Start as an empty tile
    setTileColor();
  }

  void setValue(int value) {
    this.value = value;
    setTileColor();
  }

 void setTileColor() {
  if (value == 0) {
    tileColor = color(200, 200, 200); // Empty tile color (light gray)
  } else if (value == 2) {
    tileColor = color(255, 0, 0); 
  } else if (value == 4) {
    tileColor = color(255, 127, 0); 
  } else if (value == 8) {
    tileColor = color(255, 255, 0); 
  } else if (value == 16) {
    tileColor = color(0, 255, 0); 
  } else if (value == 32) {
    tileColor = color(0, 0, 255); 
  } else if (value == 64) {
    tileColor = color(75, 0, 130); 
  } else if (value == 128) {
    tileColor = color(148, 0, 211); 
  } else if (value == 256) {
    tileColor = color(255, 105, 180); 
  } else if (value == 512) {
    tileColor = color(255, 20, 147); 
  } else if (value == 1024) {
    tileColor = color(255, 69, 0); 
  } else if (value == 2048) {
    tileColor = color(255, 215, 0);
  } else if (value == 4096) {
    tileColor = color(0, 191, 255);
  } else {
    tileColor = color(0, 0, 0); 
  }
}



  void drawTile(int offsetX, int offsetY) {
    // Draw the tile background
    fill(tileColor);
    stroke(187, 173, 160);
    strokeWeight(4);
    rect(x * size + offsetX, y * size + offsetY, size, size, 10);

    // If the value is greater than 0, draw the number
    if (value > 0) {
      fill(0);  // Text color (black)
      textSize(32);
      text(value, x * size + size / 2 + offsetX, y * size + size / 2 + offsetY);
    }
  }
}
