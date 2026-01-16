import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teen_theory/Models/CommonModels/all_ticket_model.dart';
import 'package:teen_theory/Providers/MentorProvider/mentor_provider.dart';
import 'package:teen_theory/Resources/fonts.dart';
import 'package:teen_theory/Screens/CounsellorDashboard/Tickets/ticket_detail.dart';
import 'package:teen_theory/Utils/helper.dart';

class TicketsPage extends StatefulWidget {
  const TicketsPage({Key? key}) : super(key: key);

  @override
  State<TicketsPage> createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MentorProvider>().allTicketApiTap();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      body: RefreshIndicator(
        onRefresh: () {
          return Future.wait([
            Future.sync(() => context.read<MentorProvider>().allTicketApiTap()),
          ]);
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Tickets',
                            style: textStyle(
                              fontSize: 22,
                              fontFamily: AppFonts.interBold,
                            ),
                          ),
                        ],
                      ),
        
                      hSpace(height: 8),
                      Text(
                        'Track, manage, and resolve student and mentor tickets.',
                        style: textStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
        
                      hSpace(height: 16),
        
                      // Status grid
                      _buildStatusGrid(),
        
                      hSpace(height: 12),
                    ],
                  ),
                ),
        
                // Tickets list as sliver
                Consumer<MentorProvider>(
                  builder: (context, pvd, child) {
                    if (pvd.ticketLoading) {
                      return const SliverFillRemaining(
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
        
                    if (pvd.allTicketData == null ||
                        pvd.allTicketData!.data == null ||
                        pvd.allTicketData!.data!.isEmpty) {
                      return SliverFillRemaining(
                        child: Center(
                          child: Text(
                            'No tickets found',
                            style: textStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      );
                    }
        
                    final tickets = pvd.allTicketData!.data!;
                    return SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final ticket = tickets[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: InkWell(
                            onTap: () {},
                            child: _ticketCardFromApi(ticket),
                          ),
                        );
                      }, childCount: tickets.length),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusGrid() {
    return Consumer<MentorProvider>(
      builder: (context, pvd, child) {
        final totalTickets = pvd.allTicketData?.data?.length ?? 0;
        final inProgress =
            pvd.allTicketData?.data
                ?.where(
                  (t) =>
                      t.status?.toLowerCase() == 'pending' ||
                      t.status?.toLowerCase() == 'opened',
                )
                .length ??
            0;
        final resolved =
            pvd.allTicketData?.data
                ?.where((t) => t.status?.toLowerCase() == 'resolved')
                .length ??
            0;

        final items = [
          {'count': '$totalTickets', 'label': 'Tickets'},
          {'count': '$inProgress', 'label': 'In Progress'},
          {'count': '$resolved', 'label': 'Resolved'},
        ];

        return Row(
          children: items.asMap().entries.map((entry) {
            final i = entry.key;
            final it = entry.value;
            
            // Get gradient based on label
            List<Color> gradient;
            String emoji;
            if (it['label'] == 'Tickets') {
              gradient = [Color(0xFF6DD5FA), Color(0xFF2980B9)];
              emoji = '🎫';
            } else if (it['label'] == 'In Progress') {
              gradient = [Color(0xFFFFA751), Color(0xFFFFE259)];
              emoji = '⏳';
            } else {
              gradient = [Color(0xFF56CCF2), Color(0xFF2F80ED)];
              emoji = '✅';
            }
            
            return Expanded(
              child: Container(
                height: 100,
                margin: EdgeInsets.only(right: i == items.length - 1 ? 0 : 8),
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
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          it['label']!,
                          style: textStyle(
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(emoji, style: TextStyle(fontSize: 18)),
                      ],
                    ),
                    Text(
                      it['count']!,
                      style: textStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontFamily: AppFonts.interBold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _ticketCardFromApi(Datum ticket) {
    final status = ticket.status ?? 'Opened';
    final statusColor = status.toLowerCase() == 'opened'
        ? Colors.black
        : (status.toLowerCase() == 'resolved' ? Colors.green : Colors.orange);

    // Get gradient for status
    List<Color> statusGradient;
    if (status.toLowerCase() == 'resolved') {
      statusGradient = [Color(0xFF56CCF2), Color(0xFF2F80ED)];
    } else if (status.toLowerCase() == 'pending' || status.toLowerCase() == 'opened') {
      statusGradient = [Color(0xFFFFA751), Color(0xFFFFE259)];
    } else {
      statusGradient = [Color(0xFF6DD5FA), Color(0xFF2980B9)];
    }

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TicketDetailPage(ticket: ticket),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
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
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          ticket.title ?? 'No Title',
                          style: textStyle(
                            fontSize: 16,
                            fontFamily: AppFonts.interBold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: ticket.priority?.toLowerCase() == 'high'
                                ? [Color(0xFFFF6B6B), Color(0xFFFF8E53)]
                                : ticket.priority?.toLowerCase() == 'medium'
                                    ? [Color(0xFFFFA751), Color(0xFFFFE259)]
                                    : [Color(0xFF6DD5FA), Color(0xFF2980B9)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: (ticket.priority?.toLowerCase() == 'high'
                                      ? Color(0xFFFF6B6B)
                                      : ticket.priority?.toLowerCase() == 'medium'
                                          ? Color(0xFFFFA751)
                                          : Color(0xFF6DD5FA))
                                  .withValues(alpha: 0.3),
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          ticket.priority ?? 'Low',
                          style: textStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  hSpace(height: 8),
                  Text(
                    '${ticket.raisedByUser?.fullName ?? 'Unknown'} (${ticket.raisedByUser?.userRole ?? 'User'})',
                    style: textStyle(fontSize: 13, color: Colors.grey.shade700),
                  ),
                  hSpace(height: 6),
                  Text(
                    ticket.projectName ?? 'No Project',
                    style: textStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                  hSpace(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: statusGradient,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: statusGradient[0].withValues(alpha: 0.3),
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          status,
                          style: textStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        ticket.raisedByUser?.createdAt != null
                            ? '${ticket.raisedByUser!.createdAt!.day} ${_getMonthName(ticket.raisedByUser!.createdAt!.month)}, ${ticket.raisedByUser!.createdAt!.year}'
                            : 'No Date',
                        style: textStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextButton(
                onPressed: () {
                  // Navigate to ticket detail if needed
                },
                child: Text(
                  'View',
                  style: textStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}
