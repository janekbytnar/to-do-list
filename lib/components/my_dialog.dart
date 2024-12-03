import 'package:flutter/material.dart';
import 'package:soft_for/components/my_text_field.dart';

class MyDialog extends StatefulWidget {
  final Function(
    String name,
  ) onAdd;
  final String title;
  final Icon? icon;
  const MyDialog({
    super.key,
    required this.onAdd,
    required this.title,
    this.icon,
  });

  @override
  State<MyDialog> createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  final nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Widget _title() {
    return Column(
      children: [
        Text(
          widget.title,
          style: const TextStyle(
            fontSize: 24,
          ),
        ),
        const SizedBox(height: 6),
        MyTextField(
          controller: nameController,
          prefixIcon: widget.icon != null ? const Icon(Icons.task) : null,
          hintText: '',
          obscureText: false,
          keyboardType: TextInputType.text,
          validator: (val) {
            if (val!.isEmpty) {
              return '${widget.title} field can\'t be empty';
            } else if (val.length > 50) {
              return 'Maximum 50 characters allowed';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _button() {
    return TextButton(
      onPressed: _submit,
      child: const Text(
        'Add',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onAdd(nameController.text.trim());
      final snackBar = SnackBar(
        content: Text('${widget.title} added'),
        showCloseIcon: true,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.of(context).pop();
    }
  }

  Widget _cancelButton() {
    return TextButton(
      onPressed: () => Navigator.of(context).pop(),
      child: const Text(
        'Cancel',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.red,
          fontSize: 16,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Text(
                'Add ${widget.title.toLowerCase()}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: 12),
              _title(),
              const SizedBox(height: 12),
              Row(
                children: [
                  _cancelButton(),
                  const Spacer(),
                  _button(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
