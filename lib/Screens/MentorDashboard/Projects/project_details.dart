import 'package:flutter/material.dart';
import 'package:teen_theory/Common/ChatScreens/chat_list.dart';
import 'package:teen_theory/Models/MentorModels/mentor_project_model.dart';
import 'package:teen_theory/Resources/fonts.dart';
import 'package:teen_theory/Utils/helper.dart';

class ProjectDetails extends StatelessWidget {
  final Datum? projectData;
  const ProjectDetails({super.key, this.projectData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text('Project Details'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6DD5FA), Color(0xFF2980B9)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        foregroundColor: Colors.white,
      ),
      body: projectData == null
          ? Center(child: Text('No project data available'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Project Title
                  Text(
                    projectData!.title ?? 'No Title',
                    style: textStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  hSpace(height: 16),

                  // Status Badge
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _getStatusGradient(projectData!.status),
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: _getStatusColor(projectData!.status).withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      projectData!.status ?? 'Unknown',
                      style: textStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  hSpace(height: 24),

                  // Description Section
                  Text(
                    'Description',
                    style: textStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  hSpace(height: 8),
                  Text(
                    projectData!.projectDescription ?? 'No description available',
                    style: textStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  hSpace(height: 24),

                  // Project Info Cards
                  if (projectData!.assignedStudent != null && projectData!.assignedStudent!.isNotEmpty)
                    _buildInfoCard(
                      'Student Name',
                      projectData!.assignedStudent!.first.name ?? 'N/A',
                      Icons.person,
                    ),
                  if (projectData!.assignedStudent != null && projectData!.assignedStudent!.isNotEmpty)
                    hSpace(height: 12),
                  if (projectData!.assignedStudent != null && projectData!.assignedStudent!.isNotEmpty)
                    _buildInfoCard(
                      'Grade',
                      projectData!.assignedStudent!.first.grade ?? 'N/A',
                      Icons.school,
                    ),
                  if (projectData!.assignedStudent != null && projectData!.assignedStudent!.isNotEmpty)
                    hSpace(height: 12),
                  if (projectData!.assignedMentor != null)
                    _buildInfoCard(
                      'Mentor Name',
                      projectData!.assignedMentor!.name ?? 'N/A',
                      Icons.supervisor_account,
                    ),
                  if (projectData!.assignedMentor != null)
                    hSpace(height: 12),
                  if (projectData!.assignedMentor != null)
                    _buildInfoCard(
                      'Mentor Email',
                      projectData!.assignedMentor!.email ?? 'N/A',
                      Icons.email,
                    ),
                  hSpace(height: 12),
                  if (projectData!.createdByEmail != null)
                    _buildInfoCard(
                      'Created By',
                      projectData!.createdByEmail ?? 'N/A',
                      Icons.person_outline,
                    ),
                  if (projectData!.createdByEmail != null)
                    hSpace(height: 12),
                  if (projectData!.projectCounsellor != null)
                    _buildInfoCard(
                      'Project Counsellor',
                      projectData!.projectCounsellor ?? 'N/A',
                      Icons.support_agent,
                    ),

                    if(projectData?.deliverablesType != null && projectData!.deliverablesType!.isNotEmpty)

                    Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Color(0xFFF8F9FC)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFA751), Color(0xFFFFE259)],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFFFA751).withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text('📋', style: TextStyle(fontSize: 22)),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Deliverables Types",
                  style: textStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for(int i = 0; i < projectData!.deliverablesType!.length; i++)
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFFFA751), Color(0xFFFFE259)],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                          child: Text(
                            projectData!.deliverablesType![i],
                            style: textStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
                  if (projectData!.projectCounsellor != null)
                    hSpace(height: 12),
                  if (projectData!.createdAt != null)
                    _buildInfoCard(
                      'Created At',
                      _formatDate(projectData!.createdAt!),
                      Icons.calendar_today,
                    ),
                  if (projectData!.createdAt != null)
                    hSpace(height: 12),
                  if (projectData!.dueDate != null)
                    _buildInfoCard(
                      'Due Date',
                      _formatDate(projectData!.dueDate!),
                      Icons.event,
                    ),
                  
                  // Milestones Section
                  if (projectData!.milestones != null && projectData!.milestones!.isNotEmpty) ...[
                    hSpace(height: 24),
                    Text(
                      'Milestones',
                      style: textStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    hSpace(height: 12),
                    ...projectData!.milestones!.map((milestone) => _buildMilestoneCard(milestone)),
                  ],
                  GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ChatListScreen(projectId: projectData!.id!)),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF667EEA).withValues(alpha: 0.4),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text('💬', style: TextStyle(fontSize: 24)),
                                ),
                              ),
                              SizedBox(width: 14),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Messages",
                                    style: textStyle(
                                      fontFamily: AppFonts.interBold,
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "Chat with mentors & counsellors",
                                    style: textStyle(
                                      fontSize: 12,
                                      color: Colors.white.withValues(alpha: 0.9),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                ],
              ),
            ),
    );
  }

  Widget _buildMilestoneCard(Milestone milestone) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Color(0xFFF8F9FC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  milestone.name ?? 'Unnamed Milestone',
                  style: textStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _getMilestoneStatusGradient(milestone.status),
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: _getMilestoneStatusColor(milestone.status).withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  milestone.status ?? 'N/A',
                  style: textStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          hSpace(height: 8),
          if (milestone.dueDate != null)
            Row(
              children: [
                Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade600),
                SizedBox(width: 6),
                Text(
                  'Due: ${_formatDate(milestone.dueDate!)}',
                  style: textStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          if (milestone.weight != null) ...[
            hSpace(height: 4),
            Row(
              children: [
                Icon(Icons.fitness_center, size: 14, color: Colors.grey.shade600),
                SizedBox(width: 6),
                Text(
                  'Weight: ${milestone.weight}',
                  style: textStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
          if (milestone.tasks != null && milestone.tasks!.isNotEmpty) ...[
            hSpace(height: 12),
            Text(
              'Tasks (${milestone.tasks!.length}):',
              style: textStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            hSpace(height: 8),
            ...milestone.tasks!.map((task) => Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    task.status?.toLowerCase() == 'completed' 
                        ? Icons.check_circle 
                        : Icons.radio_button_unchecked,
                    size: 16,
                    color: task.status?.toLowerCase() == 'completed' 
                        ? Colors.green 
                        : Colors.grey,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      task.title ?? 'Untitled Task',
                      style: textStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ],
      ),
    );
  }

  Color _getMilestoneStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'in_progress':
      case 'in progress':
        return Colors.orange;
      case 'pending':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  List<Color> _getMilestoneStatusGradient(String? status) {
    switch (status?.toLowerCase()) {
      case 'completed':
        return [Color(0xFF56CCF2), Color(0xFF2F80ED)];
      case 'in_progress':
      case 'in progress':
        return [Color(0xFFFFA751), Color(0xFFFFE259)];
      case 'pending':
        return [Color(0xFF6DD5FA), Color(0xFF2980B9)];
      default:
        return [Color(0xFFD3D3D3), Color(0xFFA9A9A9)];
    }
  }

  Widget _buildInfoCard(String label, String value, IconData icon) {
    // Get gradient based on icon type
    List<Color> iconGradient;
    String emoji;
    
    if (icon == Icons.person || icon == Icons.supervisor_account) {
      iconGradient = [Color(0xFF667EEA), Color(0xFF764BA2)];
      emoji = label.contains('Student') ? '👨‍🎓' : '👨‍🏫';
    } else if (icon == Icons.school) {
      iconGradient = [Color(0xFFFFA751), Color(0xFFFFE259)];
      emoji = '🎓';
    } else if (icon == Icons.email) {
      iconGradient = [Color(0xFFFF758C), Color(0xFFFF7EB3)];
      emoji = '📧';
    } else if (icon == Icons.calendar_today || icon == Icons.event) {
      iconGradient = [Color(0xFF6DD5FA), Color(0xFF2980B9)];
      emoji = '📅';
    } else {
      iconGradient = [Color(0xFF56CCF2), Color(0xFF2F80ED)];
      emoji = '👤';
    }

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Color(0xFFF8F9FC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: iconGradient,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: iconGradient[0].withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(emoji, style: TextStyle(fontSize: 22)),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: textStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: textStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'in_progress':
      case 'in progress':
        return Colors.orange;
      case 'pending':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  List<Color> _getStatusGradient(String? status) {
    switch (status?.toLowerCase()) {
      case 'completed':
        return [Color(0xFF56CCF2), Color(0xFF2F80ED)];
      case 'in_progress':
      case 'in progress':
        return [Color(0xFFFFA751), Color(0xFFFFE259)];
      case 'pending':
        return [Color(0xFF6DD5FA), Color(0xFF2980B9)];
      default:
        return [Color(0xFFD3D3D3), Color(0xFFA9A9A9)];
    }
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}