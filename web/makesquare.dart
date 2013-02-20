import 'dart:html' as html;
import 'dart:math';
import 'package:dartflash/dartflash.dart';

void main() {
  /*
  html.query("#sample_text_id")
    ..text = "Click me!"
    ..onClick.listen(reverseText);
  */
  var stage= new Stage('stage',html.query('#flash_container_id'));
  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);
  
  // Create a nice looking BitmapData

  BitmapData bitmapData = new BitmapData(100, 100);
  bitmapData.fillRect(new Rectangle(0, 0, 100, 100), 0xFFFF0000);
  bitmapData.fillRect(new Rectangle(10, 10, 80, 80), 0xFF00FF00);

  // Create a Bitmap with the nice looking BitmapData

  Bitmap bitmap = new Bitmap(bitmapData);
  bitmap.x = 100;
  bitmap.y = 100;
  bitmap.rotation = PI / 8.0;

  // Add the Bitmap to the Stage

  stage.addChild(bitmap);
  
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