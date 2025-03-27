// ignore_for_file: depend_on_referenced_packages

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// A class that represents the header above the first unread message.
@immutable
class UnreadHeaderData extends Equatable {
  const UnreadHeaderData({
    this.marginTop,
  });

  final double? marginTop;

  @override
  List<Object?> get props => [];
}
