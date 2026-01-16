import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teen_theory/Providers/CounsellorProvider/counsellor_provider.dart';
import 'package:teen_theory/Resources/fonts.dart';
import 'package:teen_theory/Screens/CounsellorDashboard/CreateProject/create_project_main.dart';
import 'package:teen_theory/Utils/helper.dart';

class Step5 extends StatelessWidget {
  Step5({super.key});

  final List<Map<String, dynamic>> resourceTypes = [
    {
      'icon': Icons.file_upload_outlined,
      'title': 'File Upload',
      'subtitle': 'PDF, PPT, DOCX',
      'value': 'File Upload',
    },
    {
      'icon': Icons.link_outlined,
      'title': 'Link / URL',
      'subtitle': 'Google Doc, Video',
      'value': 'Link',
    },
    {
      'icon': Icons.description_outlined,
      'title': 'Template',
      'subtitle': 'Essay, Report',
      'value': 'Template',
    },
    {
      'icon': Icons.book_outlined,
      'title': 'Reference',
      'subtitle': 'Guide, Manual',
      'value': 'Reference',
    },
    {
      'icon': Icons.table_chart_outlined,
      'title': 'Spreadsheet',
      'subtitle': 'Excel, Sheets',
      'value': 'Spreadsheet',
    },
    {
      'icon': Icons.build_outlined,
      'title': 'Tool Link',
      'subtitle': 'Canva, GitHub',
      'value': 'Tool Link',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<CounsellorProvider>(
      builder: (context, pvd, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            Text(
              "Project Resources",
              style: textStyle(fontSize: 20, fontFamily: AppFonts.interBold),
            ),
            Text(
              "Provide helpful materials like files, links, templates, and guidelines for students to complete the project successfully.",
              style: textStyle(
                fontSize: 14,
                fontFamily: AppFonts.interRegular,
                color: Colors.grey,
              ),
            ),
            hSpace(height: 24),

            // Resource Type
            Text(
              "Resource Type",
              style: textStyle(fontFamily: AppFonts.interBold, fontSize: 16),
            ),
            hSpace(height: 12),
            GridView.builder(
              itemCount: resourceTypes.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: 70,
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final type = resourceTypes[index];
                final isSelected = pvd.selectedResourceType == type['value'];

                return GestureDetector(
                  onTap: () {
                    pvd.setSelectedResourceType = type['value'] as String;
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected ? Colors.black : Colors.grey.shade300,
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      color: isSelected
                          ? Colors.black.withOpacity(0.05)
                          : Colors.white,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          type['icon'] as IconData,
                          size: 24,
                          color: isSelected
                              ? Colors.black
                              : Colors.grey.shade700,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                type['title'] as String,
                                style: textStyle(
                                  fontFamily: AppFonts.interBold,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                type['subtitle'] as String,
                                style: textStyle(
                                  fontSize: 8,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            hSpace(height: 24),

            // Resource Title
            Text(
              "Resource Title",
              style: textStyle(fontFamily: AppFonts.interBold, fontSize: 16),
            ),
            hSpace(height: 8),
            TextFormField(
              controller: pvd.resourceTitleController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                hintStyle: textStyle(color: Colors.grey),
                hintText: "e.g., Essay Structure Template",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            hSpace(height: 24),

            // Description
            Text(
              "Description",
              style: textStyle(fontFamily: AppFonts.interBold, fontSize: 16),
            ),
            hSpace(height: 8),
            TextFormField(
              controller: pvd.resourceDescriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                hintStyle: textStyle(color: Colors.grey),
                hintText: "Brief description of how this resource helps...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            hSpace(height: 24),

            // Attach Resource
            Text(
              "Attach Resource",
              style: textStyle(fontFamily: AppFonts.interBold, fontSize: 16),
            ),
            hSpace(height: 12),
            CustomPaint(
              painter: DashedBorderPainter(
                color: Colors.grey.shade400,
                strokeWidth: 2,
                dashWidth: 8,
                dashSpace: 4,
                borderRadius: 8,
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(
                      Icons.cloud_upload_outlined,
                      size: 48,
                      color: Colors.grey.shade700,
                    ),
                    hSpace(height: 12),
                    Text(
                      "Upload file or paste URL",
                      style: textStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    hSpace(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        pvd.pickedFileFromDevice();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 24,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        pvd.pickedFiles == null ? "Choose File" : "${pvd.pickedFiles!.files.first.name} files selected",
                        style: textStyle(
                          color: Colors.white,
                          fontFamily: AppFonts.interMedium,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            hSpace(height: 16),

            // Visibility Settings
            Text(
              "Visibility Settings",
              style: textStyle(fontFamily: AppFonts.interBold, fontSize: 16),
            ),
            hSpace(height: 8),
            CheckboxListTile(
              value: pvd.visibleToStudent,
              onChanged: (value) {
                pvd.setVisibleToStudent = value ?? false;
              },
              title: Text("Student", style: textStyle(fontSize: 14)),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              dense: true,
            ),
            CheckboxListTile(
              value: pvd.visibleToMentor,
              onChanged: (value) {
                pvd.setVisibleToMentor = value ?? false;
              },
              title: Text("Mentor", style: textStyle(fontSize: 14)),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              dense: true,
            ),
            CheckboxListTile(
              value: true,
              onChanged: null, // Always checked, disabled
              title: Text(
                "Counsellor (always)",
                style: textStyle(fontSize: 14, color: Colors.grey),
              ),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              dense: true,
            ),
            hSpace(height: 24),
          ],
        );
      },
    );
  }
}
