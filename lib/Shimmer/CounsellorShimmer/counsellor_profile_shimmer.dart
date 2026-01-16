import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:teen_theory/Resources/colors.dart';
import 'package:teen_theory/Utils/helper.dart';

class CounsellorProfileShimmer extends StatelessWidget {
  const CounsellorProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
       
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade200,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 20,
                          color: Colors.grey.shade200,
                        ),
                        hSpace(height: 6),
                        Container(
                          width: 150,
                          height: 16,
                          color: Colors.grey.shade200,
                        ),
                        hSpace(height: 8),
                        // Row(
                        //   children: [
                        //     _statItem('4.9', 'Rating'),
                        //     wSpace(width: 12),
                        //     _statItem('1.2k', 'Students'),
                        //     wSpace(width: 12),
                        //     _statItem('8y', 'Experience'),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
          
              // spacing
              hSpace(height: 18),
          
              // About / Bio
              Text(
                'About',
                style: textStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              hSpace(height: 8),
              Container(
                width: double.infinity,
                height: 60,
                color: Colors.grey.shade200,
              ),
          
              hSpace(height: 16),
          
              // Contact & Availability
              Row(
                children: [
                  Expanded(
                    child: _infoCard(
                      title: 'Contact',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.email, size: 16),
                              const SizedBox(width: 8),
                              Text(
                                '---------',
                                style: textStyle(fontSize: 13),
                              ),
                            ],
                          ),
                          hSpace(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.phone, size: 16),
                              const SizedBox(width: 8),
                              Text(
                                '-----------',
                                style: textStyle(fontSize: 13),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  wSpace(width: 12),
                  Expanded(
                    child: _infoCard(
                      title: 'Availability',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '--------',
                            style: textStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          hSpace(height: 6),
                          Text(
                            '----------',
                            style: textStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
          
              hSpace(height: 16),
          
              // Specialities / Tags
              Text(
                'Specialities',
                style: textStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              hSpace(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _chip('Academic Writing'),
                  _chip('Research Methodology'),
                  _chip('College Admissions'),
                  _chip('Time Management'),
                ],
              ),
          
              hSpace(height: 18),
          
              // Reviews
              Text(
                'Recent Reviews',
                style: textStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              hSpace(height: 8),
              Container(
                width: double.infinity,
                height: 100,
                color: Colors.grey.shade200,
              ),
              const Divider(),
              _reviewItem(
                'Alex Johnson',
                'Very helpful feedback and follow-up resources.',
                'Sep 28, 2025',
              ),
          
              hSpace(height: 18),
          
              // Actions
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                  
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Edit Profile',
                    style: textStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ));
  }
  Widget _infoCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          hSpace(height: 8),
          child,
        ],
      ),
    );
  }

  Widget _chip(String label) {
    return Chip(
      backgroundColor: AppColors.lightGrey3,
      label: Text(label, style: textStyle(fontSize: 13)),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    );
  }

  Widget _reviewItem(String name, String text, String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.blue.shade100,
            child: Text(name[0], style: textStyle(fontWeight: FontWeight.w700)),
          ),
          wSpace(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: textStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
                hSpace(height: 4),
                Text(
                  text,
                  style: textStyle(fontSize: 13, color: Colors.grey.shade800),
                ),
                hSpace(height: 6),
                Text(
                  date,
                  style: textStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}