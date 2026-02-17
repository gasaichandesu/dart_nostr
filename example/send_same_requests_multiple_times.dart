import 'dart:async';

import 'package:dart_nostr/dart_nostr.dart';

Future<void> main() async {
  await Nostr.instance.services.relays
      .init(relaysUrl: ['wss://testing.gathr.gives']);
}

NostrEventsStream _queryEvents({
  required List<NostrFilter> filters,
  required List<String> relays,
  void Function(String relay, NostrRequestEoseCommand eose)? onEose,
  String? subscriptionId,
}) {
  final request = NostrRequest(
    subscriptionId: subscriptionId,
    filters: filters,
  );

  final sub = Nostr.instance.services.relays.startEventsSubscription(
    request: request,
    onEose: onEose,
    relays: relays.toSet().toList(),
  );

  return sub;
}

/// Fetches a list of events from the relays asyncronously.
/// resolves As soon as a relay sends an EOSE command.
@override
Future<List<NostrEvent>> _asyncEvents({
  required List<String> relays,
  required Duration timeout,
  required List<NostrFilter> filters,
}) async {
  final completer = Completer<List<NostrEvent>>();
  final events = <NostrEvent>[];

  final eoseMap = <String, bool>{};
  final subscription = _queryEvents(
    filters: filters,
    relays: relays,
    onEose: (relay, eose) async {
      eoseMap[relay] = true;

      if (eoseMap.length == relays.length) {
        Nostr.instance.services.relays.closeEventsSubscription(
          eose.subscriptionId,
          relay,
        );
        completer.complete(events);
      }
    },
  );

  subscription.stream.listen(events.add);

  return completer.future;
}
