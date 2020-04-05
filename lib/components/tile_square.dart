import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_2048/components/game_box.dart';
import 'package:flutter_2048/extensions/int.dart';
import 'package:flutter_2048/mixins/component_ref_holder.dart';
import 'package:flutter_2048/util/palette.dart';
import 'package:flutter_2048/util/tuple.dart';

class TileSquare extends PositionComponent with IComponentRefHolder<GameBox> {
  final Tuple<int, int> _gridPosition;
  TextPainter _tPainter;
  TileSquare _joinedTo;
  TextSpan _tSpan;
  Offset _offset;
  Paint _paint;
  int _value;

  @override
  final GameBox componentRef;

  TileSquare(
    this.componentRef,
    this._gridPosition,
    this._value,
    Size tileSize, {
    Offset offset = const Offset(0, 0),
    TileSquare companion,
    bool silent = false,
  }) {
    this.height = tileSize.height;
    this.width = tileSize.width;
    this._offset = offset;

    this._layout();
    this._textLayout();
    this._updatePaint();

    if (!silent)
      print("Spawned tile ${this._gridPosition}: ${2.safeLShift(this._value)}");

    this.debugMode = true;
  }

  factory TileSquare.copy(TileSquare source) {
    if (source == null) return null;

    return TileSquare(
      source.componentRef,
      Tuple<int, int>.copy(source._gridPosition),
      source._value,
      Size(source.width, source.height),
      offset: source._offset,
      companion: TileSquare.copy(source._joinedTo),
      silent: true,
    );
  }

  Tuple<int, int> get gridPosition => this._gridPosition;

  int get value => this._value;

  bool get isMoving =>
      this._offset != Offset.zero || (this._joinedTo?.isMoving ?? false);

  void _layout() {
    this.x =
        this._gridPosition.b * (this.componentRef.gapSize.width + this.width) +
            this.componentRef.gapSize.width;
    this.y = this._gridPosition.a *
            (this.componentRef.gapSize.height + this.height) +
        this.componentRef.gapSize.height;
  }

  void _textLayout() {
    this._tSpan = TextSpan(
      text: 2.safeLShift(this._value).toString(),
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: BasicPalette.black.color,
      ),
    );

    this._tPainter = TextPainter(
      text: this._tSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
      maxLines: 1,
    );
    this._tPainter.layout(minWidth: this.width, maxWidth: this.width);
  }

  @override
  Rect toRect() => super.toRect().translate(this._offset.dx, this._offset.dy);

  Offset toOffset() => this.toPosition().toOffset().translate(
        this._offset.dx,
        this._offset.dy,
      );

  Offset textOffset() => this.toOffset().translate(
        0,
        (this.height - (this._tPainter.height ?? 0)) / 2.0,
      );

  @override
  void render(Canvas c) {
    c.drawRect(
      this.toRect(),
      this._paint,
    );

    this._tPainter.paint(c, this.textOffset());
  }

  @override
  void update(double t) {
    if (!this.isMoving) return;

    if (this._offset != Offset.zero) {
      double dx = this._offset.dx;
      double dy = this._offset.dy;

      dx += (dx.isNegative ? t : -t) * 16.5 * this.width;
      dy += (dy.isNegative ? t : -t) * 16.5 * this.height;

      if (this._offset.dx.sign != dx.sign) dx = 0;

      if (this._offset.dy.sign != dy.sign) dy = 0;

      this._offset = Offset(dx, dy);
    }

    if (this._joinedTo == null) return;

    if (this._joinedTo.isMoving) {
      this._joinedTo.update(t);
      return;
    }
  }

  @override
  void resize(Size size) {
    this._layout();
    this._textLayout();

    super.resize(size);
  }

  void updateValue() {
    if (this._joinedTo == null) return;

    this._joinedTo = null;
    this._textLayout();
    this._updatePaint();
  }

  void updateGridPosition(int i, int j) {
    Offset oldOffset = this.toPosition().toOffset();

    this._gridPosition.set(i, j);
    this._layout();

    Offset newOffset = this.toPosition().toOffset();

    this._offset = oldOffset - newOffset;

    this._joinedTo?.updateGridPosition(i, j);
  }

  void merge(TileSquare otherTile) {
    if (otherTile == null) return;

    this._joinedTo = otherTile;
    this._value++;
  }

  void _updatePaint() {
    this._paint = Palette
        .colorProgression[(this._value + 1) % Palette.colorProgression.length]
        .paint;
  }
}
