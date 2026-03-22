import 'dart:ui' show TextDirection;

import 'package:intl/intl.dart' show Bidi;

/// Detects the dominant [TextDirection] of [text] using the Unicode
/// Bidirectional Algorithm as implemented by the Dart `intl` package.
///
/// The `intl` package is already a transitive dependency of FluffyChat, so
/// this adds **no new package dependency**.
///
/// The detection is threshold-based (ratio of strong RTL characters to total
/// strong characters), which correctly handles mixed Persian/Arabic + Latin
/// content — e.g. "سلام Hello" is treated as RTL because the majority of
/// strongly-directional characters are RTL.
///
/// Returns [TextDirection.ltr] for empty or neutral-only strings.
TextDirection detectTextDirection(String text) =>
    Bidi.detectRtlDirectionality(text)
        ? TextDirection.rtl
        : TextDirection.ltr;
