import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Models/CommonModels/all_mentor_model.dart' as mentor_model;
import '../../Models/CommonModels/all_parent__model.dart' as parent_model;
import '../../Models/CommonModels/all_student_model.dart';
import '../../Providers/CounsellorProvider/counsellor_provider.dart';
import '../../Resources/colors.dart';
import '../../Resources/fonts.dart';
import '../../Services/apis.dart';
import '../../Services/dio_client.dart';
import '../../Utils/app_logger.dart';
import '../../Utils/helper.dart';

class CreateMeetingScreen extends StatefulWidget {
  const CreateMeetingScreen({super.key});

  @override
  State<CreateMeetingScreen> createState() => _CreateMeetingScreenState();
}

class _CreateMeetingScreenState extends State<CreateMeetingScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _meetingLinkController = TextEditingController();

  bool _isLoadingStudents = false;
  bool _isLoadingMentors = false;
  bool _isLoadingParents = false;
  bool _isGeneratingLink = false;

  List<AllStudentDatum> _students = [];
  List<mentor_model.Datum> _mentors = [];
  List<parent_model.Datum> _parents = [];

  List<String> _selectedStudentEmails = [];
  List<String> _selectedMentorEmails = [];
  List<String> _selectedParentEmails = [];

  @override
  void initState() {
    super.initState();
    _fetchStudentsAndMentors();
  }

  Future<void> _fetchStudentsAndMentors() async {
    await Future.wait([
      _fetchStudents(),
      _fetchMentors(),
      _fetchParents(),
    ]);
  }

  Future<void> _fetchStudents() async {
    setState(() => _isLoadingStudents = true);
    try {
      await DioClient.getAllStudents(
        onSuccess: (model) {
          if (mounted) {
            setState(() {
              _students = model.data ?? [];
              _isLoadingStudents = false;
            });
          }
        },
        onError: (error) {
          AppLogger.error(message: 'Error fetching students: $error');
          if (mounted) {
            setState(() => _isLoadingStudents = false);
            showToast('Failed to load students', type: toastType.error);
          }
        },
      );
    } catch (e) {
      AppLogger.error(message: 'Error fetching students: $e');
      if (mounted) {
        setState(() => _isLoadingStudents = false);
        showToast('Failed to load students', type: toastType.error);
      }
    }
  }

  Future<void> _fetchMentors() async {
    setState(() => _isLoadingMentors = true);
    try {
      await DioClient.getAllMentors(
        onSuccess: (model) {
          if (mounted) {
            setState(() {
              _mentors = model.data ?? [];
              _isLoadingMentors = false;
            });
          }
        },
        onError: (error) {
          AppLogger.error(message: 'Error fetching mentors: $error');
          if (mounted) {
            setState(() => _isLoadingMentors = false);
            showToast('Failed to load mentors', type: toastType.error);
          }
        },
      );
    } catch (e) {
      AppLogger.error(message: 'Error fetching mentors: $e');
      if (mounted) {
        setState(() => _isLoadingMentors = false);
        showToast('Failed to load mentors', type: toastType.error);
      }
    }
  }

  Future<void> _fetchParents() async {
    setState(() => _isLoadingParents = true);
    try {
      await DioClient.getAllParents(
        onSuccess: (model) {
          if (mounted) {
            setState(() {
              _parents = model.data ?? [];
              _isLoadingParents = false;
            });
          }
        },
        onError: (error) {
          AppLogger.error(message: 'Error fetching parents: $error');
          if (mounted) {
            setState(() => _isLoadingParents = false);
            showToast('Failed to load parents', type: toastType.error);
          }
        },
      );
    } catch (e) {
      AppLogger.error(message: 'Error fetching parents: $e');
      if (mounted) {
        setState(() => _isLoadingParents = false);
        showToast('Failed to load parents', type: toastType.error);
      }
    }
  }

  Future<void> _generateMeetingLink() async {
    setState(() => _isGeneratingLink = true);
    try {
      await openExternalLink("https://meet.google.com/new");
      showToast('Opening Google Meet. Please copy and paste the meeting link below.', type: toastType.info);
    } catch (e) {
      AppLogger.error(message: 'Error generating meeting link: $e');
      showToast('Failed to open Google Meet', type: toastType.error);
    } finally {
      setState(() => _isGeneratingLink = false);
    }
  }

  Future<void> _createMeeting() async {
    // Validation
    if (_titleController.text.trim().isEmpty) {
      showToast('Please enter a meeting title', type: toastType.error);
      return;
    }

    if (_selectedStudentEmails.isEmpty && _selectedMentorEmails.isEmpty && _selectedParentEmails.isEmpty) {
      showToast('Please select at least one student, mentor, or parent', type: toastType.error);
      return;
    }

    if (_meetingLinkController.text.trim().isEmpty) {
      showToast('Please enter or generate a meeting link', type: toastType.error);
      return;
    }

    final provider = Provider.of<CounsellorProvider>(context, listen: false);
    
    provider.createMeetingApiTap(
      context,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      meetingLink: _meetingLinkController.text.trim(),
      studentEmails: _selectedStudentEmails,
      mentorEmails: _selectedMentorEmails,
      parentEmails: _selectedParentEmails,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _meetingLinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CounsellorProvider>(context);
    
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Create Meeting',
          style: AppFonts.medium.copyWith(
            fontSize: 20,
            color: AppColors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoadingStudents || _isLoadingMentors || _isLoadingParents
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Meeting Title
                  Text(
                    'Meeting Title',
                    style: AppFonts.medium.copyWith(
                      fontSize: 16,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: 'Enter meeting title',
                      hintStyle: AppFonts.regular.copyWith(
                        color: AppColors.grey,
                      ),
                      filled: true,
                      fillColor: AppColors.lightGrey.withOpacity(0.3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Meeting Description
                  Text(
                    'Meeting Description',
                    style: AppFonts.medium.copyWith(
                      fontSize: 16,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Enter meeting description (optional)',
                      hintStyle: AppFonts.regular.copyWith(
                        color: AppColors.grey,
                      ),
                      filled: true,
                      fillColor: AppColors.lightGrey.withOpacity(0.3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Meeting Link Section
                  Text(
                    'Meeting Link',
                    style: AppFonts.medium.copyWith(
                      fontSize: 16,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _meetingLinkController,
                          decoration: InputDecoration(
                            hintText: 'Paste meeting link here',
                            hintStyle: AppFonts.regular.copyWith(
                              color: AppColors.grey,
                            ),
                            filled: true,
                            fillColor: AppColors.lightGrey.withOpacity(0.3),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: _isGeneratingLink ? null : _generateMeetingLink,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                        ),
                        child: _isGeneratingLink
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.white,
                                ),
                              )
                            : Text(
                                'Generate',
                                style: AppFonts.medium.copyWith(
                                  color: AppColors.white,
                                  fontSize: 14,
                                ),
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Students Section
                  _buildParticipantSection(
                    title: 'Select Students',
                    count: _selectedStudentEmails.length,
                    children: _students.map((student) {
                      final isSelected = _selectedStudentEmails.contains(student.email);
                      return CheckboxListTile(
                        value: isSelected,
                        onChanged: (value) {
                          setState(() {
                            if (value == true) {
                              _selectedStudentEmails.add(student.email ?? '');
                            } else {
                              _selectedStudentEmails.remove(student.email);
                            }
                          });
                        },
                        title: Text(
                          student.fullName ?? 'Unknown',
                          style: AppFonts.medium.copyWith(
                            fontSize: 14,
                            color: AppColors.black,
                          ),
                        ),
                        subtitle: Text(
                          student.email ?? '',
                          style: AppFonts.regular.copyWith(
                            fontSize: 12,
                            color: AppColors.grey,
                          ),
                        ),
                        secondary: CircleAvatar(
                          backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                          backgroundImage: student.profilePhoto != null && student.profilePhoto!.isNotEmpty
                              ? NetworkImage('${Apis.baseUrl}${student.profilePhoto!}')
                              : null,
                          child: student.profilePhoto == null || student.profilePhoto!.isEmpty
                              ? Text(
                                  (student.fullName ?? 'U')[0].toUpperCase(),
                                  style: AppFonts.medium.copyWith(
                                    color: AppColors.primaryColor,
                                  ),
                                )
                              : null,
                        ),
                        activeColor: AppColors.primaryColor,
                        contentPadding: EdgeInsets.zero,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Mentors Section
                  _buildParticipantSection(
                    title: 'Select Mentors',
                    count: _selectedMentorEmails.length,
                    children: _mentors.map((mentor) {
                      final isSelected = _selectedMentorEmails.contains(mentor.email);
                      return CheckboxListTile(
                        value: isSelected,
                        onChanged: (value) {
                          setState(() {
                            if (value == true) {
                              _selectedMentorEmails.add(mentor.email ?? '');
                            } else {
                              _selectedMentorEmails.remove(mentor.email);
                            }
                          });
                        },
                        title: Text(
                          mentor.fullName ?? 'Unknown',
                          style: AppFonts.medium.copyWith(
                            fontSize: 14,
                            color: AppColors.black,
                          ),
                        ),
                        subtitle: Text(
                          mentor.email ?? '',
                          style: AppFonts.regular.copyWith(
                            fontSize: 12,
                            color: AppColors.grey,
                          ),
                        ),
                        secondary: CircleAvatar(
                          backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                          backgroundImage: mentor.profilePhoto != null && mentor.profilePhoto!.isNotEmpty
                              ? NetworkImage('${Apis.baseUrl}${mentor.profilePhoto!}')
                              : null,
                          child: mentor.profilePhoto == null || mentor.profilePhoto!.isEmpty
                              ? Text(
                                  (mentor.fullName ?? 'U')[0].toUpperCase(),
                                  style: AppFonts.medium.copyWith(
                                    color: AppColors.primaryColor,
                                  ),
                                )
                              : null,
                        ),
                        activeColor: AppColors.primaryColor,
                        contentPadding: EdgeInsets.zero,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Parents Section
                  _buildParticipantSection(
                    title: 'Select Parents',
                    count: _selectedParentEmails.length,
                    children: _parents.map((parent) {
                      final isSelected = _selectedParentEmails.contains(parent.email);
                      return CheckboxListTile(
                        value: isSelected,
                        onChanged: (value) {
                          setState(() {
                            if (value == true) {
                              _selectedParentEmails.add(parent.email ?? '');
                            } else {
                              _selectedParentEmails.remove(parent.email);
                            }
                          });
                        },
                        title: Text(
                          parent.fullName ?? 'Unknown',
                          style: AppFonts.medium.copyWith(
                            fontSize: 14,
                            color: AppColors.black,
                          ),
                        ),
                        subtitle: Text(
                          parent.email ?? '',
                          style: AppFonts.regular.copyWith(
                            fontSize: 12,
                            color: AppColors.grey,
                          ),
                        ),
                        secondary: CircleAvatar(
                          backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                          backgroundImage: parent.profilePhoto != null && parent.profilePhoto!.isNotEmpty
                              ? NetworkImage('${Apis.baseUrl}${parent.profilePhoto!}')
                              : null,
                          child: parent.profilePhoto == null || parent.profilePhoto!.isEmpty
                              ? Text(
                                  (parent.fullName ?? 'U')[0].toUpperCase(),
                                  style: AppFonts.medium.copyWith(
                                    color: AppColors.primaryColor,
                                  ),
                                )
                              : null,
                        ),
                        activeColor: AppColors.primaryColor,
                        contentPadding: EdgeInsets.zero,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 30),

                  // Create Meeting Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: provider.creatingMeeting ? null : _createMeeting,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: provider.creatingMeeting
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.white,
                              ),
                            )
                          : Text(
                              'Create Meeting',
                              style: AppFonts.semiBold.copyWith(
                                fontSize: 16,
                                color: AppColors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget _buildParticipantSection({
    required String title,
    required int count,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightGrey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppFonts.semiBold.copyWith(
                  fontSize: 16,
                  color: AppColors.black,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$count selected',
                  style: AppFonts.medium.copyWith(
                    fontSize: 12,
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (children.isEmpty)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(
                  'No ${title.toLowerCase()} available',
                  style: AppFonts.regular.copyWith(
                    color: AppColors.grey,
                  ),
                ),
              ),
            )
          else
            ...children,
        ],
      ),
    );
  }
}
