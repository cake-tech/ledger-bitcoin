import 'dart:typed_data';

import 'package:dart_varuint_bitcoin/dart_varuint_bitcoin.dart' as varuint;

extension ToVarint on int {
  /// Convert an integer into a bitcoin-style varint
  Uint8List toVarint() => varuint.encode(this).buffer;

  /// Convert an integer into a little endian 32 bit Uint8List
  Uint8List toInt32LE() {
    final bd = ByteData(4)..setInt32(0, this, Endian.little);
    return bd.buffer.asUint8List();
  }

  /// Convert an integer into a little endian unsigned 8 bit Uint8List
  Uint8List toUint8() {
    final bd = ByteData(1)..setUint8(0, this);
    return bd.buffer.asUint8List();
  }

  /// Convert an integer into a little endian unsigned 32 bit Uint8List
  Uint8List toUint32LE() {
    final bd = ByteData(4)..setUint32(0, this, Endian.little);
    return bd.buffer.asUint8List();
  }

  /// Convert an integer into a little endian unsigned 64 bit Uint8List
  Uint8List toUint64LE() {
    final bd = ByteData(8)..setUint64(0, this, Endian.little);
    return bd.buffer.asUint8List();
  }
}

/// Convert a bitcoin-style varint buffer into a integer
int intFromVarint(Uint8List value) => varuint.decode(value).output;
