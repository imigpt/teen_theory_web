import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:teen_theory/Resources/colors.dart';
import 'package:teen_theory/Utils/helper.dart';

class MentorProfileShimmer extends StatelessWidget {
  const MentorProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBaseColor,
      highlightColor: AppColors.shimmerHighlightColor,
      child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade200,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.person,
                            size: 54,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      hSpace(height: 12),
                      Text(
                        'Alex Morgan',
                        style: textStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      hSpace(height: 6),
                      Text(
                        'Senior Mentor',
                        style: textStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),
      
                hSpace(height: 20),
      
                Text(
                  'About',
                  style: textStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                hSpace(height: 8),
                Text(
                  '----',
                  style: textStyle(color: Colors.black87),
                ),
      
                hSpace(height: 16),
      
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Contact',
                                style: textStyle(fontWeight: FontWeight.w600),
                              ),
                              hSpace(height: 8),
                              Text(
                                '----',
                                style: textStyle(color: Colors.black54),
                              ),
                              hSpace(height: 6),
                              Text(
                                '----',
                                style: textStyle(color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    wSpace(width: 12),
                    Expanded(
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Availability',
                                style: textStyle(fontWeight: FontWeight.w600),
                              ),
                              hSpace(height: 8),
                              Text(
                                'Mon - Fri',
                                style: textStyle(color: Colors.black54),
                              ),
                              hSpace(height: 6),
                              Text(
                                '10:00 AM - 4:00 PM',
                                style: textStyle(color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
      
                hSpace(height: 16),
      
                Text(
                  'Specialities',
                  style: textStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                hSpace(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:[
                    Chip(label: Text("Data Science")),
                    Chip(label: Text("Machine Learning")),
                    Chip(label: Text("Python Programming")),
                  ]
                ),
      
                hSpace(height: 20),
      
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // message action
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Message action')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(
                          'Message',
                          style: textStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    wSpace(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          // book meeting action
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Book Meeting')),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: Colors.black),
                        ),
                        child: Text(
                          'Book Meeting',
                          style: textStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
    );
  }
}