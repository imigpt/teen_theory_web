import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teen_theory/Models/CommonModels/profile_model.dart';
import 'package:teen_theory/Providers/StudentProviders/detail_project_provider.dart';
import 'package:teen_theory/Resources/colors.dart';
import 'package:teen_theory/Customs/custom_button.dart';


class CreateTicketScreen extends StatefulWidget {
  AssignedProject projectDetails;
  CreateTicketScreen({super.key, required this.projectDetails});

  @override
  State<CreateTicketScreen> createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends State<CreateTicketScreen> {
  final _formKey = GlobalKey<FormState>();


  @override
  void dispose() {
  context.read<DetailProjectProvider>().disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Create Ticket', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Consumer<DetailProjectProvider>(
        builder: (context, pvd, child) {
        return SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: pvd.titleCtrl,
                  decoration: InputDecoration(labelText: 'Task Title', border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter task title' : null,
                ),
                // SizedBox(height: 12),

                // TextFormField(
                //   controller: pvd.projectCtrl,
                //   decoration: InputDecoration(labelText: 'Project Name', border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))),
                //   validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter project name' : null,
                // ),
                SizedBox(height: 20),
                SizedBox(width: 12),
                DropdownButtonFormField<String>(
                  value: pvd.priorityCtrl.text.isEmpty ? null : pvd.priorityCtrl.text,
                  items: ['Low', 'Medium', 'High'].map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                  decoration: InputDecoration(labelText: 'Priority', border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))),
                  onChanged: (v) => setState(() => pvd.priorityCtrl.text = v ?? ''),
                  validator: (v) => (v == null || v.isEmpty) ? 'Select priority' : null,
                ),

                SizedBox(height: 12),
                TextFormField(
                  controller: pvd.descriptionCtrl,
                  decoration: InputDecoration(labelText: 'Explain your problem', border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))),
                  maxLines: 5,
                ),

                SizedBox(height: 16),
                Text('Attachments', style: TextStyle(fontWeight: FontWeight.w600)),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (int i = 0; i < pvd.attachments.length; i++)
                      Stack(
                        children: [
                          Container(
                            width: 86,
                            height: 86,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.grey.shade100),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(File(pvd.attachments[i].path), fit: BoxFit.cover),
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () => pvd.removeAttachment(i),
                              child: Container(
                                decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), shape: BoxShape.circle),
                                child: Icon(Icons.close, size: 16, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    GestureDetector(
                      onTap: () {
                        pvd.pickAttachment(context);
                      },
                      child: Container(
                        width: 86,
                        height: 86,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade300)),
                        child: Center(child: Icon(Icons.attach_file, color: Colors.grey)),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(child: CustomButton(title: 'Cancel', onTap: () {

                    })),
                    SizedBox(width: 12),
                    Expanded(
                      child: CustomButton(
                        isEnabled: true,
                        isLoading: pvd.createTicketLoading,
                        title: 'Create',
                        bgColor: Colors.grey.shade200,
                        titleColor: AppColors.white,
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            pvd.createTicketApiTap(context, widget.projectDetails.title, widget.projectDetails.assignedMentor!.name);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ); 
      })
    );
  }
}