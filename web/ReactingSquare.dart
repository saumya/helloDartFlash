library ReactingSqure;

import 'dart:html' as html;
import 'dart:math';
import 'package:dartflash/dartflash.dart';



class ReactingSquare extends Sprite 
{
  
  bool _isMinReached=false;
  bool _isMaxReached=true;
  bool _isAnimating=false;
  
  int _recColor=0xFFFF0000;
  
  ReactingSquare(int colorValue){
    //this.logit(this);
    this._recColor=colorValue;
    this._init();
  }
  
  void _init()
  {
    BitmapData bitmapData = new BitmapData(50, 50);
    bitmapData.fillRect(new Rectangle(0, 0, 50, 50), this._recColor);
    //bitmapData.fillRect(new Rectangle(5, 5, 40, 40), 0xFFFFFF00);//inside color
    Bitmap bitmap = new Bitmap(bitmapData);
    bitmap.x=-25;
    bitmap.y=-25;
    this.addChild(bitmap);
    //adding event listeners
    this.addEventListener(MouseEvent.MOUSE_OVER, _onClick);
    //this.addEventListener(Event.ENTER_FRAME, onEachFrame);
  }
  
  void startAnimating()
  {
    this._isAnimating=true;
    this.addEventListener(Event.ENTER_FRAME, _onEachFrame);
  }
  void stopAnimating()
  {
    this._isAnimating=false;
    this.removeEventListeners(Event.ENTER_FRAME);
  }
  
  void _onClick(MouseEvent e){
    if(this._isAnimating==true)
    {
      this.stopAnimating();
    }else if(this._isAnimating==false){
      this.startAnimating();
    }
  }
  
  void _onEachFrame(Event e)
  {
    if(this.scaleX<=0)
    {
      this.scaleX=0;
      this.scaleY=0;
      this._isMinReached=true;
      this._isMaxReached=false;
    }else if(this.scaleX>=1)
    {
      this.scaleX=1;
      this.scaleY=1;
      this._isMinReached=false;
      this._isMaxReached=true;
    }
    //
    if(this._isMinReached)
    {
      this.scaleX +=0.01;
      this.scaleY +=0.01;
    }
    
    if(this._isMaxReached){
      this.scaleX -=0.01;
      this.scaleY -=0.01;
    }
    
    
  }
  
  
  
  void logit(Object message)
  {
    html.window.console.log(message);
  }
}

