class Enemy {
    PVector position;
    PVector StartPosition;
    float speed;
    float StartSpeed;
    float minY, maxY;

    Enemy(float startX, float startY, float speed, float minY, float maxY) {
        this.position = new PVector(startX, startY);
        this.speed = speed;
        this.minY = minY;
        this.maxY = maxY;
        
        this.StartPosition = new PVector(startX, startY);
        this.StartSpeed = speed;
    }

    void update() {
        // Move the enemy up and down
        position.y += speed;

        // Reverse direction when hitting the boundaries
        if (position.y <= minY || position.y >= maxY) {
            speed *= -1; 
        }
    }

    void display() {
        noStroke();
        fill(255, 0, 0);
        ellipse(position.x, position.y, 30, 30); 
    }
    
    void reset(){
      position= StartPosition.copy();
      speed= StartSpeed;
    }
    
   

}
