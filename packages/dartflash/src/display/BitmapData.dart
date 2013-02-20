part of dartflash;

class BitmapData implements BitmapDrawable
{
  int _width;
  int _height;
  bool _transparent;

  Element _element;
  CanvasRenderingContext2D _context;

  int _frameMode;
  double _frameOffsetX;
  double _frameOffsetY;
  double _frameX;
  double _frameY;
  double _frameWidth;
  double _frameHeight;

  //-------------------------------------------------------------------------------------------------
  //-------------------------------------------------------------------------------------------------

  BitmapData(int width, int height, [bool transparent = true, int fillColor = 0xFFFFFFFF])
  {
    _width = width;
    _height = height;
    _transparent = transparent;

    var canvas = new CanvasElement(width: _width, height: _height);

    _context = canvas.context2d;
    _context.fillStyle = _transparent ? _color2rgba(fillColor) : _color2rgb(fillColor);
    _context.fillRect(0, 0, width, height);

    _element = canvas;
    _frameMode = 0;
  }

  //-------------------------------------------------------------------------------------------------

  BitmapData.fromImageElement(ImageElement imageElement)
  {
    _width = imageElement.naturalWidth;
    _height = imageElement.naturalHeight;
    _transparent = true;

    _element = imageElement;
    _frameMode = 0;
  }

  //-------------------------------------------------------------------------------------------------

  BitmapData.fromTextureAtlasFrame(TextureAtlasFrame textureAtlasFrame)
  {
    _width = textureAtlasFrame.originalWidth;
    _height = textureAtlasFrame.originalHeight;
    _transparent = true;

    _element = textureAtlasFrame.textureAtlas.imageElement;

    _frameMode = textureAtlasFrame.rotated ? 2 : 1;
    _frameOffsetX = textureAtlasFrame.offsetX.toDouble();
    _frameOffsetY = textureAtlasFrame.offsetY.toDouble();
    _frameX = textureAtlasFrame.frameX.toDouble();
    _frameY = textureAtlasFrame.frameY.toDouble();
    _frameWidth = textureAtlasFrame.frameWidth.toDouble();
    _frameHeight = textureAtlasFrame.frameHeight.toDouble();
  }

  //-------------------------------------------------------------------------------------------------
  //-------------------------------------------------------------------------------------------------

  static Future<BitmapData> load(String url)
  {
    Completer<BitmapData> completer = new Completer<BitmapData>();

    var image = new ImageElement();
    image.onLoad.listen((event) => completer.complete(new BitmapData.fromImageElement(image)));
    image.onError.listen((event) => completer.completeError(new StateError("Error loading image.")));
    image.src = url;

    return completer.future;
  }

  @deprecated
  static Future<BitmapData> loadImage(String url) 
  {
    return BitmapData.load(url);
  }
    
  //-------------------------------------------------------------------------------------------------
  //-------------------------------------------------------------------------------------------------

  int get width => _width;
  int get height => _height;

  //-------------------------------------------------------------------------------------------------

  BitmapData clone()
  {
    BitmapData bitmapData = new BitmapData(_width, _height, true, 0);
    bitmapData.draw(this);

    return bitmapData;
  }

  //-------------------------------------------------------------------------------------------------

  void applyFilter(BitmapData sourceBitmapData, Rectangle sourceRect, Point destPoint, BitmapFilter filter)
  {
    filter.apply(sourceBitmapData, sourceRect, this, destPoint);
  }

  //-------------------------------------------------------------------------------------------------

  void colorTransform(Rectangle rect, ColorTransform transform)
  {
    var context = _getContext();
    var image = context.getImageData(rect.x, rect.y, rect.width, rect.height);
    var data = image.data;
    var length = data.length;

    int r = transform.redOffset;
    int g = transform.greenOffset;
    int b = transform.blueOffset;
    int a = transform.alphaOffset;

    num rm = transform.redMultiplier;
    num gm = transform.greenMultiplier;
    num bm = transform.blueMultiplier;
    num am = transform.alphaMultiplier;

    if (_isLittleEndianSystem) {
      for (int i = 0; i <= length - 4; i += 4) {
        data[i + 0] = data[i + 0] * (1 - rm) + (r * rm);
        data[i + 1] = data[i + 1] * (1 - gm) + (g * gm);
        data[i + 2] = data[i + 2] * (1 - bm) + (b * bm);
        data[i + 3] = data[i + 3] * (1 - am) + (a * am);
      }
    } else {
      for (int i = 0; i <= length - 4; i += 4) {
        data[i + 0] = data[i + 0] * (1 - am) + (a * am);
        data[i + 1] = data[i + 1] * (1 - bm) + (b * bm);
        data[i + 2] = data[i + 2] * (1 - gm) + (g * gm);
        data[i + 3] = data[i + 3] * (1 - rm) + (r * rm);
      }
    }

    context.putImageData(image, rect.x, rect.y);
  }

  //-------------------------------------------------------------------------------------------------

  void copyPixels(BitmapData sourceBitmapData, Rectangle sourceRect, Point destPoint, [BitmapData alphaBitmapData = null, Point alphaPoint = null, bool mergeAlpha = false])
  {
    var imageData = sourceBitmapData._getContext().getImageData(sourceRect.x, sourceRect.y, sourceRect.width, sourceRect.height);

    _getContext().putImageData(imageData, destPoint.x, destPoint.y);
  }

  //-------------------------------------------------------------------------------------------------

  void draw(BitmapDrawable source, [Matrix matrix = null])
  {
    var context = _getContext();
    var renderState = new RenderState.fromCanvasRenderingContext2D(context, matrix);
    
    source.render(renderState);
    context.setTransform(1.0, 0.0, 0.0, 1.0, 0.0, 0.0);
  }

  //-------------------------------------------------------------------------------------------------

  void fillRect(Rectangle rect, int color)
  {
    var context = _getContext();

    context.setTransform(1.0, 0.0, 0.0, 1.0, 0.0, 0.0);
    context.fillStyle = _color2rgba(color);
    context.fillRect(rect.x, rect.y, rect.width, rect.height);
  }

  //-------------------------------------------------------------------------------------------------

  int getPixel(int x, int y)
  {
    var context = _getContext();
    var imageData = context.getImageData(x, y, 1, 1);
    var data = imageData.data;

    if (_isLittleEndianSystem) {
      return (data[0] << 16) + (data[1] << 8) + (data[2] << 0);
    } else {
      return (data[3] << 16) + (data[2] << 8) + (data[1] << 0);
    }

  }

  //-------------------------------------------------------------------------------------------------

  int getPixel32(int x, int y)
  {
    var context = _getContext();
    var imageData = context.getImageData(x, y, 1, 1);
    var data = imageData.data;

    if (_isLittleEndianSystem) {
      return (data[0] << 16) + (data[1] << 8) + (data[2] << 0) + (data[3] << 24);
    } else {
      return (data[3] << 16) + (data[2] << 8) + (data[1] << 0) + (data[0] << 24);
    }
  }

  //-------------------------------------------------------------------------------------------------

  void setPixel(int x, int y, int color)
  {
    var context = _getContext();
    var imageData = context.getImageData(x, y, 1, 1);
    var data = imageData.data;

    if (_isLittleEndianSystem) {
      data[0] = (color >> 16) & 0xFF;
      data[1] = (color >>  8) & 0xFF;
      data[2] = (color >>  0) & 0xFF;
    } else {
      data[1] = (color >>  0) & 0xFF;
      data[2] = (color >>  8) & 0xFF;
      data[3] = (color >> 16) & 0xFF;
    }

    context.putImageData(imageData, x, y);
  }

  //-------------------------------------------------------------------------------------------------

  void setPixel32(int x, int y, int color)
  {
    var context = _getContext();
    var imageData = context.getImageData(x, y, 1, 1);
    var data = imageData.data;

    if (_isLittleEndianSystem) {
      data[0] = (color >> 16) & 0xFF;
      data[1] = (color >>  8) & 0xFF;
      data[2] = (color >>  0) & 0xFF;
      data[3] = (color >> 24) & 0xFF;
    } else {
      data[0] = (color >> 24) & 0xFF;
      data[1] = (color >>  0) & 0xFF;
      data[2] = (color >>  8) & 0xFF;
      data[3] = (color >> 16) & 0xFF;
    }

    context.putImageData(imageData, x, y);
  }

  //-------------------------------------------------------------------------------------------------
  //-------------------------------------------------------------------------------------------------

  void render(RenderState renderState)
  {
    switch(_frameMode)
    {
      case 0:
        renderState.context.drawImage(_element, 0.0, 0.0);
        break;

      case 1:
        renderState.context.drawImage(_element, _frameX, _frameY, _frameWidth, _frameHeight, _frameOffsetX, _frameOffsetY, _frameWidth, _frameHeight);
        break;

      case 2:
        renderState.context.transform(0.0, -1.0, 1.0, 0.0, _frameOffsetX, _frameOffsetY + _frameHeight);
        renderState.context.drawImage(_element, _frameX, _frameY, _frameHeight, _frameWidth, 0.0, 0.0, _frameHeight, _frameWidth);
        break;
    }
  }

  //-------------------------------------------------------------------------------------------------

  void renderClipped(RenderState renderState, Rectangle clipRectangle)
  {
    if (clipRectangle.width <= 0.0 || clipRectangle.height <= 0.0)
      return;

    switch(_frameMode)
    {
      case 0:
        renderState.context.drawImage(_element,
          clipRectangle.x, clipRectangle.y, clipRectangle.width, clipRectangle.height,
          clipRectangle.x, clipRectangle.y, clipRectangle.width, clipRectangle.height);
        break;

      case 1:

        double fLeft = _frameX;
        double fTop =  _frameY;
        double fRight = fLeft + _frameWidth;
        double fBottom = fTop + _frameHeight;

        double cLeft = _frameX - _frameOffsetX + clipRectangle.x;
        double cTop =  _frameY - _frameOffsetY + clipRectangle.y;
        double cRight = cLeft + clipRectangle.width;
        double cBottom = cTop + clipRectangle.height;

        double iLeft = (fLeft > cLeft) ? fLeft : cLeft;
        double iTop =  (fTop > cTop) ? fTop : cTop;
        double iRight = (fRight < cRight) ? fRight : cRight;
        double iBottom = (fBottom < cBottom) ? fBottom : cBottom;
        double iOffsetX = _frameOffsetX - fLeft + iLeft;
        double iOffsetY = _frameOffsetY - fTop + iTop;
        double iWidth = iRight - iLeft;
        double iHeight = iBottom - iTop;

        if (iWidth > 0.0 && iHeight > 0.0) {
          renderState.context.drawImage(_element, iLeft, iTop, iWidth, iHeight, iOffsetX, iOffsetY, iWidth, iHeight);
        }

        break;

      case 2:

        double fLeft = _frameX;
        double fTop =  _frameY;
        double fRight = fLeft + _frameHeight;
        double fBottom = fTop + _frameWidth;

        double cLeft = _frameX + _frameOffsetY - clipRectangle.y + _frameHeight - clipRectangle.height;
        double cTop =  _frameY - _frameOffsetX + clipRectangle.x;
        double cRight = cLeft + clipRectangle.height;
        double cBottom = cTop + clipRectangle.width;

        double iLeft = (fLeft > cLeft) ? fLeft : cLeft;
        double iTop =  (fTop > cTop) ? fTop : cTop;
        double iRight = (fRight < cRight) ? fRight : cRight;
        double iBottom = (fBottom < cBottom) ? fBottom : cBottom;
        double iOffsetX = _frameOffsetX - fTop + iTop;
        double iOffsetY = _frameOffsetY + fRight - iRight;
        double iWidth = iBottom - iTop;
        double iHeight = iRight - iLeft;

        if (iWidth > 0.0 && iHeight > 0.0) {
          renderState.context.transform(0.0, -1.0, 1.0, 0.0, iOffsetX, iOffsetY + iHeight);
          renderState.context.drawImage(_element, iLeft, iTop, iHeight, iWidth, 0.0, 0.0, iHeight, iWidth);
        }

        break;
    }
  }

  //-------------------------------------------------------------------------------------------------
  //-------------------------------------------------------------------------------------------------

  CanvasRenderingContext2D _getContext()
  {
    if (_context == null)
    {
      var canvas = new CanvasElement(width: _width, height: _height);

      _context = canvas.context2d;

      switch(_frameMode)
      {
        case 0:
          _context.drawImage(_element, 0, 0);
          break;

        case 1:
          _context.drawImage(_element, _frameX, _frameY, _frameWidth, _frameHeight, _frameOffsetX, _frameOffsetY, _frameWidth, _frameHeight);
          break;

        case 2:
          _context.setTransform(0.0, -1.0, 1.0, 0.0, _frameOffsetX, _frameOffsetY + _frameHeight);
          _context.drawImage(_element, _frameX, _frameY, _frameHeight, _frameWidth, 0.0, 0.0, _frameHeight, _frameWidth);
          _context.setTransform(1.0, 0.0, 0.0, 1.0, 0.0, 0.0);
          break;
      }

      _element = canvas;
      _frameMode = 0;
    }

    return _context;
  }


}
