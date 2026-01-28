import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:teen_theory/Providers/CounsellorProvider/counsellor_provider.dart';
import 'package:teen_theory/Screens/CounsellorDashboard/CreateProject/create_project_main.dart';

class Step3 extends StatefulWidget {
  const Step3({super.key});

  @override
  State<Step3> createState() => _Step3State();
}

class _Step3State extends State<Step3> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CounsellorProvider>(
      builder: (context, pvd, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Milestones & Tasks',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Define project structure with customizable milestones and tasks',
              style: TextStyle(fontSize: 14, color: Color(0xFF757575), height: 1.4),
            ),
            const SizedBox(height: 32),

            ...List.generate(pvd.milestones.length, (index) {
              return _buildMilestone(index, pvd);
            }),

            const SizedBox(height: 16),

            Builder(
              builder: (context) {
                // Get total weightage from provider
                final totalWeightage = pvd.totalWeightage;

                final bool canAddMilestone = totalWeightage < 100;

                return Column(
                  children: [
                    // Display total weightage
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: totalWeightage == 100 
                            ? Colors.green.shade50 
                            : totalWeightage > 100 
                                ? Colors.red.shade50 
                                : Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: totalWeightage == 100 
                              ? Colors.green.shade300 
                              : totalWeightage > 100 
                                  ? Colors.red.shade300 
                                  : Colors.blue.shade300,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Weightage',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: totalWeightage == 100 
                                  ? Colors.green.shade800 
                                  : totalWeightage > 100 
                                      ? Colors.red.shade800 
                                      : Colors.blue.shade800,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                '$totalWeightage / 100',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: totalWeightage == 100 
                                      ? Colors.green.shade800 
                                      : totalWeightage > 100 
                                          ? Colors.red.shade800 
                                          : Colors.blue.shade800,
                                ),
                              ),
                              if (totalWeightage == 100) ...[
                                const SizedBox(width: 8),
                                Icon(Icons.check_circle, 
                                  color: Colors.green.shade700, 
                                  size: 20,
                                ),
                              ] else if (totalWeightage > 100) ...[
                                const SizedBox(width: 8),
                                Icon(Icons.error, 
                                  color: Colors.red.shade700, 
                                  size: 20,
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Add Milestone Button
                    InkWell(
                      onTap: canAddMilestone ? () {
                        pvd.addMilestone();
                      } : null,
                      child: Opacity(
                        opacity: canAddMilestone ? 1.0 : 0.5,
                        child: CustomPaint(
                          painter: DashedBorderPainter(
                            color: canAddMilestone ? const Color(0xFFBDBDBD) : Colors.grey.shade400,
                            strokeWidth: 1.5,
                            dashWidth: 5,
                            dashSpace: 5,
                            borderRadius: 8,
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: canAddMilestone ? Colors.white : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add, 
                                  size: 20, 
                                  color: canAddMilestone ? Colors.black : Colors.grey.shade500,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  canAddMilestone 
                                      ? 'Add Milestone' 
                                      : 'Cannot Add (100% Weightage Reached)',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: canAddMilestone ? Colors.black : Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
        const SizedBox(height: 32),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFD6D6D6),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Auto Progress Tracking',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'As Tasks are completed- Milestone % updates\nAs Milestone update- Project progress % updates\n(doughnut chart)',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        // const SizedBox(height: 16),

        // Container(
        //   padding: const EdgeInsets.all(16),
        //   decoration: BoxDecoration(
        //     color: const Color(0xFFD6D6D6),
        //     borderRadius: BorderRadius.circular(8),
        //   ),
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       const Text(
        //         'Task Dependencies',
        //         style: TextStyle(
        //           fontSize: 16,
        //           fontWeight: FontWeight.w700,
        //           color: Colors.black,
        //         ),
        //       ),
        //       const SizedBox(height: 8),
        //       Text(
        //         'Set up dependencies so task b can only start after Task A is completed',
        //         style: TextStyle(
        //           fontSize: 12,
        //           color: Colors.grey.shade700,
        //           height: 1.5,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
          ],
        );
      },
    );
  }

  Widget _buildMilestone(int milestoneIndex, CounsellorProvider pvd) {
    final milestone = pvd.milestones[milestoneIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Milestone ${milestoneIndex + 1}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
              onPressed: () {
                pvd.removeMilestone(milestoneIndex);
              },
            ),
          ],
        ),
        const SizedBox(height: 12),

        const Text(
          'Milestone Name*',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF757575),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: TextEditingController(text: milestone.name),
          decoration: InputDecoration(
            hintText: 'eg., Research Phase, Essay Draft',
            hintStyle: const TextStyle(color: Color(0xFFBDBDBD), fontSize: 14),
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
          onChanged: (value) {
            milestone.name = value;
          },
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Due Date*',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF757575),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    readOnly: true,
                    controller: TextEditingController(
                      text: milestone.dueDate != null
                          ? DateFormat('MM/dd/yyyy').format(milestone.dueDate!)
                          : '',
                    ),
                    decoration: InputDecoration(
                      hintText: 'mm/dd/yyyy',
                      hintStyle: const TextStyle(
                        color: Color(0xFFBDBDBD),
                        fontSize: 14,
                      ),
                      suffixIcon: const Icon(
                        Icons.calendar_today,
                        size: 18,
                        color: Color(0xFF757575),
                      ),
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
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2030),
                      );
                      if (date != null) {
                        setState(() {
                          milestone.dueDate = date;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Weight (%)',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF757575),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: TextEditingController(text: milestone.weight),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: '30',
                      hintStyle: const TextStyle(
                        color: Color(0xFFBDBDBD),
                        fontSize: 14,
                      ),
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
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onChanged: (value) {
                      milestone.weight = value;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
