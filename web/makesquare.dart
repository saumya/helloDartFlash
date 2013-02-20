import 'dart:html' as html;
import 'dart:math';
import 'package:dartflash/dartflash.dart';

import 'ReactingSquare.dart';

Sprite s=new Sprite();
bool shouldAnimate = false;

void main() {
  initialiseApplication();
}
void initialiseApplication()
{
  var stage= new Stage('stage',html.query('#flash_container_id'));
  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);
  //
  
  for(int i =0; i<5; i++)
  {
    for(int j=0; j<5; j++)
    {
      ReactingSquare rs = new ReactingSquare();
      rs.x=25+ (j*50);
      rs.y=25+ (i*50);
      stage.addChild(rs);
    }
  }
}

void onUserClick(MouseEvent e)
{
  /*
  Sprite s = e.target;
  s.x+=2;
  logThis(s);
  */
  if(shouldAnimate==true)
  {
    shouldAnimate=false;
  }else{
    shouldAnimate=true;
  }
}

void logThis(Object message)
{
  html.window.console.debug(message);
}