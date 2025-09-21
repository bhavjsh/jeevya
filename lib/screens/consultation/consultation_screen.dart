import 'package:flutter/material.dart';
import '../../models/doctor_model.dart';
import '../../utils/app_theme.dart';

class ConsultationScreen extends StatefulWidget {
  const ConsultationScreen({super.key});

  @override
  State<ConsultationScreen> createState() => _ConsultationScreenState();
}

class _ConsultationScreenState extends State<ConsultationScreen> {
  bool _isVideoEnabled = true;
  bool _isAudioEnabled = true;
  bool _isInCall = false;

  @override
  Widget build(BuildContext context) {
    final Doctor? doctor = ModalRoute.of(context)?.settings.arguments as Doctor?;
    
    if (doctor == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Consultation'),
          backgroundColor: AppTheme.primaryColor,
        ),
        body: const Center(
          child: Text('No doctor selected'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Dr. ${doctor.name}'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Video Area
          Expanded(
            child: Stack(
              children: [
                // Doctor's video (simulated)
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.all(16),
                  child: _isInCall
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
                              child: Text(
                                doctor.name.split(' ').map((e) => e[0]).take(2).join(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Dr. ${doctor.name}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.successColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Connected',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.videocam_off,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _isInCall ? 'Connecting...' : 'Ready to Connect',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                ),

                // Patient's video (small overlay)
                Positioned(
                  top: 32,
                  right: 32,
                  child: Container(
                    width: 120,
                    height: 160,
                    decoration: BoxDecoration(
                      color: Colors.grey[700],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: _isVideoEnabled
                        ? const Center(
                            child: Text(
                              'You',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          )
                        : const Center(
                            child: Icon(
                              Icons.videocam_off,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),

          // Controls
          Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Main controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Mute button
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isAudioEnabled = !_isAudioEnabled;
                        });
                      },
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: _isAudioEnabled ? Colors.grey[800] : AppTheme.errorColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _isAudioEnabled ? Icons.mic : Icons.mic_off,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),

                    // Call/End call button
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isInCall = !_isInCall;
                        });
                        
                        if (!_isInCall) {
                          // End call - go back
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: _isInCall ? AppTheme.errorColor : AppTheme.successColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _isInCall ? Icons.call_end : Icons.videocam,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),

                    // Camera button
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isVideoEnabled = !_isVideoEnabled;
                        });
                      },
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: _isVideoEnabled ? Colors.grey[800] : AppTheme.errorColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _isVideoEnabled ? Icons.videocam : Icons.videocam_off,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Additional controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Chat
                    _buildControlButton(
                      Icons.chat_bubble_outline,
                      'Chat',
                      () {
                        _showChatDialog();
                      },
                    ),

                    // Screen share
                    _buildControlButton(
                      Icons.screen_share,
                      'Share',
                      () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Screen sharing started'),
                            backgroundColor: AppTheme.successColor,
                          ),
                        );
                      },
                    ),

                    // Settings
                    _buildControlButton(
                      Icons.settings,
                      'Settings',
                      () {
                        _showSettingsDialog();
                      },
                    ),
                  ],
                ),

                if (!_isInCall) ...[
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Consultation with Dr. ${doctor.name}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${doctor.specialization} • ₹${doctor.consultationFee.toStringAsFixed(0)}',
                          style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: 14,
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
    );
  }

  Widget _buildControlButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  void _showChatDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          height: 400,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Chat',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              const Expanded(
                child: Center(
                  child: Text(
                    'Chat feature coming soon...',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () {},
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text(
            'Call Settings',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.video_settings, color: Colors.white),
                title: const Text('Video Quality', style: TextStyle(color: Colors.white)),
                subtitle: const Text('HD', style: TextStyle(color: Colors.grey)),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.volume_up, color: Colors.white),
                title: const Text('Audio Settings', style: TextStyle(color: Colors.white)),
                subtitle: const Text('Default', style: TextStyle(color: Colors.grey)),
                onTap: () {},
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}