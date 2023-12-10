# Creative-Coding-12.10-2-Homework
步骤一：生成3D瓶装物体，该瓶状物体的高度确定，其横截面均为圆形。
步骤二：该瓶状物体在某些指定高度处的横截面大小可通过滑块调节，并且调节后面仍是连续的。
步骤三：该瓶的瓶身颜色可以调节，可以呈现丰富多样的颜色。

代码实现：

import controlP5.*;

int numSliders = 5;

float[] sectionHeights = {10, 20, 30, 40, 50};

float[] sectionRadii;

int vaseColor;

ControlP5 cp5;

void setup() {

  size(600, 600, P3D);
  
  cp5 = new ControlP5(this);

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
