/// Bidi isolation for user-generated text (§10.3).
///
/// A file name is user data with its own direction. Dropped raw into a UI in
/// the other direction, the bidi algorithm reorders it: an Arabic name ending
/// in `.pdf` displays with the extension moved to the wrong side, and
/// `"{name}" saved` puts the quote marks in the wrong places. Wrapping the
/// name in FIRST STRONG ISOLATE … POP DIRECTIONAL ISOLATE tells the algorithm
/// to resolve the name's direction on its own and keep it in one piece.
library;

/// U+2068 FIRST STRONG ISOLATE, built from its code point so the source file
/// contains no invisible direction-changing characters.
final String _fsi = String.fromCharCode(0x2068);

/// U+2069 POP DIRECTIONAL ISOLATE.
final String _pdi = String.fromCharCode(0x2069);

/// Isolates [text] so it keeps its own direction inside surrounding text.
///
/// Use for every file name, folder name, tag name and search query shown in
/// the UI — anything the user typed rather than something we translated.
String bidiIsolate(String text) => text.isEmpty ? text : '$_fsi$text$_pdi';

extension BidiIsolateString on String {
  /// Shorthand for [bidiIsolate].
  String get isolated => bidiIsolate(this);
}
