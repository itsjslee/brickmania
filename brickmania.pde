// Joshua Lee
// Period 7 APCSP
// Brickmania: Developed with Java in Processing


// Paddle
int paddleX, paddleY, paddleWidth = 100, paddleHeight = 20;

// Ball
int ballX, ballY, ballDiameter = 20;
int ballSpeedX = 3, ballSpeedY = 3;

// Bricks
int brickRows = 5, brickCols = 8;
int brickWidth, brickHeight;
boolean[][] bricks;

// Game state variables
int score = 0, lives = 3;

void settings() {
    size(600, 800); // Set the canvas size
}

void setup() {
    // Initialize paddle position
    paddleX = width / 2 - paddleWidth / 2;
    paddleY = height - 50;

    // Initialize ball position
    ballX = width / 2;
    ballY = height / 2;

    // Initialize brick dimensions and states
    brickWidth = width / brickCols;
    brickHeight = 30;
    bricks = new boolean[brickRows][brickCols];
    for (int r = 0; r < brickRows; r++) {
        for (int c = 0; c < brickCols; c++) {
            bricks[r][c] = true; // All bricks are unbroken at start
        }
    }

    textSize(16);
    textAlign(CENTER, CENTER);
}

void draw() {
    background(0);

    // Draw paddle
    fill(255);
    rect(paddleX, paddleY, paddleWidth, paddleHeight);

    // Draw ball
    ellipse(ballX, ballY, ballDiameter, ballDiameter);

    // Draw bricks
    for (int r = 0; r < brickRows; r++) {
        for (int c = 0; c < brickCols; c++) {
            if (bricks[r][c]) {
                fill(255, 0, 0);
                rect(c * brickWidth, r * brickHeight, brickWidth, brickHeight);
            }
        }
    }

    // Display score and lives
    fill(255);
    text("Score: " + score, width / 4, 20);
    text("Lives: " + lives, 3 * width / 4, 20);

    // Update ball position
    ballX += ballSpeedX;
    ballY += ballSpeedY;

    // Ball-wall collision
    if (ballX <= 0 || ballX >= width) ballSpeedX *= -1;
    if (ballY <= 0) ballSpeedY *= -1;

    // Ball-paddle collision
    if (ballX > paddleX && ballX < paddleX + paddleWidth &&
        ballY + ballDiameter / 2 >= paddleY) {
        ballSpeedY *= -1;
    }

    // Ball-brick collision
    for (int r = 0; r < brickRows; r++) {
        for (int c = 0; c < brickCols; c++) {
            if (bricks[r][c]) {
                int brickX = c * brickWidth;
                int brickY = r * brickHeight;
                if (ballX > brickX && ballX < brickX + brickWidth &&
                    ballY > brickY && ballY < brickY + brickHeight) {
                    bricks[r][c] = false; // Break the brick
                    ballSpeedY *= -1; // Reverse ball direction
                    score += 10; // Update score
                }
            }
        }
    }

    // Ball out of bounds
    if (ballY > height) {
        lives--;
        resetBall();
    }

    // Game Over or Level Complete
    if (lives == 0) {
        fill(255);
        textSize(32);
        text("Game Over!", width / 2, height / 2);
        noLoop();
    } else if (isLevelComplete()) {
        fill(255);
        textSize(32);
        text("Level Complete!", width / 2, height / 2);
        noLoop();
    }
}

void keyPressed() {
    if (keyCode == LEFT) paddleX -= 20;
    if (keyCode == RIGHT) paddleX += 20;

    // Prevent paddle from going off-screen
    paddleX = constrain(paddleX, 0, width - paddleWidth);
}

void resetBall() {
    ballX = width / 2;
    ballY = height / 2;
    ballSpeedX = 5;
    ballSpeedY = 5;
}

boolean isLevelComplete() {
    for (int r = 0; r < brickRows; r++) {
        for (int c = 0; c < brickCols; c++) {
            if (bricks[r][c]) return false;
        }
    }
    return true;
}
