import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teen_theory/Providers/CounsellorProvider/counsellor_provider.dart';
import 'package:teen_theory/Resources/fonts.dart';
import 'package:teen_theory/Utils/helper.dart';

class Step6 extends StatelessWidget {
  Step6({super.key});

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
    return Consumer<CounsellorProvider>(
      builder: (context, pvd, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            Text(
              "Scheduling & Sessions",
              style: textStyle(fontSize: 20, fontFamily: AppFonts.interBold),
            ),
            Text(
              "Plan important meetings to support the student's progress. Sessions will be booked using templates and approved based on availability.",
              style: textStyle(
                fontSize: 14,
                fontFamily: AppFonts.interRegular,
                color: Colors.grey,
              ),
            ),
            hSpace(height: 24),

            // Session Type
            Text(
              "Session Type",
              style: textStyle(fontFamily: AppFonts.interBold, fontSize: 16),
            ),
            hSpace(height: 12),
            ...sessionTypes.map((session) {
              final isSelected = pvd.selectedSessionType == session['title'];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected ? Colors.black : Colors.grey.shade300,
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
                    style: textStyle(fontSize: 12, color: Colors.grey.shade600),
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

            // Purpose / Notes
            Text(
              "Purpose / Notes (optional)",
              style: textStyle(fontFamily: AppFonts.interBold, fontSize: 16),
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
                hintText: "Review first essay draft before final submission",
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

            // Preferred Timing
            Text(
              "Preferred Timing",
              style: textStyle(fontFamily: AppFonts.interBold, fontSize: 16),
            ),
            hSpace(height: 12),
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: pvd.preferredTiming == 'Specific Date'
                      ? Colors.black
                      : Colors.grey.shade300,
                  width: pvd.preferredTiming == 'Specific Date' ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: RadioListTile<String>(
                value: 'Specific Date',
                groupValue: pvd.preferredTiming,
                onChanged: (value) {
                  pvd.setPreferredTiming = value;
                },
                title: Text(
                  "Specific Date",
                  style: textStyle(
                    fontFamily: AppFonts.interMedium,
                    fontSize: 14,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                dense: true,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: pvd.preferredTiming == 'Week Range'
                      ? Colors.black
                      : Colors.grey.shade300,
                  width: pvd.preferredTiming == 'Week Range' ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: RadioListTile<String>(
                value: 'Week Range',
                groupValue: pvd.preferredTiming,
                onChanged: (value) {
                  pvd.setPreferredTiming = value;
                },
                title: Text(
                  "Week Range",
                  style: textStyle(
                    fontFamily: AppFonts.interMedium,
                    fontSize: 14,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                dense: true,
              ),
            ),
            hSpace(height: 24),

            // Duration
            Text(
              "Duration",
              style: textStyle(fontFamily: AppFonts.interBold, fontSize: 16),
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
          ],
        );
      },
    );
  }
}
