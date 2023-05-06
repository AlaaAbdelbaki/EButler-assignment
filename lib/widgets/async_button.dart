import 'package:flutter/material.dart';

class AsyncButton extends StatefulWidget {
  const AsyncButton({
    super.key,
    required this.text,
    this.onPressed,
  });
  final String text;
  final Function()? onPressed;

  @override
  State<AsyncButton> createState() => _AsyncButtonState();
}

class _AsyncButtonState extends State<AsyncButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _isLoading || widget.onPressed == null
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await widget.onPressed!();
              setState(() {
                _isLoading = false;
              });
            },
      child: Center(
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(widget.text),
      ),
    );
  }
}
