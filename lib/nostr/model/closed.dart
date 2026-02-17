import 'dart:convert';

import 'package:dart_nostr/nostr/core/constants.dart';
import 'package:equatable/equatable.dart';

class NostrClosedCommand extends Equatable {
  const NostrClosedCommand({
    required this.subscriptionId,
    required this.message,
  });

  factory NostrClosedCommand.fromRelayMessage(String dataFromRelay) {
    assert(
      canBeDeserialized(dataFromRelay),
      '[dataFromRelay] should be json decodable',
    );

    final decoded = jsonDecode(dataFromRelay) as List;

    return NostrClosedCommand(
      subscriptionId: decoded[1] as String,
      message: decoded[2] as String,
    );
  }
  final String subscriptionId;
  final String message;

  @override
  List<Object?> get props => [
        subscriptionId,
        message,
      ];

  static bool canBeDeserialized(String dataFromRelay) {
    final decoded = jsonDecode(dataFromRelay) as List;

    return decoded.first == NostrConstants.closed;
  }
}
