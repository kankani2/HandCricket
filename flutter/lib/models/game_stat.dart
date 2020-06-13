class GameStat {
  int _runs;
  int _balls;
  int _wickets;
  int _target;

  GameStat(this._runs, this._balls, this._wickets, this._target);

  String score() {
    return "$_runs/$_wickets";
  }

  String overs() {
    return "${_balls ~/ 6}.${_balls % 6} overs";
  }

  String toWin() {
    if (_target == -1) {
      return "To win: -";
    }

    return "To win: ${_target - _runs}";
  }
  
  String target() {
    if (_target == -1) {
      return "Target: -";
    }

    return "Target: $_target";
  }
}
