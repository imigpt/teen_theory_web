import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teen_theory/Providers/CounsellorProvider/counsellor_provider.dart';
import 'package:teen_theory/Resources/colors.dart';
import 'package:teen_theory/Utils/helper.dart';

class ApprovedTasksPage extends StatefulWidget {
  const ApprovedTasksPage({Key? key}) : super(key: key);

  @override
  State<ApprovedTasksPage> createState() => _ApprovedTasksPageState();
}

class _ApprovedTasksPageState extends State<ApprovedTasksPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CounsellorProvider>().getAllMyProjectsApiTap(context);
    });
  }
  // Filter state
  String? _selectedProject;
  String? _selectedStatus;
  String _searchQuery = '';

  // Sample filter options
  final List<String> _statuses = ['All', 'Pending', 'Approved', 'Rejected'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF56CCF2), Color(0xFF2F80ED)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Approved Milestones',
          style: textStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
      body: Consumer<CounsellorProvider>(
        builder: (context, pvd, child) {
          if (pvd.myProjectsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final allProjects = pvd.allMyProjectData?.data ?? [];
          
          // Get count of milestones by status
          int totalMilestones = 0;
          int approvedCount = 0;
          int pendingCount = 0;
          int rejectedCount = 0;

          for (final project in allProjects) {
            if (project.milestones != null) {
              final milestones = project.milestones ?? [];
              totalMilestones += milestones.length;
              for (final milestone in milestones) {
                final status = milestone.status?.toLowerCase() ?? '';
                if (status == 'approved') approvedCount++;
                else if (status == 'rejected') rejectedCount++;
                else pendingCount++;
              }
            }
          }

          // Filter projects that have milestones
          var filteredProjects = allProjects.where((project) {
            if (project.milestones == null || (project.milestones as List).isEmpty) {
              return false;
            }
            
            if (_selectedProject != null && _selectedProject != 'All') {
              if (project.title != _selectedProject) return false;
            }
            
            if (_searchQuery.isNotEmpty) {
              final query = _searchQuery.toLowerCase();
              final title = project.title?.toLowerCase() ?? '';
              final desc = project.projectDescription?.toLowerCase() ?? '';
              if (!title.contains(query) && !desc.contains(query)) {
                return false;
              }
            }
            
            return true;
          }).toList();

          // Get project filter options
          final projectNames = ['All', ...allProjects.where((p) => p.milestones != null && (p.milestones as List).isNotEmpty).map((p) => p.title ?? 'Untitled').toSet()];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status cards
                SizedBox(
                  height: 110,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _statusCard('$pendingCount', 'Pending'),
                      _statusCard('$approvedCount', 'Approved'),
                      _statusCard('$rejectedCount', 'Rejected'),
                    ],
                  ),
                ),

                hSpace(height: 12),

                // Search field
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    onChanged: (value) => setState(() => _searchQuery = value),
                    decoration: InputDecoration(
                      filled: false,
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      hintText: 'Search by project title',
                      hintStyle: textStyle(color: Colors.grey.shade500),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 12,
                      ),
                    ),
                  ),
                ),

                hSpace(height: 12),

                // Filters row
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _filterDropdown('Project', _selectedProject, projectNames, (v) => setState(() => _selectedProject = v)),
                      wSpace(width: 8),
                      _filterDropdown('Status', _selectedStatus, _statuses, (v) => setState(() => _selectedStatus = v)),
                    ],
                  ),
                ),

                hSpace(height: 12),

                // Projects with milestones
                Expanded(
                  child: filteredProjects.isEmpty
                      ? Center(
                          child: Text(
                            'No projects with milestones found',
                            style: textStyle(color: Colors.grey),
                          ),
                        )
                      : ListView.separated(
                          itemCount: filteredProjects.length,
                          separatorBuilder: (_, __) => hSpace(height: 12),
                          itemBuilder: (context, index) {
                            final project = filteredProjects[index];
                            return _projectCard(context, project, pvd);
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _statusCard(String count, String label) {
    // Get gradient based on label
    List<Color> gradient;
    String emoji;
    if (label == 'Pending') {
      gradient = [Color(0xFFFFA751), Color(0xFFFFE259)];
      emoji = '⏳';
    } else if (label == 'Approved') {
      gradient = [Color(0xFF56CCF2), Color(0xFF2F80ED)];
      emoji = '✅';
    } else {
      gradient = [Color(0xFFFF6B6B), Color(0xFFFF8E53)];
      emoji = '❌';
    }
    
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withValues(alpha: 0.4),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: TextStyle(fontSize: 20)),
            const SizedBox(height: 4),
            Text(
              count,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterDropdown(String label, String? selectedValue, List<String> items, Function(String?) onChanged) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.lightGrey, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedValue,
          hint: Text(label, style: textStyle(fontSize: 13)),
          icon: const Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.black54),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: textStyle(fontSize: 13)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _projectCard(BuildContext context, dynamic project, CounsellorProvider pvd) {
    final milestones = (project.milestones ?? [])
        .where((m) {
          if (_selectedStatus == null || _selectedStatus == 'All') return true;
          final status = m.status?.toLowerCase() ?? '';
          return status == _selectedStatus?.toLowerCase();
        })
        .toList();

    if (milestones.isEmpty) return SizedBox.shrink();

    return Container(
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project Header
            Text(
              project.title ?? 'Untitled Project',
              style: textStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            hSpace(height: 4),
            Text(
              project.projectDescription ?? '',
              style: textStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            hSpace(height: 12),
            Divider(),
            hSpace(height: 8),
            
            // Milestones
            Text(
              'Milestones (${milestones.length})',
              style: textStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            hSpace(height: 12),
            
            ...milestones.map((milestone) => _milestoneCard(context, project, milestone, pvd)),
          ],
        ),
      ),
    );
  }

  Widget _milestoneCard(BuildContext context, dynamic project, dynamic milestone, CounsellorProvider pvd) {
    final status = milestone.status?.toLowerCase() ?? 'pending';
    final statusColor = status == 'approved'
        ? Colors.green
        : status == 'rejected'
            ? Colors.red
            : Colors.orange;

    final dueDate = milestone.dueDate != null
        ? DateTime.tryParse(milestone.dueDate.toString())
        : null;

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: Offset(0, 2),
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
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: status == 'approved'
                        ? [Color(0xFF56CCF2), Color(0xFF2F80ED)]
                        : status == 'rejected'
                            ? [Color(0xFFFF6B6B), Color(0xFFFF8E53)]
                            : [Color(0xFFFFA751), Color(0xFFFFE259)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: statusColor.withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  status.toUpperCase(),
                  style: textStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          if (dueDate != null) ...[
            hSpace(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade600),
                wSpace(width: 6),
                Text(
                  'Due: ${dueDate.day}/${dueDate.month}/${dueDate.year}',
                  style: textStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ],
          if (milestone.weight != null) ...[
            hSpace(height: 4),
            Row(
              children: [
                Icon(Icons.fitness_center, size: 14, color: Colors.grey.shade600),
                wSpace(width: 6),
                Text(
                  'Weight: ${milestone.weight}',
                  style: textStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ],
          
          // Tasks
          if (milestone.tasks != null && milestone.tasks!.isNotEmpty) ...[
            hSpace(height: 12),
            Text(
              'Tasks (${milestone.tasks!.length}):',
              style: textStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            hSpace(height: 6),
            ...milestone.tasks!.map((task) {
              final taskStatus = task.status?.toLowerCase() ?? 'pending';
              return Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  children: [
                    Icon(
                      taskStatus == 'completed'
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      size: 16,
                      color: taskStatus == 'completed' ? Colors.green : Colors.grey,
                    ),
                    wSpace(width: 8),
                    Expanded(
                      child: Text(
                        task.title ?? 'Untitled Task',
                        style: textStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],

          // Action buttons for pending milestones
          if (status == 'completed') ...[
            hSpace(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: pvd.isApprovingMilestone(milestone.id ?? '')
                      ? null
                      : () {
                          pvd.approveOrRejectMilestone(
                            context: context,
                            projectId: project.id!,
                            milestoneId: milestone.id ?? '',
                            status: 'rejected',
                          );
                        },
                  child: Text(
                    'Reject',
                    style: textStyle(color: Colors.red),
                  ),
                ),
                wSpace(width: 8),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF56CCF2), Color(0xFF2F80ED)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF56CCF2).withValues(alpha: 0.4),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: pvd.isApprovingMilestone(milestone.id ?? '')
                        ? null
                        : () {
                            pvd.approveOrRejectMilestone(
                              context: context,
                              projectId: project.id!,
                              milestoneId: milestone.id ?? '',
                              status: 'approved',
                            );
                          },
                    child: Text(
                      'Approve',
                      style: textStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
