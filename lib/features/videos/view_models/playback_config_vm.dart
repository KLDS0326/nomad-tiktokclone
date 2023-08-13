import 'package:flutter/material.dart';
import 'package:tiktok_clone/features/videos/repos/playback_config_repo.dart';
import 'package:tiktok_clone/features/videos/views/widgets/playback_config_model.dart';

class PlaybackConfigViewModel extends ChangeNotifier {
  final PlaybackConfigRepository _repository;

  late final PlaybackConfigModel _model = PlaybackConfigModel(
    muted: _repository.isMuted(),
    autoplay: _repository.isAutoplay(),
  );

  PlaybackConfigViewModel(this._repository);

  bool get muted => _model.muted;

  bool get autoplay => _model.autoplay;

  void setMuted(bool value) {
    _repository.setMuted(value);
    _model.muted = value;
    notifyListeners();
  }

  void setAutoplay(bool value) {
    _repository.setAutoplay(value);
    _model.autoplay = value;
    notifyListeners();
  }
}
