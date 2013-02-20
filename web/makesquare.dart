import 'dart:html' as html;
import 'dart:math';
import 'package:dartflash/dartflash.dart';

import 'ReactingSquare.dart';

Sprite s=new Sprite();
bool shouldAnimate = false;

void main() {
  /*
  html.query("#sample_text_id")
    ..text = "Click me!"
    ..onClick.listen(reverseText);
  */
  initialiseApplication();
  
}
/*
void reverseText(MouseEvent event) {
  var text = html.query("#sample_text_id").text;
  var buffer = new StringBuffer();
  for (int i = text.length - 1; i >= 0; i--) {
    buffer.add(text[i]);
  }
  html.query("#sample_text_id").text = buffer.toString();
}
*/
void initialiseApplication()
{
  var stage= new Stage('stage',html.query('#flash_container_id'));
  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);
  
  ReactingSquare rs = new ReactingSquare();
  rs.x=25;
  rs.y=25;
  stage.addChild(rs);
  
  
  
  stage.addEventListener(Event.ENTER_FRAME, onEachFrame);
  // Add the Bitmap to the Stage
  //stage.addChild(bitmap);
  stage.addChild(s);
}

void onEachFrame(Event e){
  if(shouldAnimate==true)
  {
    s.x += 1;
  }else{
    //s.x=0;
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