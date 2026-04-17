import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../widgets/shared_widgets.dart';
import '../providers/chat_provider.dart';
import '../models/chat_model.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  int _selectedFilter = 0; // 0: All, 1: Personal, 2: Group, 3: Broadcast, 4: AI

  final List<String> _filters = ['All', 'Personal', 'Group', 'Broadcast', 'AI'];

  final List<ChatPreview> _mockChats = [
    ChatPreview(
        id: '1',
        name: 'Academic X AI Assistant',
        lastMessage: 'Here is the summary of Chapter 4...',
        time: 'Just now',
        unreadCount: 1,
        type: ChatType.ai,
        avatarInitials: 'AI',
        color: AppColors.primaryCyan),
    ChatPreview(
        id: '2',
        name: 'Batch 60 Official',
        lastMessage: 'Assignment 3 deadline has been extended to Friday.',
        time: '10:45 AM',
        unreadCount: 3,
        type: ChatType.broadcast,
        avatarInitials: 'B60',
        color: AppColors.warning),
    ChatPreview(
        id: '3',
        name: 'Capstone Group Alpha',
        lastMessage: 'Sajid: I pushed the latest commit to main.',
        time: 'Yesterday',
        unreadCount: 0,
        type: ChatType.group,
        avatarInitials: 'CA',
        color: AppColors.accentPurple),
    ChatPreview(
        id: '4',
        name: 'Dr. Sarah (Algorithms)',
        lastMessage: 'Yes, your approach to the DP problem is correct.',
        time: 'Mon',
        unreadCount: 0,
        type: ChatType.personal,
        avatarInitials: 'DS',
        color: AppColors.primaryBlue),
    ChatPreview(
        id: '5',
        name: 'John Doe',
        lastMessage: 'Can you send me the notes for today?',
        time: 'Sun',
        unreadCount: 0,
        type: ChatType.personal,
        avatarInitials: 'JD',
        color: AppColors.secondaryEmerald),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filteredChats = _selectedFilter == 0
        ? _mockChats
        : _mockChats.where((c) {
            if (_selectedFilter == 1) return c.type == ChatType.personal;
            if (_selectedFilter == 2) return c.type == ChatType.group;
            if (_selectedFilter == 3) return c.type == ChatType.broadcast;
            if (_selectedFilter == 4) return c.type == ChatType.ai;
            return true;
          }).toList();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(isDark),
            _buildSearchAndFilter(isDark),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                physics: const BouncingScrollPhysics(),
                itemCount: filteredChats.length,
                itemBuilder: (context, i) {
                  return _buildChatTile(filteredChats[i], isDark, i);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AppUtils.showPremiumSnackBar(context, 'TODO_CHAT_BACKEND: New Chat');
        },
        backgroundColor: AppColors.primaryCyan,
        child: const Icon(Icons.edit_square, color: Colors.white),
      ).animate().scale(delay: 600.ms, curve: Curves.easeOutBack),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: isDark ? Colors.white.withAlpha(8) : Colors.black.withAlpha(8),
              ),
              child: Icon(Icons.arrow_back_rounded,
                  color: isDark ? AppColors.darkText : AppColors.lightText, size: 20),
            ),
          ),
          const SizedBox(width: 14),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                colors: [AppColors.primaryBlue, AppColors.primaryCyan],
              ),
            ),
            child: const Icon(Icons.chat_bubble_rounded, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text('Messages',
                style: GoogleFonts.outfit(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                )),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildSearchAndFilter(bool isDark) {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: isDark ? Colors.white.withAlpha(8) : Colors.black.withAlpha(8),
              border: Border.all(
                color: isDark ? Colors.white.withAlpha(10) : Colors.black.withAlpha(10),
              ),
            ),
            child: TextField(
              style: GoogleFonts.outfit(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search messages...',
                hintStyle: GoogleFonts.outfit(
                  fontSize: 14,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                prefixIcon: Icon(Icons.search_rounded,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary, size: 20),
              ),
            ),
          ),
        ),

        // Filters
        SizedBox(
          height: 38,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: _filters.length,
            itemBuilder: (context, i) {
              final selected = i == _selectedFilter;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedFilter = i),
                  child: AnimatedContainer(
                    duration: 200.ms,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: selected
                          ? const LinearGradient(
                              colors: [AppColors.primaryBlue, AppColors.primaryCyan])
                          : null,
                      color: selected
                          ? null
                          : (isDark
                              ? Colors.white.withAlpha(8)
                              : Colors.black.withAlpha(8)),
                      border: Border.all(
                        color: selected
                            ? Colors.transparent
                            : (isDark
                                ? Colors.white.withAlpha(15)
                                : Colors.black.withAlpha(15)),
                      ),
                    ),
                    child: Center(
                      child: Text(_filters[i],
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                            color: selected
                                ? Colors.white
                                : (isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary),
                          )),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  Widget _buildChatTile(ChatPreview chat, bool isDark, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.all(14),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ConversationScreen(chatData: chat),
          ));
        },
        child: Row(
          children: [
            // Avatar
            Stack(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: chat.color.withAlpha(38),
                    border: Border.all(color: chat.color.withAlpha(128)),
                  ),
                  child: Center(
                    child: chat.type == ChatType.ai
                        ? Icon(Icons.auto_awesome_rounded, color: chat.color, size: 24)
                        : Text(chat.avatarInitials,
                            style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: chat.color)),
                  ),
                ),
                if (chat.type == ChatType.broadcast)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: AppColors.warning,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: isDark ? AppColors.darkCard : AppColors.lightCard, width: 2),
                      ),
                      child: const Icon(Icons.campaign_rounded, color: Colors.white, size: 10),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 14),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(chat.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(
                              fontSize: 15,
                              fontWeight: chat.unreadCount > 0 ? FontWeight.w700 : FontWeight.w500,
                              color: isDark ? AppColors.darkText : AppColors.lightText,
                            )),
                      ),
                      const SizedBox(width: 8),
                      Text(chat.time,
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            fontWeight: chat.unreadCount > 0 ? FontWeight.w600 : FontWeight.w400,
                            color: chat.unreadCount > 0
                                ? AppColors.primaryCyan
                                : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                          )),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Text(chat.lastMessage,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              fontWeight: chat.unreadCount > 0 ? FontWeight.w500 : FontWeight.w400,
                              color: chat.unreadCount > 0
                                  ? (isDark ? AppColors.darkText : AppColors.lightText)
                                  : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                            )),
                      ),
                      if (chat.unreadCount > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primaryCyan,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(chat.unreadCount.toString(),
                              style: GoogleFonts.outfit(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              )),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: 300 + index * 100), duration: 400.ms)
        .slideY(begin: 0.1, delay: Duration(milliseconds: 300 + index * 100), duration: 400.ms);
  }
}

// --- CONVERSATION VIEW ---

class ConversationScreen extends StatefulWidget {
  final ChatPreview chatData;

  const ConversationScreen({super.key, required this.chatData});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initial data is now fetched from Firestore via ChatProvider
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.sendMessage(widget.chatData.id, text, widget.chatData.type == ChatType.ai);
    _messageController.clear();
  }

  void _showAttachmentModal() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.lightCard,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.withAlpha(77), borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _AttachmentOption(Icons.image_rounded, 'Image', AppColors.primaryBlue, onTap: () {
                    Navigator.pop(context);
                    AppUtils.showPremiumSnackBar(context, 'Image upload coming soon...');
                  }),
                  _AttachmentOption(Icons.picture_as_pdf_rounded, 'Document', AppColors.error, onTap: () {
                    Navigator.pop(context);
                    AppUtils.showPremiumSnackBar(context, 'Document upload coming soon...');
                  }),
                  _AttachmentOption(Icons.mic_rounded, 'Voice', AppColors.success, onTap: () {
                    Navigator.pop(context);
                    AppUtils.showPremiumSnackBar(context, 'Voice recording coming soon...');
                  }),
                  _AttachmentOption(Icons.draw_rounded, 'Annotate', AppColors.accentPurple, onTap: () {
                    Navigator.pop(context);
                    AppUtils.showPremiumSnackBar(context, 'Drawing board coming soon...');
                  }),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Chat Header
            _buildConversationHeader(isDark),

            // Message List
            Expanded(
              child: Consumer<ChatProvider>(
                builder: (context, chatProvider, child) {
                  return StreamBuilder<List<ChatMessage>>(
                    stream: chatProvider.getMessages(widget.chatData.id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      
                      final messages = snapshot.data ?? [];
                      
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        reverse: true, // Show newest at bottom
                        itemCount: messages.length + (chatProvider.isTyping ? 1 : 0),
                        itemBuilder: (context, i) {
                          if (i == 0 && chatProvider.isTyping) {
                            return _buildTypingIndicator(isDark);
                          }
                          
                          final msgIndex = chatProvider.isTyping ? i - 1 : i;
                          final msg = messages[msgIndex];
                          
                          return _buildMessageBubble(
                            _Message(
                              msg.text,
                              msg.type == ChatMessageType.user,
                              DateFormat('hh:mm a').format(msg.timestamp),
                            ),
                            isDark,
                            i == 0,
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),

            // Input Area
            _buildMessageInput(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildConversationHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        border: Border(bottom: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 10)],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_rounded, color: isDark ? AppColors.darkText : AppColors.lightText),
            onPressed: () => Navigator.pop(context),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.chatData.color.withAlpha(38),
            ),
            child: Center(
              child: widget.chatData.type == ChatType.ai
                  ? Icon(Icons.auto_awesome_rounded, color: widget.chatData.color, size: 20)
                  : Text(widget.chatData.avatarInitials,
                      style: GoogleFonts.outfit(fontWeight: FontWeight.w700, color: widget.chatData.color, fontSize: 13)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.chatData.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    )),
                Text(widget.chatData.type == ChatType.ai ? 'Always Online' : 'Online',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: AppColors.primaryCyan,
                    )),
              ],
            ),
          ),
          if (widget.chatData.type == ChatType.group)
            IconButton(
              icon: Icon(Icons.info_outline_rounded, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
              onPressed: () {},
            ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(_Message msg, bool isDark, bool animate) {
    return Align(
      alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: msg.isMe
              ? AppColors.primaryCyan
              : (isDark ? AppColors.darkCard : Colors.white),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(msg.isMe ? 16 : 4),
            bottomRight: Radius.circular(msg.isMe ? 4 : 16),
          ),
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(msg.isMe ? 26 : 13), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: msg.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(msg.text,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: msg.isMe ? Colors.white : (isDark ? AppColors.darkText : AppColors.lightText),
                )),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(msg.time,
                    style: GoogleFonts.outfit(
                      fontSize: 10,
                      color: msg.isMe ? Colors.white.withAlpha(204) : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                    )),
                if (msg.isMe) ...[
                  const SizedBox(width: 4),
                  const Icon(Icons.done_all_rounded, size: 12, color: Colors.white),
                ]
              ],
            ),
          ],
        ),
      ).animate(target: animate ? 1 : 0).fadeIn(duration: 300.ms).slideY(begin: 0.2, end: 0, duration: 300.ms),
    );
  }

  Widget _buildTypingIndicator(bool isDark) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(16),
          ),
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 8)],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _DotAnimation(delay: 0),
            const SizedBox(width: 4),
            _DotAnimation(delay: 200),
            const SizedBox(width: 4),
            _DotAnimation(delay: 400),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 200.ms);
  }

  Widget _buildMessageInput(bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        border: Border(top: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            GestureDetector(
              onTap: _showAttachmentModal,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(shape: BoxShape.circle, color: isDark ? Colors.white.withAlpha(13) : Colors.black.withAlpha(13)),
                child: Icon(Icons.add_rounded, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: isDark ? Colors.white.withAlpha(13) : Colors.black.withAlpha(8),
                ),
                child: TextField(
                  controller: _messageController,
                  style: GoogleFonts.outfit(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    hintStyle: GoogleFonts.outfit(fontSize: 14, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.emoji_emotions_outlined, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary, size: 20),
                      onPressed: () => AppUtils.showPremiumSnackBar(context, 'Emoji keyboard coming soon...'),
                    ),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: _sendMessage,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [AppColors.primaryBlue, AppColors.primaryCyan])),
                child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AttachmentOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;
  
  const _AttachmentOption(this.icon, this.label, this.color, {this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(shape: BoxShape.circle, color: color.withAlpha(26)),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(label, style: GoogleFonts.outfit(fontSize: 12)),
        ],
      ),
    );
  }
}

class _DotAnimation extends StatelessWidget {
  final int delay;
  const _DotAnimation({required this.delay});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        color: AppColors.primaryCyan,
        shape: BoxShape.circle,
      ),
    ).animate(onPlay: (controller) => controller.repeat(reverse: true)).scale(
          begin: const Offset(0.5, 0.5),
          end: const Offset(1.2, 1.2),
          delay: Duration(milliseconds: delay),
          duration: 300.ms,
        );
  }
}

enum ChatType { personal, group, broadcast, ai }

class ChatPreview {
  final String id, name, lastMessage, time, avatarInitials;
  final int unreadCount;
  final ChatType type;
  final Color color;

  ChatPreview({required this.id, required this.name, required this.lastMessage, required this.time, required this.avatarInitials, required this.unreadCount, required this.type, required this.color});
}

class _Message {
  final String text;
  final bool isMe;
  final String time;

  _Message(this.text, this.isMe, this.time);
}
