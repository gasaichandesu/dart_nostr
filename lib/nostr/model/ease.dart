// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../core/constants.dart';

class NostrRequestEoseCommand extends Equatable {
  final String subscriptionId;

  NostrRequestEoseCommand({
    required this.subscriptionId,
  });

  @override
  List<Object?> get props => [
        subscriptionId,
      ];

  static bool canBeDeserialized(String dataFromRelay) {
    final decoded = jsonDecode(dataFromRelay) as List;

    return decoded.first == NostrConstants.eose;
  }

  static NostrRequestEoseCommand fromRelayMessage(String dataFromRelay) {
    assert(canBeDeserialized(dataFromRelay));

    final decoded = jsonDecode(dataFromRelay) as List;

    return NostrRequestEoseCommand(
      subscriptionId: decoded[1] as String,
    );
  }
}
