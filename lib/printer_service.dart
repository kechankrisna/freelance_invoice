import 'dart:async';
import 'dart:typed_data';
import 'package:esc_pos_utils_plus/esc_pos_utils.dart';
import 'package:freelance_invoice/services.dart';
import 'package:image/image.dart' as img;

import 'package:pos_printer_manager/pos_printer_manager.dart';

class PrinterService {
  static CapabilityProfile? profile;
  static FutureOr<void> initialize() async {
    if (profile == null) {
      /// ensure printer profile is loaded
      await CapabilityProfile.ensureProfileLoaded();
      profile = (await CapabilityProfile.getAvailableProfiles()).first;
    }
  }

  static FutureOr printRawImages(List<Uint8List> receipts) async {
    final printer = NetWorkPrinter();
    final paperSize = PaperSize.mm80;
    final service = NetworkPrinterManager(printer, paperSize, profile!);

    try {
      await service.connect();

      for (var receipt in receipts) {
        var bytes = await generateReceiptBytes(receipt: receipt);
        await service.writeBytes(bytes, isDisconnect: false);
      }

      service.disconnect();
    } catch (error) {
      AppService.logger.e("PRINT RAW IMAGE", error: error);
    }
  }

  static Future<List<int>> generateReceiptBytes({
    required Uint8List receipt,
    PaperSize paperSize = PaperSize.mm80,
    CapabilityProfile? profile,
    bool drawer = false,
    bool beep = false,
  }) async {
    List<int> bytes = [];
    final _profile = profile ?? (await CapabilityProfile.load());

    Generator generator = Generator(paperSize, _profile);
    if (receipt.isNotEmpty) {
      final img.Image _resize =
          img.copyResize(img.decodeImage(receipt)!, width: paperSize.width);
      bytes += generator.image(_resize);
      bytes += generator.feed(2);
      bytes += generator.cut();
    }
    if (beep) {
      bytes += generator.beep();
    }
    if (drawer) {
      bytes += generator.drawer();
    }

    return bytes;
  }
}
