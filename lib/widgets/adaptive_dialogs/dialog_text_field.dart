import 'package:fluffychat/utils/text_direction_detector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final String? initialText;
  final String? counterText;
  final String? prefixText;
  final String? suffixText;
  final String? errorText;
  final bool obscureText;
  final bool isDestructive = false;
  final int? minLines;
  final int? maxLines;
  final TextInputType? keyboardType;
  final int? maxLength;
  final bool autocorrect = true;

  const DialogTextField({
    super.key,
    this.hintText,
    this.labelText,
    this.initialText,
    this.prefixText,
    this.suffixText,
    this.minLines,
    this.maxLines,
    this.keyboardType,
    this.maxLength,
    this.controller,
    this.counterText,
    this.errorText,
    this.obscureText = false,
  });

  @override
  State<DialogTextField> createState() => _DialogTextFieldState();
}

class _DialogTextFieldState extends State<DialogTextField> {
  // Internal controller used when the caller does not provide one.
  TextEditingController? _internalController;
  late TextDirection _textDirection;

  TextEditingController get _controller =>
      widget.controller ?? (_internalController ??= TextEditingController(
        text: widget.initialText,
      ));

  @override
  void initState() {
    super.initState();
    _textDirection = detectTextDirection(_controller.text);
    _controller.addListener(_onTextChanged);
  }

  @override
  void didUpdateWidget(covariant DialogTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_onTextChanged);
      _controller.addListener(_onTextChanged);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _internalController?.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    // Obscured fields (passwords, PINs) always stay LTR.
    if (widget.obscureText) return;
    final direction = detectTextDirection(_controller.text);
    if (direction != _textDirection) {
      setState(() => _textDirection = direction);
    }
  }

  @override
  Widget build(BuildContext context) {
    final prefixText = widget.prefixText;
    final suffixText = widget.suffixText;
    final errorText = widget.errorText;
    // Passwords and obscured fields always use LTR layout.
    final textDirection =
        widget.obscureText ? TextDirection.ltr : _textDirection;
    final theme = Theme.of(context);
    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return TextField(
          controller: _controller,
          obscureText: widget.obscureText,
          minLines: widget.minLines,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          keyboardType: widget.keyboardType,
          autocorrect: widget.autocorrect,
          textDirection: textDirection,
          decoration: InputDecoration(
            errorText: errorText,
            hintText: widget.hintText,
            labelText: widget.labelText,
            prefixText: prefixText,
            suffixText: suffixText,
            counterText: widget.counterText,
          ),
        );
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        final placeholder = widget.labelText ?? widget.hintText;
        return Column(
          children: [
            SizedBox(
              height: placeholder == null ? null : ((widget.maxLines ?? 1) + 1) * 20,
              child: CupertinoTextField(
                controller: _controller,
                obscureText: widget.obscureText,
                minLines: widget.minLines,
                maxLines: widget.maxLines,
                maxLength: widget.maxLength,
                keyboardType: widget.keyboardType,
                autocorrect: widget.autocorrect,
                textDirection: textDirection,
                prefix: prefixText != null ? Text(prefixText) : null,
                suffix: suffixText != null ? Text(suffixText) : null,
                placeholder: placeholder,
              ),
            ),
            if (errorText != null)
              Text(
                errorText,
                style: TextStyle(fontSize: 11, color: theme.colorScheme.error),
                textAlign: TextAlign.left,
              ),
          ],
        );
    }
  }
}
