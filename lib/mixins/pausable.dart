mixin IPausable {
  bool _paused = false;

  bool get isPaused => _paused;

  void pause() {
    if (this._paused) throw Exception("Already paused");

    print("Paused gesture recognizer");

    this._paused = true;
  }

  void unpause() {
    if (!this._paused) throw Exception("Not paused");

    print("Resumed gesture recognizer");

    this._paused = false;
  }
}