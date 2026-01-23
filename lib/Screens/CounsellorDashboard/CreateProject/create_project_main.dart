import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teen_theory/Customs/custom_button.dart';
import 'package:teen_theory/Providers/AuthProviders/auth_provider.dart';
import 'package:teen_theory/Providers/CounsellorProvider/counsellor_provider.dart';
import 'package:teen_theory/Screens/CounsellorDashboard/CreateProject/CreateProjectSteps/step_2.dart';
import 'package:teen_theory/Screens/CounsellorDashboard/CreateProject/CreateProjectSteps/step_3.dart';
import 'package:teen_theory/Screens/CounsellorDashboard/CreateProject/CreateProjectSteps/step_4.dart';
import 'package:teen_theory/Screens/CounsellorDashboard/CreateProject/CreateProjectSteps/step_5.dart';
import 'package:teen_theory/Screens/CounsellorDashboard/CreateProject/CreateProjectSteps/step_6.dart';
import 'package:teen_theory/Screens/CounsellorDashboard/CreateProject/CreateProjectSteps/step_7.dart';
import 'package:teen_theory/Screens/CounsellorDashboard/CreateProject/CreateProjectSteps/step_8.dart';
import 'package:teen_theory/Screens/CounsellorDashboard/CreateProject/CreateProjectSteps/steps_1.dart';

class CreateProjectMain extends StatefulWidget {
  const CreateProjectMain({super.key});

  @override
  State<CreateProjectMain> createState() => _CreateProjectMainState();
}

class _CreateProjectMainState extends State<CreateProjectMain> {
  @override
  void dispose() {
    context.read<CounsellorProvider>().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 30),
        child: Consumer<CounsellorProvider>(
          builder: (context, pvd, child) {
            return AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => pvd.previousStep(context),
              ),
              title: const Text(
                'Create Project',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          },
        ),
      ),
      body: Consumer<CounsellorProvider>(
        builder: (context, pvd, child) {
          return Column(
            children: [
              const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Progress indicator
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Step ${pvd.currentStep} of ${pvd.totalSteps}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF757575),
                              ),
                            ),
                            Text(
                              '${pvd.currentStep}/${pvd.totalSteps}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF757575),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Progress bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: pvd.currentStep / pvd.totalSteps,
                            backgroundColor: const Color(0xFFE0E0E0),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.black,
                            ),
                            minHeight: 8,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Content based on current step
                        _buildStepContent(pvd),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom buttons
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: Color(0xFFE0E0E0), width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => pvd.previousStep(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE0E0E0),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Back',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Flexible(
                      child: CustomButton(
                        isEnabled: pvd.currentStep == pvd.totalSteps ? pvd.canCreateProject : true,
                        fontsize: 16,
                        height: 55,
                        borderRadius: 8,
                        title: pvd.currentStep == pvd.totalSteps ? 'Create Project' : 'Next Step', 
                        isLoading: pvd.isCreating, onTap: () {
                         if (pvd.currentStep == pvd.totalSteps) {
                              final authPvd = context.read<AuthProvider>();
                              final counsellorEmail = authPvd.profileData?.data?.email;
                              pvd.createProjectApiTap(context, counsellorEmail: counsellorEmail);
                            } else {
                              // Validate current step before proceeding
                              final validationError = pvd.validateCurrentStep();
                              if (validationError != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(validationError),
                                    backgroundColor: Colors.red,
                                    behavior: SnackBarBehavior.floating,
                                    duration: const Duration(seconds: 3),
                                  ),
                                );
                                return;
                              }
                              pvd.nextStep();
                            }
                      }),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStepContent(CounsellorProvider pvd) {
    switch (pvd.currentStep) {
      case 1:
        return Steps1(
          projectTitleController: pvd.projectTitleController,
          selectedTemplate: pvd.selectedProjectType,
          descriptionController: pvd.descriptionController,
          onTemplateChanged: (newValue) {
            print(newValue);
            pvd.setSelectedProjectType(newValue);
          },
        );
      case 2:
        return Step2(
          studentSearchController: pvd.studentSearchController,
          assignedStudents: pvd.assignedStudents,
          mentorSearchController: pvd.mentorSearchController,
          assignedMentor: pvd.assignedMentor,
          projectCounsellor: pvd.projectCounsellor,
        );
      case 3:
        return const Step3();
      case 4:
        return Step4();
      case 5:
        return Step5();
      case 6:
        return Step6();
      case 7:
        return const Step7();
      case 8:
        return const Step8();
      default:
        return const Center(child: Text('Coming soon...'));
    }
  }
}

// Models
class Milestone {
  String name;
  DateTime? dueDate;
  String weight;
  List<Task> tasks;

  Milestone({
    required this.name,
    required this.dueDate,
    required this.weight,
    required this.tasks,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dueDate': dueDate?.toIso8601String(),
      'weight': weight,
      'tasks': tasks.map((task) => task.toJson()).toList(),
    };
  }
}

class Task {
  String title;
  String? type;
  DateTime? dueDate;
  String? priority;

  Task({
    required this.title,
    required this.type,
    required this.dueDate,
    required this.priority,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'type': type,
      'dueDate': dueDate?.toIso8601String(),
      'priority': priority,
    };
  }
}

// Custom Painter for Dashed Border
class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double borderRadius;

  DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashSpace,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(borderRadius),
        ),
      );

    final dashPath = _createDashedPath(path, dashWidth, dashSpace);
    canvas.drawPath(dashPath, paint);
  }

  Path _createDashedPath(Path source, double dashWidth, double dashSpace) {
    final Path dest = Path();
    for (final ui.PathMetric metric in source.computeMetrics()) {
      double distance = 0.0;
      bool draw = true;
      while (distance < metric.length) {
        final double length = draw ? dashWidth : dashSpace;
        if (distance + length > metric.length) {
          if (draw) {
            dest.addPath(
              metric.extractPath(distance, metric.length),
              Offset.zero,
            );
          }
          break;
        } else {
          if (draw) {
            dest.addPath(
              metric.extractPath(distance, distance + length),
              Offset.zero,
            );
          }
        }
        distance += length;
        draw = !draw;
      }
    }
    return dest;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
