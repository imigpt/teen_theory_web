import 'package:flutter/material.dart';

class Steps1 extends StatefulWidget {
  final TextEditingController projectTitleController;
  final String selectedTemplate;
  final TextEditingController descriptionController;
  final Function(String) onTemplateChanged;
  Steps1({
    super.key,
    required this.projectTitleController,
    required this.selectedTemplate,
    required this.descriptionController,
    required this.onTemplateChanged,
  });

  @override
  State<Steps1> createState() => _Steps1State();
}

class _Steps1State extends State<Steps1> {
  String? _selectedProjectType;

  @override
  void initState() {
    super.initState();
    // Map the selectedTemplate to internal value
    _selectedProjectType = _mapProjectTypeToValue(widget.selectedTemplate);
  }

  @override
  void didUpdateWidget(Steps1 oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update local state when widget updates
    if (oldWidget.selectedTemplate != widget.selectedTemplate) {
      _selectedProjectType = _mapProjectTypeToValue(widget.selectedTemplate);
    }
  }

  String _mapProjectTypeToValue(String projectType) {
    switch (projectType.toLowerCase()) {
      case 'sda project':
        return 'sda';
      case 'custom project':
        return 'custom';
      case 'college application':
        return 'college';
      default:
        // If already in short form, return as is
        if (['sda', 'custom', 'college'].contains(projectType.toLowerCase())) {
          return projectType.toLowerCase();
        }
        return 'sda'; // default
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Project Basics',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Set up the foundation of your project',
          style: TextStyle(fontSize: 14, color: Color(0xFF757575), height: 1.4),
        ),
        const SizedBox(height: 32),

        // Project Title
        const Text(
          'Project Title',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: widget.projectTitleController,
          decoration: InputDecoration(
            hintText: 'eg. AI & Machine Learning- Module 4',
            hintStyle: const TextStyle(color: Color(0xFFBDBDBD), fontSize: 16),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.black, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
          ),
        ),
        const SizedBox(height: 32),

        // Project Type
        const Text(
          'Project Type',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),

        _buildProjectTypeOption(
          'SDA Project',
          'Structured academic project',
          'sda',
        ),
        const SizedBox(height: 12),

        _buildProjectTypeOption(
          'Custom Project',
          'Personalized Project Setup',
          'custom',
        ),
        const SizedBox(height: 12),

        _buildProjectTypeOption(
          'College Application',
          'University Admission project',
          'college',
        ),
        const SizedBox(height: 32),
        // Description
        const Text(
          'Description',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: widget.descriptionController,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: 'Brief overview for student & mentor',
            hintStyle: const TextStyle(color: Color(0xFFBDBDBD), fontSize: 16),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.black, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProjectTypeOption(String title, String subtitle, String value) {
    final isSelected = _selectedProjectType == value;
    return InkWell(
      onTap: () {
        widget.onTemplateChanged(value);
        setState(() {
          _selectedProjectType = value;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.black : const Color(0xFFE0E0E0),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.black : const Color(0xFFBDBDBD),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF757575),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
