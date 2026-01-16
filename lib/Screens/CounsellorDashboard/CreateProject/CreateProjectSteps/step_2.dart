import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teen_theory/Providers/AuthProviders/auth_provider.dart';
import 'package:teen_theory/Providers/CounsellorProvider/counsellor_provider.dart';
import 'package:teen_theory/Screens/CounsellorDashboard/CreateProject/create_project_main.dart';

class Step2 extends StatefulWidget {
  final TextEditingController studentSearchController;
  final List<Map<String, String>> assignedStudents;
  final TextEditingController mentorSearchController;
  Map<String, dynamic>? assignedMentor;
  Map<String, String>? projectCounsellor;
  Step2({
    super.key,
    required this.studentSearchController,
    required this.assignedStudents,
    required this.mentorSearchController,
    required this.assignedMentor,
    required this.projectCounsellor,
  });

  @override
  State<Step2> createState() => _Step2State();
}

class _Step2State extends State<Step2> {
  bool _showStudentDropdown = false;
  bool _showMentorDropdown = false;

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final pvd = context.read<CounsellorProvider>();
      pvd.allStundentsApiTap(context);
      pvd.allMentorsApiTap(context);
    });
    
    // Listen to search controller changes
    widget.studentSearchController.addListener(() {
      setState(() {
        _showStudentDropdown = widget.studentSearchController.text.isNotEmpty;
      });
    });
    
    widget.mentorSearchController.addListener(() {
      setState(() {
        _showMentorDropdown = widget.mentorSearchController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    widget.studentSearchController.removeListener(() {});
    widget.mentorSearchController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CounsellorProvider>(
      builder: (context, pvd, child) {
      return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Assign People & Access',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Select students, mentor and set visibility permissions for this project.',
          style: TextStyle(fontSize: 14, color: Color(0xFF757575), height: 1.4),
        ),
        const SizedBox(height: 32),

        // Assign Students
        const Text(
          'Assign Students',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),

        Column(
          children: [
            TextField(
              controller: widget.studentSearchController,
              decoration: InputDecoration(
                hintText: 'Search Students....',
                hintStyle: const TextStyle(color: Color(0xFFBDBDBD), fontSize: 14),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Color(0xFF757575),
                  size: 20,
                ),
                suffixIcon: widget.studentSearchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: () {
                          widget.studentSearchController.clear();
                          setState(() {
                            _showStudentDropdown = false;
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.black, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
            if (_showStudentDropdown && pvd.isLoadingStudents)
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                ),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            if (_showStudentDropdown && !pvd.isLoadingStudents)
              _buildStudentDropdown(pvd),
          ],
        ),
        const SizedBox(height: 12),

        ...pvd.assignedStudents.map(
          (student) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildAssignedCard(
              name: student['name']!,
              subtitle: student['grade']!,
              onRemove: () {
                pvd.removeStudentFromProject(student['id']!);
              },
            ),
          ),
        ),

        const Text(
          'Assign Mentor',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),

        Column(
          children: [
            TextField(
              controller: widget.mentorSearchController,
              decoration: InputDecoration(
                hintText: 'Search mentor....',
                hintStyle: const TextStyle(color: Color(0xFFBDBDBD), fontSize: 14),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Color(0xFF757575),
                  size: 20,
                ),
                suffixIcon: widget.mentorSearchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: () {
                          widget.mentorSearchController.clear();
                          setState(() {
                            _showMentorDropdown = false;
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.black, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
            if (_showMentorDropdown && pvd.isLoadingMentors)
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                ),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            if (_showMentorDropdown && !pvd.isLoadingMentors)
              _buildMentorDropdown(pvd),
          ],
        ),
        const SizedBox(height: 12),

        if (pvd.assignedMentor != null)
          _buildMentorCard(
            name: pvd.assignedMentor!['name'],
            email: pvd.assignedMentor!['email'],
            subtitle: pvd.assignedMentor!['subtitle'],
            rating: pvd.assignedMentor!['rating'],
            reviews: pvd.assignedMentor!['reviews'],
            onRemove: () {
              pvd.removeMentorFromProject();
            },
          ),
        const SizedBox(height: 32),

        // Project Counsellor
        const Text(
          'Project Counsellor',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),

        Consumer<AuthProvider>(
          builder: (context, authPvd, child) {
            final counsellorData = authPvd.profileData?.data;
            if (counsellorData != null && counsellorData.userRole == 'Counsellor') {
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFD6D6D6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey.shade400,
                      backgroundImage: counsellorData.profilePhoto != null && counsellorData.profilePhoto!.isNotEmpty
                          ? NetworkImage(counsellorData.profilePhoto!)
                          : null,
                      child: counsellorData.profilePhoto == null || counsellorData.profilePhoto!.isEmpty
                          ? const Icon(Icons.person, color: Colors.white, size: 22)
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            counsellorData.fullName ?? 'Counsellor',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            counsellorData.email ?? '',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF757575),
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Project Counsellor (Auto-Assigned)',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF424242),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
        const SizedBox(height: 32),

        // Parent Visibility
        const Text(
          'Parent Visibility',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Allow Parent to view this project?',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Parents can see progress updates and deadlines',
                style: TextStyle(fontSize: 12, color: Color(0xFF757575)),
              ),
              const SizedBox(height: 12),
              const Text(
                'Progress Updates',
                style: TextStyle(fontSize: 13, color: Color(0xFF424242)),
              ),
              const SizedBox(height: 4),
              const Text(
                'Milestone Deadlines',
                style: TextStyle(fontSize: 13, color: Color(0xFF424242)),
              ),
              const SizedBox(height: 4),
              const Text(
                'Final Results',
                style: TextStyle(fontSize: 13, color: Color(0xFF424242)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),

        // Assigned Summary
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Assigned Summary',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),

              _buildSummaryRow(
                'Students:',
                '${pvd.assignedStudents.length} assigned',
                Colors.black,
              ),
              const SizedBox(height: 8),

              _buildSummaryRow(
                'Mentor:',
                pvd.assignedMentor != null ? '1 assigned' : '0 assigned',
                Colors.black,
              ),
              const SizedBox(height: 8),

              _buildSummaryRow(
                'Parent Access:',
                'Enabled',
                const Color(0xFFD32F2F),
              ),
            ],
          ),
        ),
      ],
    );
    });
  }

  Widget _buildAssignedCard({
    required String name,
    required String subtitle,
    required VoidCallback onRemove,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFD6D6D6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey.shade400,
            child: const Icon(Icons.person, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF424242),
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: onRemove,
            child: const Icon(Icons.close, size: 20, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildMentorCard({
    required String name,
    required String email,
    required String subtitle,
    required String rating,
    required String reviews,
    required VoidCallback onRemove,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFD6D6D6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey.shade400,
            child: const Icon(Icons.person, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  email,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF757575),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF424242),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    ...List.generate(5, (index) {
                      return const Icon(
                        Icons.star,
                        size: 12,
                        color: Color(0xFFFFC107),
                      );
                    }),
                    const SizedBox(width: 4),
                    Text(
                      '$rating ($reviews)',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF424242),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          InkWell(
            onTap: onRemove,
            child: const Icon(Icons.close, size: 20, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Color(0xFF424242)),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  Widget _buildStudentDropdown(CounsellorProvider pvd) {
    final filteredStudents = pvd.getFilteredStudents(widget.studentSearchController.text);
    
    if (filteredStudents.isEmpty) {
      return Container(
        margin: const EdgeInsets.only(top: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: const Text(
          'No students found',
          style: TextStyle(color: Color(0xFF757575)),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(top: 4),
      constraints: const BoxConstraints(maxHeight: 200),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: filteredStudents.length,
        itemBuilder: (context, index) {
          final student = filteredStudents[index];
          final isAssigned = pvd.assignedStudents.any((s) => s['id'] == student.id);
          
          return ListTile(
            leading: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey.shade300,
              child: const Icon(Icons.person, color: Colors.white, size: 18),
            ),
            title: Text(
              student.fullName ?? 'Unknown',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              student.email ?? '',
              style: const TextStyle(fontSize: 12),
            ),
            trailing: isAssigned
                ? const Icon(Icons.check_circle, color: Colors.green, size: 20)
                : const Icon(Icons.add_circle_outline, color: Colors.black, size: 20),
            onTap: () {
              if (!isAssigned) {
                pvd.addStudentToProject(student);
                widget.studentSearchController.clear();
                setState(() {
                  _showStudentDropdown = false;
                });
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildMentorDropdown(CounsellorProvider pvd) {
    final filteredMentors = pvd.getFilteredMentors(widget.mentorSearchController.text);
    
    if (filteredMentors.isEmpty) {
      return Container(
        margin: const EdgeInsets.only(top: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: const Text(
          'No mentors found',
          style: TextStyle(color: Color(0xFF757575)),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(top: 4),
      constraints: const BoxConstraints(maxHeight: 200),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: filteredMentors.length,
        itemBuilder: (context, index) {
          final mentor = filteredMentors[index];
          final isAssigned = pvd.assignedMentor?['id'] == mentor.id;
          
          return ListTile(
            leading: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey.shade300,
              child: const Icon(Icons.person, color: Colors.white, size: 18),
            ),
            title: Text(
              mentor.fullName ?? 'Unknown',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mentor.email ?? '',
                  style: const TextStyle(fontSize: 12),
                ),
                if (mentor.expertise?.isNotEmpty == true)
                  Text(
                    mentor.expertise![0],
                    style: const TextStyle(fontSize: 11, color: Color(0xFF757575)),
                  ),
              ],
            ),
            trailing: isAssigned
                ? const Icon(Icons.check_circle, color: Colors.green, size: 20)
                : const Icon(Icons.add_circle_outline, color: Colors.black, size: 20),
            onTap: () {
              if (!isAssigned) {
                pvd.addMentorToProject(mentor);
                widget.mentorSearchController.clear();
                setState(() {
                  _showMentorDropdown = false;
                });
              }
            },
          );
        },
      ),
    );
  }
}
