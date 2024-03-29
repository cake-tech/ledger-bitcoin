import 'dart:typed_data';

import 'package:ledger_bitcoin/src/client_command_interpreter.dart';
import 'package:ledger_bitcoin/src/operations/framework/continue_interrupted_operation.dart';
import 'package:ledger_bitcoin/src/utils/uint8list_extension.dart';
import 'package:ledger_flutter/ledger_flutter.dart';

extension RunLedgerFlow on Ledger {
  Future<Uint8List> runFlow(LedgerDevice device, LedgerOperation<Uint8List> operation,
      ClientCommandInterpreter cci) async {
    var response = await sendOperation<Uint8List>(device, operation);

    while (response.sublist(response.length - 2).toHexString() == "e000") {
      final hwRequest =
          response.sublist(0, response.length - 2); // -2 because we need to remove the status bytes
      final commandResponse = cci.execute(hwRequest);

      response = await _continueOperation(device, data: commandResponse);
    }

    if (response.toHexString() == "6a80") throw LedgerException(message: "SW_INCORRECT_DATA");

    print("Final response: ${response.toHexString()}");

    return response.sublist(
        0, response.length - 2); // -2 because we need to remove the status bytes
  }

  Future<Uint8List> _continueOperation(LedgerDevice device, {required Uint8List data}) =>
      sendOperation<Uint8List>(device, ContinueInterruptedOperation(data));
}
