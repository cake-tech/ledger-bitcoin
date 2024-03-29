import 'dart:typed_data';

import 'package:ledger_bitcoin/src/ledger/ledger_input_operation.dart';
import 'package:ledger_flutter/src/utils/buffer.dart';

class ContinueInterruptedOperation extends LedgerInputOperation<Uint8List> {
  final Uint8List inputData;

  ContinueInterruptedOperation(this.inputData) : super(0xF8, 0x01);

  @override
  Future<Uint8List> read(ByteDataReader reader) async =>
      reader.read(reader.remainingLength);

  @override
  int get p1 => 0x00;

  @override
  int get p2 => 0x00;

  @override
  Future<Uint8List> writeInputData() async => inputData;
}
