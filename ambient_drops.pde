import supercollider.*;
import oscP5.*;
import netP5.*;

Synth[] synth;
float[] fqs;

ArrayList<Particle> particles;
Particle particle;
Particle[] toDelete;
int loc;

void setup(){
  size(1280,720);

  synth = new Synth[128];
  fqs = new float[]{311.13, 369.99, 415.3, 466.16, 554.37,622.25,739.99,830.61,932.33, 1108.73};


  for(int i=0; i<synth.length; i+=1)
  {
    synth[i] = new Synth("sine");
    synth[i].set("freq", fqs[floor(i*fqs.length/synth.length)]);
    synth[i].create();
  }

  particles = new ArrayList<Particle>();
} 

void draw(){
 //image(bg, 0, 0);
  fill(255, 255, 255, 2);
  rect(0,0,width, height);
  particles.add(new Particle());
  for(int i=0; i<particles.size(); i+=1){
    Particle p = particles.get(i);
    p.checkCollisions();
    p.update();
    p.checkEdges();
    p.checkExplode();
    p.display();

    //prune off-screen and invisible nodes to save memory
    if (p.prune){
      particles.remove(p);
    }
  }
}

class Particle {
  PVector location, velocity, acceleration;
  float topSpeed;
  float sizeX;
  boolean prune;
  boolean played;

  Particle(){
    float x = random(0, width);
    PVector l = new PVector(x,0);
    PVector v = new PVector(0,0);
    PVector a = new PVector(random(-0.005,0.005),0.006);
    float topSpeed = 3;

    this.location = l;
    this.velocity = v;
    this.acceleration = a;
    this.topSpeed = topSpeed;
    this.sizeX = random(3,8);
    this.prune = false;
    this.played = false;
  }

  void update(){
    velocity.add(acceleration);
    velocity.limit(topSpeed);
    location.add(velocity);
  }

  void display(){
    noStroke();
    pushMatrix();
    if (sizeX > 30){
      fill(173, 150, 99);
      if(!played){
        synth[int(floor(location.x/fqs.length))].set("t_trig", 1);
        played = true;
      }
    } else {
      fill(46, 140, 194);
    }
    ellipse(location.x, location.y, sizeX, sizeX);
    popMatrix();
  }

 void checkEdges() {
    if (location.x > width) {
      location.x = 0;
    } else if (location.x < 0) {
      location.x = width;
    }

    if (location.y > height || location.y < 0) {
      this.prune = true;
    }
  }

 void checkCollisions(){
    for(Particle p: particles){
      float d = dist(location.x, location.y, p.location.x, p.location.y);
      if( (d < sizeX/2 + p.sizeX/2) && (d != 0) ){
        if(sizeX >= p.sizeX){
          sizeX += p.sizeX/2;
          //played = false;
          p.sizeX = 0;
          p.prune = true;
          float ratio = p.sizeX/sizeX;
          acceleration.mult(1-ratio);
          p.acceleration.mult(ratio);
          acceleration.add(p.acceleration);
        }
      }
    }
 }

 void checkExplode(){
  if(sizeX > 50){
    sizeX = 40;
  }
 }
}

void stop(){
  for (int i = 0; i < synth.length; i++)
    synth[i].free();
  super.exit();
}
