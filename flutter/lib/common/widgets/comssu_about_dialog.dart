import 'package:flutter/material.dart';
import 'package:flutter_hbb/common.dart';
import 'package:url_launcher/url_launcher_string.dart';

void showComSSUAboutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) => const ComSSUAboutDialog(),
  );
}

class ComSSUAboutDialog extends StatelessWidget {
  const ComSSUAboutDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        width: 540,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/comssu_logo.png',
              width: 76,
              height: 76,
              fit: BoxFit.contain,
              errorBuilder: (c, e, s) => loadIcon(64),
            ),
            const SizedBox(height: 16),
            const Text(
              'ComSSU — Wireless Display System',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F2B5C),
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBF5FF),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFBFDBFE)),
                  ),
                  child: const Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2563EB),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBF5FF),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFBFDBFE)),
                  ),
                  child: const Text(
                    '2026/27 Academic Year',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2563EB),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Text(
              "COMPUTER SCIENCE STUDENTS' SOCIETY (ComSSU)",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
                color: Color(0xFF0F2B5C),
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              'University of Makeni (UniMak)',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Lead Developer: ',
                  style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                ),
                const Text(
                  'Abdul Malik Barrie (BAHRI)',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const Text(' — ', style: TextStyle(color: Color(0xFF94A3B8))),
                InkWell(
                  onTap: () => launchUrlString('mailto:abdulmalikbarrie@gmail.com'),
                  child: const Text(
                    'abdulmalikbarrie@gmail.com',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF2563EB),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
              ),
              child: const Text(
                'Engineered for cross-platform wireless screen projection (AirPlay, Miracast, Google Cast) for large-format interactive flat panel displays.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.45,
                  color: Color(0xFF334155),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Built with love by BAHRI • Built on the open-source RustDesk framework (AGPL-3.0)',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF94A3B8),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 170,
              height: 42,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1D68BD),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Close',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
