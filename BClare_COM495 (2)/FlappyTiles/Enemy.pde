class Enemy {
  float x; // x-coordinate
  float y; // y-coordinate
  float speed; // horizontal speed

  Enemy(float x, float y, float speed) {
    this.x = x;
    this.y = y;
    this.speed = speed;
  }
  

  void update() {
    x -= speed; // Move the enemy to the left
  }

  void display() {
    fill(255, 0, 0); // Set the fill color for enemies (e.g., red)
    rect(x, y, 50, 100); // Draw the enemy as a rectangle (adjust size as needed)
  }
  
 boolean collided(float playerX, float playerY, float playerWidth, float playerHeight) {
  // Check for collision using the rectangle intersection method
  return x < playerX + playerWidth &&
         x + 50 > playerX &&
         y < playerY + playerHeight &&
         y + 100 > playerY;
}
}
