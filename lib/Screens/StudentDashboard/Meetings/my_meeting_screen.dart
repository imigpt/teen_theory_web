import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:teen_theory/Providers/StudentProviders/detail_project_provider.dart';
import 'package:teen_theory/Resources/colors.dart';

class MyMeetingScreen extends StatefulWidget {
  const MyMeetingScreen({super.key});

  @override
  State<MyMeetingScreen> createState() => _MyMeetingScreenState();
}

class _MyMeetingScreenState extends State<MyMeetingScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<DetailProjectProvider>().filteredMeetingLinkApiTap(context);      
    });
  }

  @override
  Widget build(BuildContext context) {
    // Sample meeting list; in real app this will come from API/provider
    final meetings = <Map<String, dynamic>>[
      {
        'projectName': 'AI Research Project',
        'title': 'Weekly Sync',
        'dateTime': DateTime.now().add(const Duration(hours: 1)),
        'mentorName': 'Dr. Nora',
        'status': 'Scheduled',
      },
      {
        'projectName': 'Creative Writing',
        'title': 'Feedback Session ✍️',
        'dateTime': DateTime.now().subtract(const Duration(days: 1)),
        'mentorName': 'Prof. Liam',
        'status': 'Completed',
      },
      {
        'projectName': 'Math Modeling',
        'title': 'Quick Q&A 💬',
        'dateTime': DateTime.now(),
        'mentorName': 'Ms. Ana',
        'status': 'Live',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Meetings'),
        backgroundColor: AppColors.blue,
        foregroundColor: AppColors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF7F9FC), Color(0xFFEFF7FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: meetings.length,
          itemBuilder: (context, index) {
            final item = meetings[index];
            final date = item['dateTime'] as DateTime;
            final formattedDate = DateFormat('dd MMM • hh:mm a').format(date);
            final status = (item['status'] as String).toLowerCase();
            final isLive = status == 'live';

            Color statusColor;
            if (status == 'completed') {
              statusColor = Colors.green.shade600;
            } else if (status == 'live') {
              statusColor = Colors.orange.shade700;
            } else {
              statusColor = Colors.blueGrey.shade400;
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.blue.shade50.withOpacity(0.6)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Row(
                  children: [
                    // Emoji circle
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.blue.withOpacity(0.8), Colors.purpleAccent.withOpacity(0.7)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(child: Text('📅', style: TextStyle(fontSize: 26))),
                    ),
                    const SizedBox(width: 12),

                    // Main Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  '${item['projectName']} — ${item['title']}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                                ),
                              ),
                              const SizedBox(width: 6),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            formattedDate,
                            style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${item['mentorName']}',
                            style: TextStyle(fontSize: 13, color: Colors.grey.shade800),
                          ),
                        ],
                      ),
                    ),

                    // Status + Join
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: statusColor.withOpacity(0.18)),
                          ),
                          child: Text(
                            item['status'],
                            style: TextStyle(fontSize: 12, color: statusColor, fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: isLive ? () {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Joining meeting...')));
                          } : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isLive ? AppColors.blue : Colors.grey.shade300,
                            foregroundColor: isLive ? AppColors.white : Colors.grey.shade700,
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            elevation: 0,
                          ),
                          child: const Text('Join'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}