import 'package:flutter/material.dart';

class ReportDialog extends StatefulWidget {
  final String reportedUserName;
  final VoidCallback onCancel;
  final ValueChanged<String> onReportConfirm;

  const ReportDialog({
    super.key,
    required this.reportedUserName,
    required this.onCancel,
    required this.onReportConfirm,
  });

  @override
  State<ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  final TextEditingController _otherReasonController = TextEditingController();
  String selectedReason = 'Spam';
  String? _errorText;

  final List<String> reasons = [
    'Spam',
    'Abuse',
    'Inappropriate',
    'Other',
  ];

  @override
  void dispose() {
    _otherReasonController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    String reason;
    if (selectedReason == 'Other') {
      reason = _otherReasonController.text.trim();
      if (reason.isEmpty) {
        setState(() {
          _errorText = 'Please enter a reason.';
        });
        return;
      }
    } else {
      reason = selectedReason;
    }

    widget.onReportConfirm(reason);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Report ${widget.reportedUserName}?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Please select a reason for reporting this user:'),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: selectedReason,
            items: reasons
                .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedReason = value;
                  _errorText = null;
                  if (selectedReason != 'Other') {
                    _otherReasonController.clear();
                  }
                });
              }
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            ),
          ),
          if (selectedReason == 'Other') ...[
            const SizedBox(height: 12),
            TextField(
              controller: _otherReasonController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Please specify...',
                border: const OutlineInputBorder(),
                errorText: _errorText,
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: widget.onCancel,
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _handleSubmit,
          child: const Text('Report'),
        ),
      ],
    );
  }
}
