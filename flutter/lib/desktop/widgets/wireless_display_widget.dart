import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hbb/common.dart';
import 'package:flutter_hbb/common/widgets/comssu_about_dialog.dart';
import 'package:flutter_hbb/consts.dart';
import 'package:flutter_hbb/models/platform_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class WirelessDisplayWidget extends StatefulWidget {
  final VoidCallback? onSwitchToConnectMode;

  const WirelessDisplayWidget({Key? key, this.onSwitchToConnectMode})
      : super(key: key);

  @override
  State<WirelessDisplayWidget> createState() => _WirelessDisplayWidgetState();
}

class _WirelessDisplayWidgetState extends State<WirelessDisplayWidget> {
  String _localIp = '...';
  String _displayName = 'CS Society Display';
  Timer? _ipTimer;

  @override
  void initState() {
    super.initState();
    _resolveDisplayName();
    _updateLocalIp();
    _ipTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      _updateLocalIp();
    });
  }

  @override
  void dispose() {
    _ipTimer?.cancel();
    super.dispose();
  }

  void _resolveDisplayName() {
    try {
      final host = Platform.localHostname.trim();
      if (host.isNotEmpty && host != 'localhost') {
        _displayName = 'CS Society Display ($host)';
      }
    } catch (_) {}
  }

  Future<void> _updateLocalIp() async {
    String ip = '';
    try {
      final interfaces = await NetworkInterface.list(
        type: InternetAddressType.IPv4,
        includeLoopback: false,
      );
      int bestScore = -1;
      for (final iface in interfaces) {
        final name = iface.name.toLowerCase();
        final isVirtual = name.contains('vethernet') ||
            name.contains('wsl') ||
            name.contains('docker') ||
            name.contains('vbox') ||
            name.contains('virtual') ||
            name.contains('vmware') ||
            name.contains('loopback') ||
            name.contains('npcap') ||
            name.contains('tailscale') ||
            name.contains('zerotier');
        for (final addr in iface.addresses) {
          final candidate = addr.address;
          if (candidate.startsWith('127.') ||
              candidate.startsWith('169.254.')) {
            continue;
          }
          int score = isVirtual ? 0 : 100;
          if (candidate.startsWith('192.168.')) {
            score += 30;
          } else if (candidate.startsWith('10.')) {
            score += 20;
          } else if (RegExp(r'^172\.(1[6-9]|2\d|3[0-1])\.')
              .hasMatch(candidate)) {
            score += 10;
          }
          if (score > bestScore) {
            bestScore = score;
            ip = candidate;
          }
        }
      }
    } catch (_) {}

    final displayIp = ip.isNotEmpty ? ip : 'No LAN IP';
    if (mounted && _localIp != displayIp) {
      setState(() {
        _localIp = displayIp;
      });
    }
  }

  String _formatPin(String raw) {
    final clean = raw.replaceAll(RegExp(r'\s+'), '').trim();
    if (clean.length == 4) {
      return '${clean[0]} ${clean[1]} ${clean[2]} ${clean[3]}';
    }
    if (clean.length > 4) {
      return clean.substring(0, 4).split('').join(' ');
    }
    if (clean.isNotEmpty) {
      return clean.split('').join(' ');
    }
    return '9 3 1 3';
  }

  @override
  Widget build(BuildContext context) {
    final model = gFFI.serverModel;
    final configuredPort =
        bind.mainGetOptionSync(key: kOptionDirectAccessPort).trim();
    final portLabel = configuredPort.isEmpty ? '21118' : configuredPort;

    return Container(
      color: const Color(0xFFF1F6FB),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Top Header
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/comssu_logo.png',
                    width: 64,
                    height: 64,
                    fit: BoxFit.contain,
                    errorBuilder: (ctx, err, stack) => loadIcon(56),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'ComSSU | Wireless Display System',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0E2F60),
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Computer Science Students' Society (ComSSU) | University of Makeni",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0284C7),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Display Name & IP Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: const Color(0xFFBAE6FD), width: 1.2),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0284C7).withOpacity(0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF10B981),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Display Name: ',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF475569),
                          ),
                        ),
                        Text(
                          _displayName,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0284C7),
                          ),
                        ),
                        if (_localIp != '...' && _localIp != 'No LAN IP') ...[
                          const SizedBox(width: 10),
                          const Text(
                            '•',
                            style: TextStyle(color: Color(0xFFCBD5E1)),
                          ),
                          const SizedBox(width: 10),
                          InkWell(
                            onTap: () {
                              Clipboard.setData(
                                  ClipboardData(text: '$_localIp:$portLabel'));
                              showToast(translate('Copied'));
                            },
                            child: Row(
                              children: [
                                const Icon(Icons.wifi,
                                    size: 14, color: Color(0xFF0284C7)),
                                const SizedBox(width: 4),
                                Text(
                                  '$_localIp:$portLabel',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF0369A1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // 4 Cards Section
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 940;
                final cards = [
                  // Card 1: Apple Devices
                  _buildInstructionCard(
                    iconBgColor: Colors.black,
                    iconWidget: SvgPicture.asset(
                      'assets/mac.svg',
                      width: 18,
                      height: 18,
                      colorFilter: const ColorFilter.mode(
                          Colors.white, BlendMode.srcIn),
                    ),
                    platformTitle: 'Apple Devices',
                    platformSub: 'iOS / iPadOS / macOS',
                    steps: [
                      '1. Open Control Center',
                      '2. Tap Screen Mirroring',
                      '3. Select CS Society Display',
                    ],
                  ),
                  // Card 2: Windows PC
                  _buildInstructionCard(
                    iconBgColor: const Color(0xFF0284C7),
                    iconWidget: SvgPicture.asset(
                      'assets/win.svg',
                      width: 18,
                      height: 18,
                      colorFilter: const ColorFilter.mode(
                          Colors.white, BlendMode.srcIn),
                    ),
                    platformTitle: 'Windows PC',
                    platformSub: 'Windows 10 / 11',
                    steps: [
                      '1. In Edge / Chrome: Cast → Cast screen',
                      '2. Or press Win + K (Miracast)',
                      '3. Select CS Society Display',
                    ],
                  ),
                  // Card 3: Android / Chrome
                  _buildInstructionCard(
                    iconBgColor: const Color(0xFF1E293B),
                    iconWidget: SvgPicture.asset(
                      'assets/android.svg',
                      width: 18,
                      height: 18,
                      colorFilter: const ColorFilter.mode(
                          Colors.white, BlendMode.srcIn),
                    ),
                    platformTitle: 'Android / Chrome',
                    platformSub: 'Google Cast / Smart View',
                    steps: [
                      '1. Open ComSSU Cast or Chrome',
                      '2. Tap Cast / Mirror Screen',
                      '3. Select CS Society Display',
                    ],
                  ),
                  // Card 4: Security Session PIN
                  _buildPinCard(model),
                ];

                if (isWide) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: cards
                        .map((c) => Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 6),
                                child: c,
                              ),
                            ))
                        .toList(),
                  );
                } else {
                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: cards
                        .map((c) => SizedBox(
                              width: 280,
                              child: c,
                            ))
                        .toList(),
                  );
                }
              },
            ),
            const SizedBox(height: 36),

            // Bottom Bar: About System Button & Academic Year Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // About System Pill Button
                InkWell(
                  borderRadius: BorderRadius.circular(22),
                  onTap: () => showComSSUAboutDialog(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 9),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                          color: const Color(0xFF0284C7), width: 1.3),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0284C7).withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.info_outline,
                          size: 18,
                          color: Color(0xFF0284C7),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'About System',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0284C7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Switch to Connect Mode Button
                if (widget.onSwitchToConnectMode != null)
                  InkWell(
                    borderRadius: BorderRadius.circular(22),
                    onTap: widget.onSwitchToConnectMode,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 9),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0284C7),
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF0284C7).withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.laptop_chromebook,
                            size: 18,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Connect to Remote Device / LAN Peers',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // UniMak Academic Year Tag
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text(
                      '2026/27 Academic Year',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'University of Makeni (UniMak)',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionCard({
    required Color iconBgColor,
    required Widget iconWidget,
    required String platformTitle,
    required String platformSub,
    required List<String> steps,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: iconWidget,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      platformTitle,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      platformSub,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF94A3B8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 12),
          // Steps
          ...steps.map((s) {
            final hasHighlight = s.contains('CS Society Display');
            if (!hasHighlight) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  s,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.35,
                    color: Color(0xFF334155),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }
            final parts = s.split('CS Society Display');
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.35,
                    color: Color(0xFF334155),
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    TextSpan(text: parts[0]),
                    const TextSpan(
                      text: 'CS Society Display',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0284C7),
                      ),
                    ),
                    if (parts.length > 1) TextSpan(text: parts[1]),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPinCard(dynamic model) {
    String pinText = '9 3 1 3';
    try {
      final pwd = model.serverPasswd.text.toString();
      if (pwd.isNotEmpty) {
        pinText = _formatPin(pwd);
      } else {
        final id = model.serverId.text.toString();
        if (id.isNotEmpty) {
          final digitsOnly = id.replaceAll(RegExp(r'\D'), '');
          if (digitsOnly.length >= 4) {
            pinText = _formatPin(digitsOnly.substring(digitsOnly.length - 4));
          }
        }
      }
    } catch (_) {}

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F9FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFBAE6FD), width: 1.4),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0284C7).withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.shield_outlined, size: 16, color: Color(0xFF0284C7)),
              SizedBox(width: 6),
              Text(
                'SECURITY SESSION PIN',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: Color(0xFF0284C7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Large PIN Display
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE0F2FE), width: 1.2),
            ),
            alignment: Alignment.center,
            child: Text(
              pinText,
              style: const TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w900,
                color: Color(0xFF0369A1),
                letterSpacing: 4.0,
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Enter this 4-digit code if prompted by device',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 10),
          // Operator Approval Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFDCFCE7),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.check, size: 14, color: Color(0xFF15803D)),
                SizedBox(width: 4),
                Text(
                  'On-screen operator approval required',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF15803D),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
