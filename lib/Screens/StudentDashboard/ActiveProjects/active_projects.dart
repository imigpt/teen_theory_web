import 'package:flutter/material.dart';
import 'package:teen_theory/Resources/colors.dart';
import 'package:teen_theory/Resources/fonts.dart';
import 'package:teen_theory/Screens/StudentDashboard/ActiveProjects/detail_active_project.dart';
import 'package:teen_theory/Utils/helper.dart';

class ActiveProjects extends StatelessWidget {
  const ActiveProjects({super.key});

  // Sample list used only to drive ListView.builder (UI only)
  final List<Map<String, dynamic>> _projects = const [
    {
      'title': 'AI & Machine Learning',
      'subtitle': 'Building a recommendation System',
      'progress': 0.75,
      'due': '15 Oct',
    },
    {
      'title': 'Finance & Investment',
      'subtitle': 'Portfolio optimization analysis',
      'progress': 0.50,
      'due': '18 Oct',
    },
    {
      'title': 'Entrepreneurship',
      'subtitle': 'Startup business plan development',
      'progress': 0.30,
      'due': '22 Oct',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Text(
          'Active Projects',
          style: textStyle(fontFamily: AppFonts.interBold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Your Projects header
            Text(
              'Your Projects',
              style: textStyle(fontFamily: AppFonts.interBold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              'Track your progress',
              style: textStyle(color: AppColors.lightGrey2),
            ),
            const SizedBox(height: 12),

            // summary chips row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _summaryChip('5', 'Active'),
                _summaryChip('12', 'Completed'),
                _summaryChip('3', 'In Review'),
              ],
            ),
            const SizedBox(height: 20),

            // SDA Projects title
            Text(
              'SDA Projects',
              style: textStyle(fontFamily: AppFonts.interMedium, fontSize: 14),
            ),
            const SizedBox(height: 8),
            const Divider(),

            // projects list
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _projects.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final project = _projects[index];
                final progress = (project['progress'] as double);
                final progressPercent = (progress * 100).round();

                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DetailActiveProject(),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14.0,
                        vertical: 12.0,
                      ),
                      child: Row(
                        children: [
                          // black bullet
                          Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),

                          // title + subtitle + progress
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  project['title'] as String,
                                  style: textStyle(
                                    fontFamily: AppFonts.interBold,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  project['subtitle'] as String,
                                  style: textStyle(
                                    color: AppColors.lightGrey2,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // progress row
                                Row(
                                  children: [
                                    Expanded(
                                      child: LinearProgressIndicator(
                                        value: progress,
                                        minHeight: 6,
                                        backgroundColor: Colors.grey.shade300,
                                        color: Colors.green,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                  ],
                                ),
                                hSpace(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '$progressPercent% Complete',
                                      style: textStyle(
                                        color: AppColors.lightGrey2,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      'Due: ${project['due']}',
                                      style: textStyle(
                                        color: Colors.redAccent,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 12),

                          // due date
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // view all CTA
            Center(
              child: Text(
                'View all SDA Projects',
                style: textStyle(
                  color: AppColors.black,
                  fontFamily: AppFonts.interMedium,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  'Custom Projects',
                  style: textStyle(
                    fontFamily: AppFonts.interBold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                const Divider(),

                // projects list (UI only)
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 3,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14.0,
                          vertical: 14.0,
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // black bullet
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Container(
                                    width: 12,
                                    height: 12,
                                    decoration: const BoxDecoration(
                                      color: Colors.black,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // title + subtitle
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Science Fair Competition",
                                      style: textStyle(
                                        fontFamily: AppFonts.interBold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      "Enviromental Impact Research",
                                      style: textStyle(
                                        color: AppColors.lightGrey2,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // tag (left) and status/due (right)
                            Row(
                              children: [
                                // tag
                                Padding(
                                  padding: const EdgeInsets.only(left: 25.0),
                                  child: Text(
                                    "Competition",
                                    style: textStyle(
                                      fontFamily: AppFonts.interMedium,
                                      color: Colors.green,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),

                                const Spacer(),

                                // status / due
                                Text(
                                  "on Going",
                                  style: textStyle(
                                    fontFamily: AppFonts.interMedium,
                                    color: Colors.redAccent,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),

                // view all CTA
                Center(
                  child: Text(
                    'View all Custom Projects',
                    style: textStyle(
                      color: AppColors.black,
                      fontFamily: AppFonts.interMedium,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'College Applications',
                  style: textStyle(
                    fontFamily: AppFonts.interMedium,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                const Divider(),
                const SizedBox(height: 8),

                // cards list
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 3,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14.0,
                          vertical: 14,
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // icon circle
                                Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.school,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // title and small meta row
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Stanford University",
                                        style: textStyle(
                                          fontFamily: AppFonts.interBold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.article_outlined,
                                            size: 14,
                                            color: AppColors.lightGrey2,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            'Essays: 3/4',
                                            style: textStyle(
                                              color: AppColors.lightGrey2,
                                              fontSize: 12,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Icon(
                                            Icons.mail_outline,
                                            size: 14,
                                            color: AppColors.lightGrey2,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            'LORs: 2/3',
                                            style: textStyle(
                                              color: AppColors.lightGrey2,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                // status / due
                                Text(
                                  "Due: Jan 1",
                                  style: textStyle(
                                    color: Colors.redAccent,
                                    fontFamily: AppFonts.interMedium,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // progress bar + percent row
                            Row(
                              children: [
                                Expanded(
                                  child: LinearProgressIndicator(
                                    value: 0.5,
                                    minHeight: 6,
                                    backgroundColor: Colors.grey.shade300,
                                    color: Colors.green,
                                  ),
                                ),
                                const SizedBox(width: 12),
                              ],
                            ),
                            hSpace(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '60% Complete',
                                  style: textStyle(
                                    color: AppColors.lightGrey2,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 12),
                Center(
                  child: Text(
                    'View all College Applications',
                    style: textStyle(
                      color: AppColors.black,
                      fontFamily: AppFonts.interMedium,
                    ),
                  ),
                ),
              ],
            ),
            hSpace(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _summaryChip(String number, String label) {
    return Expanded(
      child: Container(
        height: 62,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                number,
                style: textStyle(
                  color: AppColors.white,
                  fontFamily: AppFonts.interBold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: textStyle(color: AppColors.white, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
