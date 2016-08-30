Quaternion quaternion;

float[] hx;
float[] hy;
float[] hz;
float[] hw;
int ih;
int nh = 200;
float mh = 2.0;

color colorX;
color colorY;
color colorZ;
color colorW;
color colorB;

PGraphics fbCube;

PFont fontL;

Spring spring1;
Spring spring2;
Spring spring3;
Spring spring4;

void setup() {
  size( 960, 960, P3D );
  quaternion = new Quaternion();
  
  
  hx = new float[ nh ];
  hy = new float[ nh ];
  hz = new float[ nh ];
  hw = new float[ nh ];
  ih = nh;
  
  colorX = color( 220, 30, 90 );
  colorY = color( 110, 210, 30 );
  colorZ = color( 70, 130, 240 );
  colorW = color( 220 );
  colorB = color( 30, 40, 50 );
  
  fbCube = createGraphics( 960, 640, P3D );
  
  fontL = createFont( "HelveticaNeue-Bold", 64 );
  textAlign( RIGHT, BOTTOM );
  
  float springK = 200.0;
  spring1 = new Spring( springK );
  spring2 = new Spring( springK );
  spring3 = new Spring( springK );
  spring4 = new Spring( springK );
}

void drawGraph() {
  ih = ( ih + 1 ) % nh;
  hx[ ih ] = quaternion.v.x;
  hy[ ih ] = quaternion.v.y;
  hz[ ih ] = quaternion.v.z;
  hw[ ih ] = quaternion.w;
  
  noFill();
  strokeWeight( 3 );
  strokeJoin( ROUND );
  strokeCap( ROUND );
  
  stroke( colorW );
  beginShape();
  for ( int i = 0; i < nh; i ++ ) {
    int index = ( ih + i + 1 ) % nh;
    vertex( 180 + i * mh, 640 + 0 - hw[ index ] * 30 );
  }
  endShape();
  
  stroke( colorX );
  beginShape();
  for ( int i = 0; i < nh; i ++ ) {
    int index = ( ih + i + 1 ) % nh;
    vertex( 180 + i * mh, 720 + 0 - hx[ index ] * 30 );
  }
  endShape();
  
  stroke( colorY );
  beginShape();
  for ( int i = 0; i < nh; i ++ ) {
    int index = ( ih + i + 1 ) % nh;
    vertex( 180 + i * mh, 800 + 0 - hy[ index ] * 30 );
  }
  endShape();
  
  stroke( colorZ );
  beginShape();
  for ( int i = 0; i < nh; i ++ ) {
    int index = ( ih + i + 1 ) % nh;
    vertex( 180 + i * mh, 880 + 0 - hz[ index ] * 30 );
  }
  endShape();
  
  noStroke();
  
  fill( colorW );
  textFont( fontL );
  text( quaternion.w, 780, 680 );
  
  fill( colorX );
  textFont( fontL );
  text( quaternion.v.x, 780, 760 );
  
  fill( colorY );
  textFont( fontL );
  text( quaternion.v.y, 780, 840 );
  
  fill( colorZ );
  textFont( fontL );
  text( quaternion.v.z, 780, 920 );
}

void drawCube() {
  fbCube.beginDraw();
  
  fbCube.perspective( radians( 40 ), fbCube.width * 1.0 / fbCube.height, 0.01, 100.0 );
  fbCube.camera( 0.0, 0.0, 7.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0 );
  
  fbCube.background( colorB );
  
  fbCube.pushMatrix();
  fbCube.applyMatrix( quaternion.toPMatrix3D() );
  
  fbCube.stroke( colorB );
  fbCube.strokeWeight( 10 );
  fbCube.fill( colorW );
  fbCube.box( 1.5 );
  
  fbCube.noStroke();
  fbCube.fill( colorX );
  fbCube.box( 4.0, 0.05, 0.05 );
  fbCube.fill( colorY );
  fbCube.box( 0.05, 4.0, 0.05 );
  fbCube.fill( colorZ );
  fbCube.box( 0.05, 0.05, 4.0 );
  
  fbCube.popMatrix();
  
  fbCube.endDraw();
  
  image( fbCube, 0, 0 );
}

void draw() {
  background( colorB );
  
  drawCube();
  drawGraph();
  
  float time = ( frameCount / 200.0 ) % 1.0; 
  float deltaTime = 1.0 / 60.0;
  
  quaternion = new Quaternion();
  Vec v;
  
  spring2.target = ( time + 0.125 ) % 1.0 < 0.5 ? 1.0 : 0.0;
  spring2.update( deltaTime );
  v = new Vec( 0.0, 0.0, 1.0 ).normalize();
  quaternion = quaternion.multiply( rotateQuaternion(  spring2.pos * PI, v ) );
  
  spring3.target = ( time + 0.25 ) % 1.0 < 0.5 ? 1.0 : 0.0;
  spring3.update( deltaTime );
  v = new Vec( 1.0, -3.0, -4.0 ).normalize();
  quaternion = quaternion.multiply( rotateQuaternion( spring3.pos * 1.2, v ) );
  
  spring4.target = ( time + 0.375 ) % 1.0 < 0.5 ? 1.0 : 0.0;
  spring4.update( deltaTime );
  v = new Vec( 3.0, 1.0, 1.0 ).normalize();
  quaternion = quaternion.multiply( rotateQuaternion( spring4.pos * 1.9, v ) );
  
  spring1.target = time < 0.5 ? 1.0 : 0.0;
  spring1.update( deltaTime );
  v = new Vec( -1.0, -1.0, 1.0 ).normalize();
  quaternion = quaternion.multiply( rotateQuaternion( spring1.pos * 1.4, v ) );
  
  saveFrame( "out/#####.png" );
}