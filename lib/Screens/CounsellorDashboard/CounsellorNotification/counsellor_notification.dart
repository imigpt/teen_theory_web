import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:teen_theory/Customs/custom_button.dart';
import 'package:teen_theory/Providers/CounsellorProvider/counsellor_provider.dart';
import 'package:teen_theory/Providers/StudentProviders/detail_project_provider.dart';
import 'package:teen_theory/Services/apis.dart';

import '../../../Resources/colors.dart';
import '../../../Utils/helper.dart';

/// Details page showcasing a single notification.
class CounsellorNotificationPage extends StatelessWidget {
  final String fullName;
  final String? profilePhoto;
  final String userRole;
  final String title;
  final String message;
  final String projectName;
  final String createdAt;

  const CounsellorNotificationPage({
    Key? key,
    required this.fullName,
    this.profilePhoto,
    required this.userRole,
    required this.title,
    required this.message,
    required this.projectName,
    required this.createdAt,
  }) : super(key: key);

  String get _formattedDate {
    try {
      return DateFormat('dd MMM yyyy • hh:mm a').format(DateTime.parse(createdAt).toLocal());
    } catch (_) {
      return createdAt;
    }
  }

  Widget get _avatar {
    const placeholder = Icon(Icons.person, size: 48, color: Colors.white);
    if (profilePhoto != null && profilePhoto!.isNotEmpty) {
      return ClipOval(
        child: Image.network(profilePhoto!, width: 72, height: 72, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(
          width: 72,
          height: 72,
          color: Colors.grey.shade400,
          child: placeholder,
        )),
      );
    }
    return CircleAvatar(radius: 36, backgroundColor: Colors.grey.shade400, child: placeholder);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text('Notification', style: textStyle(fontWeight: FontWeight.w600, fontSize: 18)),
      ),
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _avatar,
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(fullName, style: textStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 4),
                        Text(userRole, style: textStyle(color: Colors.grey.shade600)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(title, style: textStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                Text(message, style: textStyle(fontSize: 16, color: Colors.grey.shade800)),
                const SizedBox(height: 24),
                Text('Project Name', style: textStyle(fontWeight: FontWeight.w600, color: Colors.grey.shade600)),
                const SizedBox(height: 4),
                Text(projectName, style: textStyle(fontSize: 14, color: Colors.grey.shade800)),
                hSpace(),
                Text('Created at', style: textStyle(fontWeight: FontWeight.w600, color: Colors.grey.shade600)),
                const SizedBox(height: 4),
                Text(_formattedDate, style: textStyle(fontSize: 14, color: Colors.grey.shade800)),
              ],
            ),
       
            CustomButton(
            title: "Create Meeting Link", 
            onTap: () {
              showDialog(context: context, builder: (context) {
                return AlertDialog(
                  title: Text("Let's Meeting with $fullName", style: textStyle(fontWeight: FontWeight.w600)),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Student Problem", style: TextStyle(fontSize: 23, fontWeight: FontWeight.w600, color: Colors.grey.shade800)),
                      Text(message, style: textStyle(fontSize: 16, color: Colors.grey.shade800)),
                      hSpace(height: 10),
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Meeting Link",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                      ),
                      TextButton(onPressed: (){
                        context.read<DetailProjectProvider>().openMeetNew();
                      }, child: Text("Create Link and paste here", style: textStyle(color: AppColors.lightGrey2))),
                      Row(
                        children: [
                          ElevatedButton(onPressed: (){}, child: Text("Cancel")),
                          const SizedBox(width: 16),
                          ElevatedButton(onPressed: (){}, child: Text("Send Link")),
                        ],
                      )
                    ],
                  ),
                );
              });
            })
          ],
        ),
      ),
    );
  }
}

class CounsellorNotification {
  final String fullName;
  final String? profilePhoto;
  final String userRole;
  final String title;
  final String message;
  final String createdAt;

  CounsellorNotification({
    required this.fullName,
    this.profilePhoto,
    required this.userRole,
    required this.title,
    required this.message,
    required this.createdAt,
  });
}

/// Static notification list with navigation to details.
class CounsellorNotificationListPage extends StatefulWidget {
  const CounsellorNotificationListPage({Key? key}) : super(key: key);

  @override
  State<CounsellorNotificationListPage> createState() => _CounsellorNotificationListPageState();
}

class _CounsellorNotificationListPageState extends State<CounsellorNotificationListPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<CounsellorProvider>().filterMeetingApiTap();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text('Notifications', style: textStyle(fontWeight: FontWeight.w600, fontSize: 18)),
      ),
      backgroundColor: AppColors.white,
      body: Consumer<CounsellorProvider>(builder: (context, pvd, child) {
        if(pvd.requestMeetingLoading){
          return const Center(child: CircularProgressIndicator());
        }

        final data = pvd.filterRequestMeetingData;
        if(data == null || data.data == null || data.data!.isEmpty){
          return Center(
            child: Text("No Notifications Available", style: textStyle(fontSize: 16, color: Colors.grey.shade600)),
          );
        }
        return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: data.data!.length,
        itemBuilder: (context, index) {
          final notification = data.data![index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: notification.requestByMeeting?.profilePhoto != null && notification.requestByMeeting!.profilePhoto!.isNotEmpty
                  ? ClipOval(
                      child: Image.network("${Apis.baseUrl}${notification.requestByMeeting?.profilePhoto}", width: 48, height: 48, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Icon(Icons.error))) : CircleAvatar(radius: 24, backgroundColor: Colors.grey.shade400, child: const Icon(Icons.person, size: 24, color: Colors.white)),
              title: Text(notification.requestByMeeting?.fullName ?? '', style: textStyle(fontWeight: FontWeight.w700)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(notification.title ?? "", style: textStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(notification.message ?? "", maxLines: 1, overflow: TextOverflow.ellipsis, style: textStyle(color: Colors.grey.shade700)),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(DateFormat("dd MMM yyyy").format(notification.createdAt ?? DateTime.now()), style: textStyle(fontSize: 12, color: Colors.grey.shade600)),
                  const SizedBox(height: 4),
                  Text(notification.requestByMeeting?.userRole ?? "", style: textStyle(fontSize: 12, color: Colors.grey.shade600)),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CounsellorNotificationPage(
                      projectName: notification.projectName ?? "",
                      fullName: notification.requestByMeeting?.fullName ?? '',
                      profilePhoto: "${Apis.baseUrl}${notification.requestByMeeting?.profilePhoto}",
                      userRole: notification.requestByMeeting?.userRole ?? "",
                      title: notification.title ?? "",
                      message: notification.message ?? "",
                      createdAt: DateFormat("dd MMM yyyy").format(notification.createdAt ?? DateTime.now()),
                    ),
                  ),
                );
              },
            ),
          );
        },
      );
      })
    );
  }
}