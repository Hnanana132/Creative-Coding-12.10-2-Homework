import controlP5.*;
import peasy.*;
int numSliders = 5;
float[] sectionHeights = {10, 20, 30, 40, 50};
float[] sectionRadii;
int vaseColor;

ControlP5 cp5;
PeasyCam cam; 
void setup() {
  size(600, 600, P3D);
  cp5 = new ControlP5(this);
  cam = new PeasyCam(this, 500);
  sectionRadii = new float[numSliders];
  vaseColor = color(255, 0, 0);  // 初始颜色为红色

  for (int i = 0; i < numSliders; i++) {
    float defaultRadius = 30; // 初始半径
    cp5.addSlider("sectionRadius" + i)
       .setPosition(20, 20 + i * 40)
       .setRange(10, 100)
       .setValue(defaultRadius)
       .setSize(200, 20);

    sectionRadii[i] = defaultRadius;
  }

  cp5.addColorWheel("vaseColor")
     .setPosition(300, 20)
     .setColorValue(vaseColor);
}

void draw() {
  background(255);
  lights();
  translate(width / 2, height / 2);
  rotateX(PI / 6);

  drawVase();
}

void drawVase() {
  fill(vaseColor);
  stroke(255);

  for (int i = 0; i < numSliders; i++) {
    float currentHeight = sectionHeights[i];
    float currentRadius = sectionRadii[i];

    // 绘制花瓶的横截面
    beginShape();
    for (float angle = 0; angle <= TWO_PI; angle += 0.1) {
      float x = currentRadius * cos(angle);
      float y = currentRadius * sin(angle);
      vertex(x, y, currentHeight);
    }
    endShape(CLOSE);

    // 绘制花瓶的侧面连接线
    if (i < numSliders - 1) {
      beginShape();
      for (float angle = 0; angle <= TWO_PI; angle += 0.1) {
        float x1 = sectionRadii[i] * cos(angle);
        float y1 = sectionRadii[i] * sin(angle);
        float x2 = sectionRadii[i + 1] * cos(angle);
        float y2 = sectionRadii[i + 1] * sin(angle);
        vertex(x1, y1, sectionHeights[i]);
        vertex(x2, y2, sectionHeights[i + 1]);
      }
      endShape();
    }
  }
}

void controlEvent(ControlEvent theEvent) {
  if (theEvent.isController()) {
    if (theEvent.getController().getName().startsWith("sectionRadius")) {
      for (int i = 0; i < numSliders; i++) {
        sectionRadii[i] = cp5.getController("sectionRadius" + i).getValue();
      }
    } else if (theEvent.getController().getName().equals("vaseColor")) {
      vaseColor = (int) theEvent.getController().getValue();
    }
    redraw();
  }
}

void keyPressed() {
  if (key == 'a' || key == 'A') {
    saveVaseAsObj("output.obj");
  }
}

void saveVaseAsObj(String filename) {
  PrintWriter objWriter = createWriter(filename);
  objWriter.println("# Wavefront OBJ file");

  int vertexCount = 1;
  for (int i = 0; i < numSliders; i++) {
    float currentHeight = sectionHeights[i];
    float currentRadius = sectionRadii[i];

    for (float angle = 0; angle <= TWO_PI; angle += 0.1) {
      float x = currentRadius * cos(angle);
      float y = currentRadius * sin(angle);
      objWriter.println("v " + x + " " + y + " " + currentHeight);
      vertexCount++;
    }
  }

  vertexCount = 1;
  for (int i = 0; i < numSliders - 1; i++) {
    for (int j = 0; j < 36; j++) {
      int v1 = vertexCount;
      int v2 = (vertexCount % 360) + 1;
      int v3 = ((vertexCount + 1) % 360) + 1;
      int v4 = ((vertexCount + 360 - 1) % 360) + 1;

      objWriter.println("f " + v1 + " " + v2 + " " + v3);
      objWriter.println("f " + v1 + " " + v3 + " " + v4);
      vertexCount++;
    }
  }

  objWriter.flush();
  objWriter.close();
  println("Vase saved as " + filename);
}
