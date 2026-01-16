import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teen_theory/Providers/CounsellorProvider/counsellor_provider.dart';
import 'package:teen_theory/Providers/MentorProvider/mentor_provider.dart';
import 'package:teen_theory/Resources/fonts.dart';
import 'package:teen_theory/Utils/helper.dart';
import 'package:url_launcher/url_launcher.dart';

class MentorMeetingScreen extends StatefulWidget {
  MentorMeetingScreen({super.key});

  @override
  State<MentorMeetingScreen> createState() => _MentorMeetingScreenState();
}

class _MentorMeetingScreenState extends State<MentorMeetingScreen> {
  final TextEditingController _meetingLinkController = TextEditingController();
  final TextEditingController _dateTimeController = TextEditingController();
  String? selectedStudentEmail;
  DateTime? selectedDateTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<CounsellorProvider>().allStundentsApiTap(context);
    });
  }

  @override
  void dispose() {
    _meetingLinkController.dispose();
    _dateTimeController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          _dateTimeController.text = 
            "${selectedDateTime!.day}/${selectedDateTime!.month}/${selectedDateTime!.year} ${pickedTime.format(context)}";
        });
      }
    }
  }

Future<void> _openGoogleMeet() async {
  final url = Uri.parse("https://meet.google.com/new");

  try {
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
      showToast("Copy the meeting link and paste it below", type: toastType.info);
    } else {
      showToast("Could not open Google Meet", type: toastType.error);
    }
  } catch (e) {
    showToast("Error: ${e.toString()}", type: toastType.error);
    print("Error launching URL: $e");
  }
}


  final List<Map<String, String>> sessionTypes = [
    {
      'title': 'SDA Session',
      'subtitle': 'Skill/project work session with mentor',
    },
    {'title': 'Essay Review', 'subtitle': 'Discuss essay drafts and feedback'},
    {'title': 'Mock Interview', 'subtitle': 'Practice interview with mentor'},
    {
      'title': 'Parent Review Meeting',
      'subtitle': 'Progress discussion with parent + counsellor',
    },
    {'title': 'Counsellor Check-in', 'subtitle': 'Student progress review'},
    {
      'title': 'Founder Check-in',
      'subtitle': 'Special session with founder, when available',
    },
  ];

  final List<String> durations = ['30 min', '45 min', '60 min'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Schedule Meeting")),
      body: Consumer<CounsellorProvider>(
        builder: (context, pvd, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                  "Set up a session with your student to review progress or provide guidance.",
                  style: textStyle(
                    fontSize: 14,
                    fontFamily: AppFonts.interRegular,
                    color: Colors.grey,
                    ),
                  ),
                  hSpace(height: 24),

                  // Session Type
                  Text(
                  "1. Select Meeting Type",
                  style: textStyle(
                    fontFamily: AppFonts.interBold,
                    fontSize: 16,
                  ),
                  ),
                  Text("Choose the type of session you'd like to schedule."),
                  hSpace(height: 12),
                  ...sessionTypes.map((session) {
                  final isSelected =
                    pvd.selectedSessionType == session['title'];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected
                        ? Colors.black
                        : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    ),
                    child: RadioListTile<String>(
                    value: session['title']!,
                    groupValue: pvd.selectedSessionType,
                    onChanged: (value) {
                      pvd.setSelectedSessionType = value;
                    },
                    title: Text(
                      session['title']!,
                      style: textStyle(
                      fontFamily: AppFonts.interBold,
                      fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      session['subtitle']!,
                      style: textStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    dense: true,
                    ),
                  );
                  }).toList(),
                  hSpace(height: 24),
                  Text(
                  "2. Select Participant",
                  style: textStyle(
                    fontFamily: AppFonts.interBold,
                    fontSize: 18,
                  ),
                  ),
                  hSpace(height: 12),
                  Text(
                  "student: ",
                  style: textStyle(
                    fontSize: 14,
                    fontFamily: AppFonts.interBold,
                  ),
                  ),
                  Consumer<CounsellorProvider>(
                  builder: (context, pvd, child) {
                    final students = pvd.allStudentData?.data;
                    return  DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  hint: Text("Assign Student"),
                  value: selectedStudentEmail,
                  items: [
                    for(int i = 0; i < (students?.length ?? 0); i++)
                    DropdownMenuItem(value: students![i].email, child: Text(students[i].fullName!)),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedStudentEmail = value;
                    });
                  },
                  );
                  }),
                  hSpace(height: 24),
                  Text(
                  "3. Select Date & Time",
                  style: textStyle(
                    fontFamily: AppFonts.interBold,
                    fontSize: 18,
                  ),
                  ),
                  hSpace(height: 12),
                  Row(
                  spacing: 4,
                  children: [
                    Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Text(
                        "Select Date & Time:",
                        style: textStyle(color: Colors.grey),
                      ),
                      TextFormField(
                        controller: _dateTimeController,
                        readOnly: true,
                        onTap: _selectDateTime,
                        decoration: InputDecoration(
                        hintText: "DD/MM/YYYY HH:MM AM/PM",
                        suffixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        ),
                      ),
                      ],
                    ),
                    ),
                  ],
                  ),
                  hSpace(height: 24),
                  // Duration
                  Text(
                  "4. Duration",
                  style: textStyle(
                    fontFamily: AppFonts.interBold,
                    fontSize: 16,
                  ),
                  ),
                  hSpace(height: 12),
                  Row(
                  children: durations.map((duration) {
                    final isSelected = pvd.selectedDuration == duration;
                    return Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: OutlinedButton(
                      onPressed: () {
                        pvd.setSelectedDuration = duration;
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(
                        color: isSelected
                          ? Colors.black
                          : Colors.grey.shade300,
                        width: isSelected ? 2 : 1,
                        ),
                        backgroundColor: isSelected
                          ? Colors.black.withOpacity(0.05)
                          : Colors.white,
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        duration,
                        style: textStyle(
                        fontFamily: isSelected
                          ? AppFonts.interBold
                          : AppFonts.interMedium,
                        fontSize: 14,
                        color: Colors.black,
                        ),
                      ),
                      ),
                    ),
                    );
                  }).toList(),
                  ),
                  hSpace(height: 24),
                  Text(
                  "5. Purpose / Notes (optional)",
                  style: textStyle(
                    fontFamily: AppFonts.interBold,
                    fontSize: 16,
                  ),
                  ),
                  hSpace(height: 8),
                  TextFormField(
                  controller: pvd.sessionPurposeController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                    ),
                    hintStyle: textStyle(color: Colors.grey),
                    hintText:
                      "Review first essay draft before final submission",
                    border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  ),
                  hSpace(height: 8),
                  Text(
                  "Helps mentor/student understand the session goal",
                  style: textStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  hSpace(height: 24),

                  // Meeting Link Section
                  Text(
                  "6. Meeting Link",
                  style: textStyle(
                    fontFamily: AppFonts.interBold,
                    fontSize: 16,
                  ),
                  ),
                  hSpace(height: 8),
                  Row(
                  children: [
                    Expanded(
                    child: TextFormField(
                      controller: _meetingLinkController,
                      decoration: InputDecoration(
                      hintText: "Paste Google Meet link here",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      ),
                    ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton.icon(
                    onPressed: _openGoogleMeet,
                    icon: Icon(Icons.video_call),
                    label: Text("Open Meet"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    ),
                  ],
                  ),
                  hSpace(height: 8),
                  Text(
                  "Click 'Open Meet' to create a new meeting, then copy and paste the link here",
                  style: textStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  hSpace(height: 24),

                  Consumer<MentorProvider>(
                  builder: (context, mentorPvd, child) {
                    return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: mentorPvd.createMentorMeetingLoading
                        ? null
                        : () {
                        if (pvd.selectedSessionType == null) {
                          showToast("Please select meeting type", type: toastType.error);
                          return;
                        }
                        if (selectedStudentEmail == null) {
                          showToast("Please select a student", type: toastType.error);
                          return;
                        }
                        if (selectedDateTime == null) {
                          showToast("Please select date and time", type: toastType.error);
                          return;
                        }
                        if (pvd.selectedDuration == null) {
                          showToast("Please select duration", type: toastType.error);
                          return;
                        }
                        if (_meetingLinkController.text.trim().isEmpty) {
                          showToast("Please paste meeting link", type: toastType.error);
                          return;
                        }

                        mentorPvd.createMentorMeetingApiTap(
                          meetingType: pvd.selectedSessionType!,
                          assignedStudents: selectedStudentEmail!,
                          dateTime: selectedDateTime!.toIso8601String(),
                          duration: pvd.selectedDuration!,
                          purpose: pvd.sessionPurposeController.text.trim(),
                          meetingLink: _meetingLinkController.text.trim(),
                          context: context,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      ),
                      child: mentorPvd.createMentorMeetingLoading
                        ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                          )
                        : Text("Schedule Meeting"),
                    ),
                    );
                  },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
