import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:teen_theory/Models/CommonModels/notes_model.dart';
import 'package:teen_theory/Resources/fonts.dart';
import 'package:teen_theory/Services/dio_client.dart';
import 'package:teen_theory/Utils/helper.dart';

class DetailNotes extends StatefulWidget {
  final Datum note;

  const DetailNotes({super.key, required this.note});

  @override
  State<DetailNotes> createState() => _DetailNotesState();
}

class _DetailNotesState extends State<DetailNotes> {
  late TextEditingController notesController;
  bool isEditing = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    notesController = TextEditingController(text: widget.note.notes ?? '');
  }

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }

  Future<void> _updateNote() async {
    if (notesController.text.trim().isEmpty) {
      showToast('Please enter some notes', type: toastType.error);
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final body = {
        "notes": notesController.text.trim(),
      };

      await DioClient.updateNotesApi(
        noteId: widget.note.id!,
        body: body,
        onSuccess: (response) {
          showToast('Note updated successfully', type: toastType.success);
          setState(() {
            widget.note.notes = notesController.text.trim();
            isEditing = false;
            isLoading = false;
          });
        },
        onError: (error) {
          showToast('Failed to update note: $error', type: toastType.error);
          setState(() {
            isLoading = false;
          });
        },
      );
    } catch (e) {
      showToast('Error: ${e.toString()}', type: toastType.error);
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _deleteNote() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red, size: 24),
            SizedBox(width: 8),
            Text('Delete Note'),
          ],
        ),
        content: Text('Are you sure you want to delete this note? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        isLoading = true;
      });

      try {
        await DioClient.deleteNotesApi(
          noteId: widget.note.id!,
          onSuccess: (response) {
            showToast('Note deleted successfully', type: toastType.success);
            Navigator.pop(context, true); // Return true to indicate refresh needed
          },
          onError: (error) {
            showToast('Failed to delete note: $error', type: toastType.error);
            setState(() {
              isLoading = false;
            });
          },
        );
      } catch (e) {
        showToast('Error: ${e.toString()}', type: toastType.error);
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (isEditing) {
              setState(() {
                isEditing = false;
                notesController.text = widget.note.notes ?? '';
              });
            } else {
              Navigator.pop(context, true);
            }
          },
        ),
        title: Text(
          'Note Details',
          style: TextStyle(
            color: Colors.black,
            fontFamily: AppFonts.interBold,
            fontSize: 18,
          ),
        ),
        actions: [
          if (!isEditing)
            IconButton(
              icon: Icon(Icons.edit, color: Color(0xFF667EEA)),
              onPressed: () {
                setState(() {
                  isEditing = true;
                });
              },
            ),
          if (!isEditing)
            IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.red),
              onPressed: isLoading ? null : _deleteNote,
            ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Color(0xFF667EEA),
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Project Name Card
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF667EEA).withOpacity(0.3),
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
                            Icon(Icons.work, color: Colors.white, size: 24),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Project Name',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                  fontFamily: AppFonts.interMedium,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          widget.note.projectName ?? 'No Project',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: AppFonts.interBold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Date Card
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Color(0xFF667EEA).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.calendar_today,
                            color: Color(0xFF667EEA),
                            size: 20,
                          ),
                        ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Created Date',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              widget.note.createdDate != null
                                  ? DateFormat('dd MMMM yyyy, hh:mm a').format(widget.note.createdDate!)
                                  : 'No date',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: AppFonts.interMedium,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Notes Content Card
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.notes, color: Color(0xFF667EEA), size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Notes',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: AppFonts.interBold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        
                        if (isEditing)
                          TextField(
                            controller: notesController,
                            maxLines: 15,
                            decoration: InputDecoration(
                              hintText: 'Write your notes here...',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Color(0xFF667EEA), width: 2),
                              ),
                            ),
                          )
                        else
                          Text(
                            widget.note.notes ?? 'No notes available',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[800],
                              height: 1.6,
                            ),
                          ),
                      ],
                    ),
                  ),
                  
                  if (isEditing) ...[
                    SizedBox(height: 20),
                    
                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                isEditing = false;
                                notesController.text = widget.note.notes ?? '';
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 14),
                              side: BorderSide(color: Colors.grey.shade300),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: AppFonts.interMedium,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _updateNote,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 14),
                              backgroundColor: Color(0xFF667EEA),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.save, size: 20, color: Colors.white),
                                SizedBox(width: 8),
                                Text(
                                  'Save Changes',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: AppFonts.interMedium,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
        );
      }
    }
