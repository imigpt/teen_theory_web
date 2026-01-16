import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:teen_theory/Providers/CounsellorProvider/counsellor_provider.dart';
import 'package:teen_theory/Resources/fonts.dart';
import 'package:teen_theory/Utils/helper.dart';

class Step4 extends StatelessWidget {
  Step4({super.key});

  final List<Map<String, dynamic>> deliverableTypes = [
    {
      'icon': Icons.description_outlined,
      'title': 'Document',
      'subtitle': 'Word / Google Doc',
      'value': 'Document',
    },
    {
      'icon': Icons.slideshow_outlined,
      'title': 'Presentation',
      'subtitle': 'PPT/ Slides',
      'value': 'Presentation',
    },
    {
      'icon': Icons.table_chart_outlined,
      'title': 'Spreadsheet',
      'subtitle': 'Excel / Sheets',
      'value': 'Spreadsheet',
    },
    {
      'icon': Icons.upload_file_outlined,
      'title': 'File Upload',
      'subtitle': 'PDF, Image , ZIP',
      'value': 'File Upload',
    },
    {
      'icon': Icons.link_outlined,
      'title': 'Link',
      'subtitle': 'URL / Drive',
      'value': 'Link',
    },
    {
      'icon': Icons.more_horiz_outlined,
      'title': 'Other',
      'subtitle': 'Custom Format',
      'value': 'Other',
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
              "Milestones & Tasks",
              style: textStyle(fontSize: 20, fontFamily: AppFonts.interBold),
            ),
            Text(
              "Define project structure with customizable milestones and tasks.",
              style: textStyle(
                fontSize: 14,
                fontFamily: AppFonts.interRegular,
                color: Colors.grey,
              ),
            ),
            hSpace(height: 24),

            // Deliverable Title
            Text(
              "Deliverable Title",
              style: textStyle(fontFamily: AppFonts.interBold, fontSize: 16),
            ),
            hSpace(height: 8),
            TextFormField(
              controller: pvd.deliverableTitleController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                hintStyle: textStyle(color: Colors.grey),
                hintText: "Example: Essay Draft v1, Final Proposal",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            hSpace(height: 24),

            // Deliverable Type
            Text(
              "Deliverable Type (Select Multiple)",
              style: textStyle(fontFamily: AppFonts.interBold, fontSize: 16),
            ),
            hSpace(height: 12),
            GridView.builder(
              itemCount: deliverableTypes.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: 70,
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final type = deliverableTypes[index];
                final isSelected = pvd.selectedDeliverableTypes.contains(type['value']);

                return GestureDetector(
                  onTap: () {
                    pvd.toggleDeliverableType(type['value'] as String);
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
                        Stack(
                          children: [
                            Icon(
                              type['icon'] as IconData,
                              size: 24,
                              color: isSelected
                                  ? Colors.black
                                  : Colors.grey.shade700,
                            ),
                            if (isSelected)
                              Positioned(
                                right: -2,
                                top: -2,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    color: Colors.black,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    size: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ],
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

            // Due Date
            Text(
              "Due Date",
              style: textStyle(fontFamily: AppFonts.interBold, fontSize: 16),
            ),
            hSpace(height: 8),
            TextFormField(
              readOnly: true,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: pvd.selectedDueDate ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null) {
                  pvd.setSelectedDueDate = date;
                }
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                hintStyle: textStyle(color: Colors.grey),
                hintText: "mm/dd/yyyy",
                suffixIcon: const Icon(Icons.calendar_today_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              controller: TextEditingController(
                text: pvd.selectedDueDate != null
                    ? DateFormat('MM/dd/yyyy').format(pvd.selectedDueDate!)
                    : '',
              ),
            ),
            hSpace(height: 16),
            Text(
              "Word/Page/Slide Limit",
              style: textStyle(fontSize: 14, color: Colors.grey.shade700),
            ),
            hSpace(height: 8),
            DropdownButtonFormField<String>(
              value: pvd.selectedWordLimit,
              isExpanded: true,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                hintStyle: textStyle(color: Colors.grey),
                hintText: "e.g., 1000-1500 words, 10 slides max",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: [
                DropdownMenuItem(
                  value: "500-1000 words",
                  child: Text(
                    "500-1000 words",
                    overflow: TextOverflow.ellipsis,
                    style: textStyle(fontSize: 14),
                  ),
                ),
                DropdownMenuItem(
                  value: "1000-1500 words",
                  child: Text(
                    "1000-1500 words",
                    overflow: TextOverflow.ellipsis,
                    style: textStyle(fontSize: 14),
                  ),
                ),
                DropdownMenuItem(
                  value: "10 slides max",
                  child: Text(
                    "10 slides max",
                    overflow: TextOverflow.ellipsis,
                    style: textStyle(fontSize: 14),
                  ),
                ),
                DropdownMenuItem(
                  value: "15 slides max",
                  child: Text(
                    "15 slides max",
                    overflow: TextOverflow.ellipsis,
                    style: textStyle(fontSize: 14),
                  ),
                ),
                DropdownMenuItem(
                  value: "No limit",
                  child: Text(
                    "No limit",
                    overflow: TextOverflow.ellipsis,
                    style: textStyle(fontSize: 14),
                  ),
                ),
              ],
              onChanged: (value) {
                pvd.setSelectedWordLimit = value;
              },
            ),
            hSpace(height: 16),
            Text(
              "Additional Instructions",
              style: textStyle(fontSize: 14, color: Colors.grey.shade700),
            ),
            hSpace(height: 8),
            TextFormField(
              controller: pvd.additionalInstructionsController,
              maxLines: 4,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                hintStyle: textStyle(color: Colors.grey),
                hintText: "Any specific requirements or guidelines...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            hSpace(height: 24),

            // Settings & Approval
            Text(
              "Settings & Approval",
              style: textStyle(fontFamily: AppFonts.interBold, fontSize: 16),
            ),
            hSpace(height: 12),
            Text(
              "Version Control",
              style: textStyle(fontSize: 14, fontFamily: AppFonts.interMedium),
            ),
            hSpace(height: 8),
            CheckboxListTile(
              value: pvd.allowMultipleSubmissions,
              onChanged: (value) {
                pvd.setAllowMultipleSubmissions = value ?? true;
              },
              title: Text(
                "Allow multiple submissions (v1, v2, v3)",
                style: textStyle(fontSize: 14),
              ),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              dense: true,
            ),
            hSpace(height: 16),
            InkWell(
              onTap: () {
                print(pvd.requiresMentorApproval);
                print(pvd.requiresCounsellorApproval);
              },
              child: Text(
                "Requires Approval From",
                style: textStyle(fontSize: 14, fontFamily: AppFonts.interMedium),
              ),
            ),
            hSpace(height: 8),
            CheckboxListTile(
              value: pvd.requiresMentorApproval,
              onChanged: (value) {
                pvd.setRequiresMentorApproval = value ?? false;
              },
              title: Text(
                "Mentor (feedback management)",
                style: textStyle(fontSize: 14),
              ),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              dense: true,
            ),
            CheckboxListTile(
              value: pvd.requiresCounsellorApproval,
              onChanged: (value) {
                pvd.setRequiresCounsellorApproval = value ?? false;
              },
              title: Text(
                "Chief Counsellor (final review & approval)",
                style: textStyle(fontSize: 14),
              ),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              dense: true,
            ),
            hSpace(height: 24),


            // Deliverable Summary Preview
            if (pvd.deliverables.isNotEmpty) ...[
              Text(
                "Deliverable Summary Preview",
                style: textStyle(fontFamily: AppFonts.interBold, fontSize: 16),
              ),
              hSpace(height: 12),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              "Deliverable",
                              style: textStyle(
                                fontFamily: AppFonts.interBold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              "Type",
                              style: textStyle(
                                fontFamily: AppFonts.interBold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              "Due Date",
                              style: textStyle(
                                fontFamily: AppFonts.interBold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              "Reviewer",
                              style: textStyle(
                                fontFamily: AppFonts.interBold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Rows
                    ...pvd.deliverables.asMap().entries.map((entry) {
                      final deliverable = entry.value;

                      String reviewer = '';
                      if (deliverable.requiresMentorApproval) {
                        reviewer = 'Mentor';
                      } else if (deliverable.requiresCounsellorApproval) {
                        reviewer = 'Counsellor';
                      }

                      return Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                deliverable.title,
                                style: textStyle(fontSize: 14),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Wrap(
                                spacing: 4,
                                runSpacing: 4,
                                children: deliverable.types.map((type) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      type,
                                      style: textStyle(fontSize: 10),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                DateFormat('MMM d').format(deliverable.dueDate),
                                style: textStyle(fontSize: 14),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: reviewer.isNotEmpty
                                  ? Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade700,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        reviewer,
                                        style: textStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  : const SizedBox(),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
              hSpace(height: 24),
            ],
          ],
        );
      },
    );
  }
}
