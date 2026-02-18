import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:teen_theory/Models/CommonModels/notes_model.dart';
import 'package:teen_theory/Resources/fonts.dart';
import 'package:teen_theory/Screens/StudentDashboard/Notes/detail_notes.dart';
import 'package:teen_theory/Services/dio_client.dart';
import 'package:teen_theory/Utils/helper.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  NotesModel? notesModel;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  Future<void> fetchNotes() async {
    setState(() {
      isLoading = true;
    });

    try {
      await DioClient.getMyNotesApi(
        onSuccess: (response) {
          setState(() {
            notesModel = NotesModel.fromJson(response);
            isLoading = false;
          });
        },
        onError: (error) {
          showToast('Failed to load notes: $error', type: toastType.error);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'My Notes',
          style: TextStyle(
            color: Colors.black,
            fontFamily: AppFonts.interBold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.black),
            onPressed: fetchNotes,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: fetchNotes,
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF667EEA),
                ),
              )
            : notesModel?.data == null || notesModel!.data!.isEmpty
                ? _buildEmptyState()
                : _buildNotesList(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.note_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'No notes yet',
            style: TextStyle(
              fontSize: 18,
              fontFamily: AppFonts.interBold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Start creating notes from meetings',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesList() {
    final notes = notesModel!.data!;

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return _buildNoteCard(note);
      },
    );
  }

  Widget _buildNoteCard(Datum note) {
    return InkWell(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailNotes(note: note),
          ),
        );
        
        // Refresh if note was updated or deleted
        if (result == true) {
          fetchNotes();
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
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
            // Header with project name
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.work_outline, size: 14, color: Colors.white),
                      SizedBox(width: 4),
                      Text(
                        note.projectName ?? 'No Project',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontFamily: AppFonts.interMedium,
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[400]),
              ],
            ),
            SizedBox(height: 12),
            
            // Notes content preview
            Text(
              note.notes ?? '',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
                height: 1.5,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            
            SizedBox(height: 12),
            
            // Footer with date
            Row(
              children: [
                Icon(Icons.calendar_today, size: 14, color: Colors.grey[500]),
                SizedBox(width: 6),
                Text(
                  note.createdDate != null
                      ? DateFormat('dd MMM yyyy, hh:mm a').format(note.createdDate!)
                      : 'No date',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}