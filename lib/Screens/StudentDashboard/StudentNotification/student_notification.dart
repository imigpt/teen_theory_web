import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:teen_theory/Models/StudentModels/student_noti_model.dart';
import 'package:teen_theory/Providers/StudentProviders/student_notification_provider.dart';
import 'package:teen_theory/Resources/colors.dart';

class StudentNotificationScreen extends StatefulWidget {
	const StudentNotificationScreen({super.key});

	@override
	State<StudentNotificationScreen> createState() => _StudentNotificationScreenState();
}

class _StudentNotificationScreenState extends State<StudentNotificationScreen> {
	@override
	void initState() {
		super.initState();
		WidgetsBinding.instance.addPostFrameCallback((_) {
			if (!mounted) return;
			context.read<StudentNotificationProvider>().fetchNotifications();
		});
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: const Color(0xFFF5F7FB),
			appBar: AppBar(
				backgroundColor: Colors.white,
				foregroundColor: Colors.black,
				elevation: 0,
				title: const Text('Notifications', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
			),
			body: Consumer<StudentNotificationProvider>(
				builder: (context, provider, child) {
					if (provider.isLoading && !provider.hasData) {
						return _buildLoadingState();
					}

					if (provider.errorMessage != null && !provider.hasData) {
						return _buildErrorState(provider);
					}

					if (!provider.isLoading && !provider.hasData) {
						return _buildEmptyState(provider);
					}

					return RefreshIndicator(
						color: AppColors.yellow600,
						onRefresh: () => provider.refreshNotifications(),
						child: ListView(
							padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
							physics: const AlwaysScrollableScrollPhysics(),
							children: [
								// _buildHeroCard(provider),
								// const SizedBox(height: 20),
								...provider.notifications.map(_buildNotificationCard),
								const SizedBox(height: 16),
							],
						),
					);
				},
			),
		);
	}

	Widget _buildLoadingState() {
		return ListView.builder(
			padding: const EdgeInsets.all(16),
			itemCount: 6,
			itemBuilder: (context, index) {
				return Container(
					margin: const EdgeInsets.only(bottom: 16),
					padding: const EdgeInsets.all(18),
					decoration: BoxDecoration(
						color: Colors.white,
						borderRadius: BorderRadius.circular(18),
					),
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							Container(height: 18, width: 140, color: Colors.grey.shade200),
							const SizedBox(height: 12),
							Container(height: 14, width: 220, color: Colors.grey.shade100),
							const SizedBox(height: 8),
							Container(height: 14, width: 120, color: Colors.grey.shade100),
						],
					),
				);
			},
		);
	}

	Widget _buildErrorState(StudentNotificationProvider provider) {
		return Center(
			child: Padding(
				padding: const EdgeInsets.symmetric(horizontal: 32),
				child: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					children: [
						const Icon(Icons.error_outline, size: 52, color: Colors.redAccent),
						const SizedBox(height: 16),
						Text(
							provider.errorMessage ?? 'Unable to load notifications right now.',
							textAlign: TextAlign.center,
							style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
						),
						const SizedBox(height: 18),
						ElevatedButton.icon(
							onPressed: () => provider.fetchNotifications(forceRefresh: true),
							icon: const Icon(Icons.refresh),
							style: ElevatedButton.styleFrom(
								backgroundColor: Colors.black,
								foregroundColor: Colors.white,
								padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
								shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
							),
							label: const Text('Retry'),
						),
					],
				),
			),
		);
	}

	Widget _buildEmptyState(StudentNotificationProvider provider) {
		return RefreshIndicator(
			color: AppColors.yellow600,
			onRefresh: () => provider.refreshNotifications(),
			child: ListView(
				physics: const AlwaysScrollableScrollPhysics(),
				padding: const EdgeInsets.all(16),
				children: [
					Container(
						padding: const EdgeInsets.all(24),
						decoration: BoxDecoration(
							color: Colors.white,
							borderRadius: BorderRadius.circular(18),
							border: Border.all(color: Colors.grey.shade200),
						),
						child: Column(
							children: [
								Icon(Icons.notifications_none, size: 48, color: Colors.grey.shade500),
								const SizedBox(height: 16),
								const Text(
									'You are all caught up!',
									style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
								),
								const SizedBox(height: 8),
								Text(
									'New project updates, mentor notes, and reminders will show up here.',
									textAlign: TextAlign.center,
									style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
								),
							],
						),
					),
				],
			),
		);
	}

	// Widget _buildHeroCard(StudentNotificationProvider provider) {
	// 	final total = provider.notifications.length;
	// 	final latestUpdate = provider.notifications.isNotEmpty
	// 			? provider.notifications.first.createdAt?.toLocal()
	// 			: null;
	// 	final subtitle = latestUpdate != null
	// 			? 'Last update ${DateFormat('dd MMM, hh:mm a').format(latestUpdate)}'
	// 			: 'Stay tuned for new updates';

	// 	return Container(
	// 		padding: const EdgeInsets.all(20),
	// 		decoration: BoxDecoration(
	// 			borderRadius: BorderRadius.circular(22),
	// 			gradient: const LinearGradient(
	// 				colors: [Color(0xFF1F1F1F), Color(0xFF2B2B2B)],
	// 				begin: Alignment.topLeft,
	// 				end: Alignment.bottomRight,
	// 			),
	// 			boxShadow: [
	// 				BoxShadow(
	// 					color: Colors.black.withOpacity(.12),
	// 					blurRadius: 20,
	// 					offset: const Offset(0, 14),
	// 				),
	// 			],
	// 		),
	// 		child: Column(
	// 			crossAxisAlignment: CrossAxisAlignment.start,
	// 			children: [
	// 				Row(
	// 					children: [
	// 						Container(
	// 							height: 46,
	// 							width: 46,
	// 							decoration: BoxDecoration(
	// 								color: Colors.white.withOpacity(.12),
	// 								borderRadius: BorderRadius.circular(14),
	// 							),
	// 							child: const Icon(Icons.notifications_active, color: Colors.white, size: 26),
	// 						),
	// 						const SizedBox(width: 14),
	// 						Expanded(
	// 							child: Text(
	// 								'Stay informed about every project move.',
	// 								style: TextStyle(color: Colors.white.withOpacity(.9), fontSize: 16, fontWeight: FontWeight.w600),
	// 							),
	// 						),
	// 					],
	// 				),
	// 				const SizedBox(height: 20),
	// 				Row(
	// 					children: [
	// 						_buildHeroMetric('Total alerts', total.toString()),
	// 						const SizedBox(width: 14),
	// 						Expanded(
	// 							child: Container(
	// 								padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
	// 								decoration: BoxDecoration(
	// 									color: Colors.white.withOpacity(.08),
	// 									borderRadius: BorderRadius.circular(16),
	// 									border: Border.all(color: Colors.white.withOpacity(.12)),
	// 								),
	// 								child: Text(
	// 									subtitle,
	// 									style: TextStyle(color: Colors.white.withOpacity(.8), fontSize: 12),
	// 								),
	// 							),
	// 						),
	// 					],
	// 				),
	// 			],
	// 		),
	// 	);
	// }

	// Widget _buildHeroMetric(String label, String value) {
	// 	return Container(
	// 		padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
	// 		decoration: BoxDecoration(
	// 			color: Colors.white.withOpacity(.08),
	// 			borderRadius: BorderRadius.circular(16),
	// 			border: Border.all(color: Colors.white.withOpacity(.12)),
	// 		),
	// 		child: Column(
	// 			crossAxisAlignment: CrossAxisAlignment.start,
	// 			children: [
	// 				Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
	// 				const SizedBox(height: 4),
	// 				Text(label, style: TextStyle(color: Colors.white.withOpacity(.7), fontSize: 12)),
	// 			],
	// 		),
	// 	);
	// }

	Widget _buildNotificationCard(Datum notification) {
		final createdAt = notification.createdAt?.toLocal();
		final createdAtText = createdAt != null
				? DateFormat('EEE, dd MMM • hh:mm a').format(createdAt)
				: 'Date unavailable';
		final assignedBy = notification.assignedByUser?.fullName ?? 'Teen Theory';

		return Container(
			margin: const EdgeInsets.only(bottom: 16),
			padding: const EdgeInsets.all(20),
			decoration: BoxDecoration(
				color: Colors.white,
				borderRadius: BorderRadius.circular(20),
				border: Border.all(color: Colors.grey.shade200),
				boxShadow: [
					BoxShadow(
						color: Colors.black.withOpacity(.03),
						blurRadius: 18,
						offset: const Offset(0, 12),
					),
				],
			),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					Row(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							// Container(
							// 	padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
							// 	decoration: BoxDecoration(
							// 		color: statusColor.withOpacity(.12),
							// 		borderRadius: BorderRadius.circular(12),
							// 	),
							// 	child: Text(
							// 		status,
							// 		style: TextStyle(color: statusColor, fontWeight: FontWeight.w700, fontSize: 12),
							// 	),
							// ),
							const SizedBox(width: 12),
							Expanded(
								child: Text(
									notification.title ?? 'Notification',
									style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
								),
							),
						],
					),
					const SizedBox(height: 14),
					Row(
						children: [
							Container(
								height: 44,
								width: 44,
								decoration: BoxDecoration(
									color: AppColors.yellow50,
									borderRadius: BorderRadius.circular(14),
								),
								child: Center(
									child: Text(
										assignedBy.isNotEmpty ? assignedBy[0].toUpperCase() : 'T',
										style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
									),
								),
							),
							const SizedBox(width: 12),
							Expanded(
								child: Column(
									crossAxisAlignment: CrossAxisAlignment.start,
									children: [
										Text(
											assignedBy,
											style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
										),
                    Text("counsellor", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Colors.grey)),
										const SizedBox(height: 4),
										Text(
											createdAtText,
											style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w600),
										),
									],
								),
							),
						],
					),
				],
			),
		);
	}

	Color _statusColor(String status) {
		final normalized = status.toLowerCase();
		if (normalized.contains('done') || normalized.contains('complete')) {
			return const Color(0xFF2E7D32);
		}
		if (normalized.contains('pending') || normalized.contains('in progress')) {
			return const Color(0xFFED6C02);
		}
		if (normalized.contains('urgent') || normalized.contains('issue')) {
			return const Color(0xFFC62828);
		}
		return const Color(0xFF1565C0);
	}
}
