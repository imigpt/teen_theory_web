import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teen_theory/Resources/colors.dart';
// helper imports not required here currently

/// Token list and detail screen
class TokenListScreen extends StatelessWidget {
  const TokenListScreen({Key? key}) : super(key: key);

  static final List<TokenItem> _sampleTokens = [
    TokenItem(
      name: 'Default API Token',
      token: 'abc123-def456-ghi789',
      createdAt: DateTime.now().subtract(Duration(days: 3)),
      scopes: ['read', 'write'],
      status: 'Active',
    ),
    TokenItem(
      name: 'Student App - Mobile',
      token: 'stu-987-zyx',
      createdAt: DateTime.now().subtract(Duration(days: 30)),
      scopes: ['read'],
      status: 'Revoked',
    ),
    TokenItem(
      name: 'Integration Token',
      token: 'int-456-asd',
      createdAt: DateTime.now().subtract(Duration(days: 1)),
      scopes: ['read', 'write', 'delete'],
      status: 'Active',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text('🔑 Tickets', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 8),
        itemCount: _sampleTokens.length,
        itemBuilder: (context, index) {
          final t = _sampleTokens[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => TokenDetailScreen(token: t))),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      _avatar(t),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(t.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
                            SizedBox(height: 6),
                            Text(t.token, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey.shade600)),
                          ],
                        ),
                      ),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(_formatDate(t.createdAt), style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                          SizedBox(height: 8),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: t.status == 'Active' ? Colors.green.shade50 : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(t.status, style: TextStyle(fontSize: 12, color: t.status == 'Active' ? Colors.green : Colors.grey.shade700)),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _avatar(TokenItem t) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.lightGrey3,
      ),
      child: Center(child: Text(t.name.split(' ').map((e) => e[0]).take(2).join(), style: TextStyle(fontSize: 18))),
    );
  }

  String _formatDate(DateTime d) {
    final now = DateTime.now();
    final diff = now.difference(d);
    if (diff.inDays >= 1) return '${diff.inDays}d';
    if (diff.inHours >= 1) return '${diff.inHours}h';
    return 'now';
  }
}

class TokenItem {
  final String name;
  final String token;
  final DateTime createdAt;
  final List<String> scopes;
  final String status;

  TokenItem({required this.name, required this.token, required this.createdAt, required this.scopes, required this.status});
}

class TokenDetailScreen extends StatelessWidget {
  final TokenItem token;
  const TokenDetailScreen({Key? key, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Navigator.of(context).pop()),
        title: Text('Token Details', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(token.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.black87)),
            SizedBox(height: 10),
            Row(children: [
              Expanded(child: Text(token.token, style: TextStyle(color: Colors.grey.shade800))),
              IconButton(onPressed: () => _copyToken(context), icon: Icon(Icons.copy, color: AppColors.black)),
            ]),
            const SizedBox(height: 16),
            Text('Scopes', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            SizedBox(height: 8),
            Wrap(spacing: 8, children: token.scopes.map((s) => Chip(label: Text(s))).toList()),
            Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () => _revokeToken(context),
                    child: Text('Revoke', style: TextStyle(color: Colors.white)),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.black),
                    onPressed: () {},
                    child: Text('Regenerate', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _copyToken(BuildContext context) {
    Clipboard.setData(ClipboardData(text: token.token));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Token copied to clipboard')));
  }

  void _revokeToken(BuildContext context) {
    // For demo - show confirmation. Replace with API call.
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Revoke Token?'),
        content: Text('Are you sure you want to revoke this token? This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Cancel')),
          TextButton(onPressed: () { Navigator.of(context).pop(); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Token revoked'))); }, child: Text('Revoke')),
        ],
      ),
    );
  }
}
