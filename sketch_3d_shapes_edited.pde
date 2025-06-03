int numQubits = 8;
int bitsPerQubit = 8;
float spacing = 120;       // écart entre qubits
float bitSpacing = 40;     // écart entre bits dans un qubit
float shapeSize = 30;

int[][] bits = new int[numQubits][bitsPerQubit];
int[][] shapes = new int[numQubits][bitsPerQubit];

void setup() {
  size(1000, 600, P3D);
  noStroke();
  // Générer aléatoirement bits et formes
  for (int i = 0; i < numQubits; i++) {
    for (int j = 0; j < bitsPerQubit; j++) {
      bits[i][j] = (int)random(2);           // 0 ou 1 aléatoire
      shapes[i][j] = (int)random(8);         // 8 formes différentes
    }
  }
}

void draw() {
  background(255);
  lights();
  translate(100, height/2, -400);
  rotateX(PI/6);
  rotateY(frameCount * 0.01);

  for (int i = 0; i < numQubits; i++) {
    pushMatrix();
    translate(i * spacing, 0, 0);  // décalage horizontal entre qubits

    for (int j = 0; j < bitsPerQubit; j++) {
      pushMatrix();
      // Empiler les formes des bits à la même position x,y,z
      float yOffset = -j * bitSpacing;
      translate(0, yOffset, 0);

      if (bits[i][j] == 1) {
        // Couleur dégradée verticale selon bit index
        float c = map(j, 0, bitsPerQubit - 1, 0, 255);
        fill(c, 100, 255 - c, 180);  // couleur avec alpha translucide
        drawShape(shapes[i][j], shapeSize);
      }
      popMatrix();
    }
    popMatrix();
  }
}

// Dessine une forme selon un type (0 à 7)
void drawShape(int type, float size) {
  switch(type) {
    case 0:
      sphere(size);
      break;
    case 1:
      box(size);
      break;
    case 2:
      drawCylinder(size/2, size*1.5, 24);
      break;
    case 3:
      drawCone(size/2, size*1.5, 24);
      break;
    case 4:
      drawTorus(size/2, size/4, 24, 16);
      break;
    case 5:
      drawCapsule(size/2, size*1.5, 24);
      break;
    case 6:
      drawPyramid(size);
      break;
    case 7:
      drawEllipsoid(size, size*1.5, size);
      break;
    default:
      sphere(size);
  }
}

void drawCylinder(float r, float h, int detail) {
  beginShape(QUAD_STRIP);
  for (int i = 0; i <= detail; i++) {
    float angle = TWO_PI * i / detail;
    float x = cos(angle) * r;
    float z = sin(angle) * r;
    vertex(x, -h/2, z);
    vertex(x, h/2, z);
  }
  endShape();
}

void drawCone(float r, float h, int detail) {
  // Base
  beginShape(TRIANGLE_FAN);
  vertex(0, h/2, 0);
  for (int i = 0; i <= detail; i++) {
    float angle = TWO_PI * i / detail;
    float x = cos(angle) * r;
    float z = sin(angle) * r;
    vertex(x, -h/2, z);
  }
  endShape();

  // Cone side
  beginShape(TRIANGLE_FAN);
  vertex(0, h/2, 0); // apex
  for (int i = 0; i <= detail; i++) {
    float angle = TWO_PI * i / detail;
    float x = cos(angle) * r;
    float z = sin(angle) * r;
    vertex(x, -h/2, z);
  }
  endShape();
}

void drawTorus(float r1, float r2, int detail1, int detail2) {
  for (int i = 0; i < detail1; i++) {
    float theta1 = TWO_PI * i / detail1;
    float theta2 = TWO_PI * (i + 1) / detail1;

    beginShape(QUAD_STRIP);
    for (int j = 0; j <= detail2; j++) {
      float phi = TWO_PI * j / detail2;
      float cosPhi = cos(phi);
      float sinPhi = sin(phi);

      float x1 = (r1 + r2 * cosPhi) * cos(theta1);
      float y1 = r2 * sinPhi;
      float z1 = (r1 + r2 * cosPhi) * sin(theta1);

      float x2 = (r1 + r2 * cosPhi) * cos(theta2);
      float y2 = r2 * sinPhi;
      float z2 = (r1 + r2 * cosPhi) * sin(theta2);

      vertex(x1, y1, z1);
      vertex(x2, y2, z2);
    }
    endShape();
  }
}

void drawCapsule(float r, float h, int detail) {
  drawCylinder(r, h, detail);
  pushMatrix();
  translate(0, -h/2, 0);
  drawHalfSphere(r, detail);
  popMatrix();

  pushMatrix();
  translate(0, h/2, 0);
  rotateX(PI);
  drawHalfSphere(r, detail);
  popMatrix();
}

void drawPyramid(float size) {
  float h = size;
  beginShape(TRIANGLES);
  vertex(-size/2, h/2, -size/2);
  vertex(size/2, h/2, -size/2);
  vertex(0, -h/2, 0);

  vertex(size/2, h/2, -size/2);
  vertex(size/2, h/2, size/2);
  vertex(0, -h/2, 0);

  vertex(size/2, h/2, size/2);
  vertex(-size/2, h/2, size/2);
  vertex(0, -h/2, 0);

  vertex(-size/2, h/2, size/2);
  vertex(-size/2, h/2, -size/2);
  vertex(0, -h/2, 0);
  endShape();

  beginShape(QUADS);
  vertex(-size/2, h/2, -size/2);
  vertex(size/2, h/2, -size/2);
  vertex(size/2, h/2, size/2);
  vertex(-size/2, h/2, size/2);
  endShape();
}

void drawEllipsoid(float rx, float ry, float rz) {
  int detail = 24;
  for (int i = 0; i <= detail; i++) {
    float lat0 = PI * (-0.5 + (float)(i - 1) / detail);
    float lat1 = PI * (-0.5 + (float) i / detail);
    float z0 = sin(lat0);
    float zr0 = cos(lat0);
    float z1 = sin(lat1);
    float zr1 = cos(lat1);

    beginShape(QUAD_STRIP);
    for (int j = 0; j <= detail; j++) {
      float lng = TWO_PI * (float)(j - 1) / detail;
      float x = cos(lng);
      float y = sin(lng);
      vertex(rx * x * zr0, ry * y * zr0, rz * z0);
      vertex(rx * x * zr1, ry * y * zr1, rz * z1);
    }
    endShape();
  }
}

void drawHalfSphere(float r, int detail) {
  for (int i = 0; i < detail/2; i++) {
    float lat0 = PI * (-0.5 + (float)(i) / detail);
    float lat1 = PI * (-0.5 + (float)(i+1) / detail);
    float z0 = sin(lat0);
    float zr0 = cos(lat0);
    float z1 = sin(lat1);
    float zr1 = cos(lat1);

    beginShape(QUAD_STRIP);
    for (int j = 0; j <= detail; j++) {
      float lng = 2 * PI * (float)(j - 1) / detail;
      float x = cos(lng);
      float y = sin(lng);
      vertex(r * x * zr0, r * y * zr0, r * z0);
      vertex(r * x * zr1, r * y * zr1, r * z1);
    }
    endShape();
  }
}
