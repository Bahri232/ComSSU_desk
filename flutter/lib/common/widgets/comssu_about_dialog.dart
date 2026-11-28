import 'package:flutter/material.dart';
import 'package:flutter_hbb/common.dart' hide Dialog;
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 580, maxHeight: 720),
        child: Container(
          padding: const EdgeInsets.fromLTRB(28, 24, 28, 20),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF18191E) : const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark ? const Color(0xFF2E3038) : const Color(0xFFE2E8F0),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ComSSUAboutContent(
            isDialog: true,
            onClose: () => Navigator.of(context).pop(),
          ),
        ),
      ),
    );
  }
}

class ComSSUAboutContent extends StatelessWidget {
  final bool isDialog;
  final VoidCallback? onClose;

  const ComSSUAboutContent({
    Key? key,
    this.isDialog = false,
    this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final secondaryTextColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Header & Society Identity
          Image.asset(
            'assets/comssu_logo.png',
            width: 72,
            height: 72,
            fit: BoxFit.contain,
            errorBuilder: (ctx, err, stack) => loadIcon(60),
          ),
          const SizedBox(height: 12),
          Text(
            'ComSSU_desk',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDark ? const Color(0xFF38BDF8) : const Color(0xFF0F2B5C),
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE0F2FE),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color:
                    isDark ? const Color(0xFF334155) : const Color(0xFFBAE6FD),
              ),
            ),
            child: Text(
              'v1.0.0 — 2026/27 Academic Year',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color:
                    isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Computer Science Students' Society (ComSSU) — University of Makeni (UniMak)",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : const Color(0xFF334155),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              ),
            ),
            child: Text(
              '"Local network remote desktop and wireless display system for classrooms and labs."',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.5,
                fontStyle: FontStyle.italic,
                height: 1.35,
                color:
                    isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 18),

          // 2. Development Team Card
          _buildCard(
            context: context,
            icon: Icons.code,
            title: 'Development Team',
            children: [
              _buildPersonTile(
                context: context,
                role: 'Lead Developer',
                name: 'Abdul Malik Barrie (BAHRI)',
                email: 'abdulmalikbarrie@gmail.com',
              ),
              const Divider(height: 14),
              _buildPersonTile(
                context: context,
                role: 'Development Contributor & Technical Advisor',
                name: 'Mir Hashaam Ahmed',
                subtext: 'Feature suggestions & testing',
              ),
            ],
          ),

          // 3. Society Leadership Card (2026/27 Executive)
          _buildCard(
            context: context,
            icon: Icons.groups_outlined,
            title: 'Society Leadership (2026/27 Executive)',
            children: [
              _buildPersonTile(
                context: context,
                role: 'President, ComSSU',
                name: 'Mohamed Sillah',
              ),
              const Divider(height: 14),
              _buildPersonTile(
                context: context,
                role: 'Vice President, ComSSU',
                name: 'Ibrahim Kamara',
              ),
            ],
          ),

          // 4. Society Contact Card
          _buildCard(
            context: context,
            icon: Icons.contact_mail_outlined,
            title: 'Society Contact',
            children: [
              Row(
                children: [
                  const Icon(Icons.email_outlined,
                      size: 15, color: Color(0xFF0284C7)),
                  const SizedBox(width: 8),
                  Text(
                    'Email: ',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: secondaryTextColor,
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () =>
                          launchUrlString('mailto:comssu.unimak@gmail.com'),
                      child: const Text(
                        'comssu.unimak@gmail.com',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0284C7),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.phone_outlined,
                      size: 15, color: Color(0xFF0284C7)),
                  const SizedBox(width: 8),
                  Text(
                    'Phone: ',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: secondaryTextColor,
                    ),
                  ),
                  Expanded(
                    child: Wrap(
                      spacing: 8,
                      children: [
                        InkWell(
                          onTap: () => launchUrlString('tel:+23274607053'),
                          child: const Text(
                            '+232 74607053',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0284C7),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        Text('/',
                            style: TextStyle(
                                fontSize: 12, color: secondaryTextColor)),
                        InkWell(
                          onTap: () => launchUrlString('tel:+23278233006'),
                          child: const Text(
                            '+232 78233006',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0284C7),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          // 5. Open-Source Attribution
          const SizedBox(height: 6),
          Text(
            'Built upon the open-source RustDesk framework (AGPL-3.0).',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11.5,
              color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
            ),
          ),

          // Close Button (if shown in dialog)
          if (isDialog && onClose != null) ...[
            const SizedBox(height: 18),
            SizedBox(
              width: 150,
              height: 40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1D68BD),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: onClose,
                child: const Text(
                  'Close',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: const Color(0xFF0284C7)),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  Widget _buildPersonTile({
    required BuildContext context,
    required String role,
    required String name,
    String? subtext,
    String? email,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    role,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  if (subtext != null) ...[
                    const SizedBox(height: 1),
                    Text(
                      '($subtext)',
                      style: TextStyle(
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                        color: isDark
                            ? const Color(0xFF64748B)
                            : const Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (email != null)
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => launchUrlString('mailto:$email'),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.email_outlined,
                          size: 13, color: Color(0xFF0284C7)),
                      const SizedBox(width: 4),
                      Text(
                        email,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0284C7),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
