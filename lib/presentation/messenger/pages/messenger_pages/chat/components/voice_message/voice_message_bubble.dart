import 'dart:async';
import 'dart:io';
import 'package:Faleh_Hafez/Service/APIService.dart';
import 'package:Faleh_Hafez/application/messaging/bloc/messaging_bloc.dart';
import 'package:Faleh_Hafez/domain/models/message_dto.dart';
import 'package:Faleh_Hafez/presentation/messenger/pages/messenger_pages/chat/components/voice_message/voice_message_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:Faleh_Hafez/Service/signal_r/SignalR_Service.dart';
import 'package:Faleh_Hafez/presentation/messenger/pages/messenger_pages/chat/components/forward_modal_sheet.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/services.dart';

class VoiceMessageBubble extends StatefulWidget {
  final List<int> audioBytes;
  final Color backgroundColor;
  final Color foregroundColor;
  final bool? isMessage;
  final MessageDTO? message;
  final ThemeData themeState;

  const VoiceMessageBubble({
    super.key,
    this.message,
    this.isMessage = false,
    required this.audioBytes,
    required this.themeState,
    this.backgroundColor = const Color(0xFFE0F7FA),
    this.foregroundColor = const Color(0xFF006064),
  });

  @override
  State<VoiceMessageBubble> createState() => _VoiceMessageBubbleState();
}

class _VoiceMessageBubbleState extends State<VoiceMessageBubble> {
  late AudioPlayer _player;
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<Duration?>? _durationSub;
  StreamSubscription<PlayerState>? _stateSub;

  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isPlaying = false;
  String? _tempFilePath;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _prepareAudio();
  }

  Future<void> _prepareAudio() async {
    final dir = await getTemporaryDirectory();
    final file =
        File('${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.aac');

    try {
      await file.writeAsBytes(widget.audioBytes);
      await Future.delayed(const Duration(milliseconds: 100));
      _tempFilePath = file.path;

      await VoiceMessagePlayerController().stopCurrentPlayer();
      await VoiceMessagePlayerController().setCurrentPlayer(_player);

      await _player.setFilePath(_tempFilePath ?? '');
      await _player.setLoopMode(LoopMode.off);

      await _player.processingStateStream
          .firstWhere((state) => state != ProcessingState.idle);
      await _player.setLoopMode(LoopMode.off);

      _positionSub = _player.positionStream.listen((pos) {
        if (mounted) {
          setState(() => _position = pos);
        }
      });

      _durationSub = _player.durationStream.listen((dur) {
        if (dur != null && mounted) {
          setState(() => _duration = dur);
        }
      });

      _stateSub = _player.playerStateStream.listen((state) async {
        if (state.processingState == ProcessingState.completed) {
          await _player.pause();
          await _player.seek(Duration.zero);
          if (mounted) {
            setState(() {
              _isPlaying = false;
              _position = Duration.zero;
            });
          }
        }
      });
    } catch (e) {
      print("ERRRRRRRRRRRRRRRRRRROR: $e");
    }
  }

  Future<void> _togglePlayback() async {
    await VoiceMessagePlayerController().setCurrentPlayer(_player);

    if (_isPlaying) {
      await _player.pause();
      if (mounted) setState(() => _isPlaying = false);
    } else {
      if (_position >= _duration - const Duration(milliseconds: 300)) {
        await _player.seek(Duration.zero);
      }
      try {
        await _player.play();
        if (mounted) setState(() => _isPlaying = true);
      } catch (e) {
        print('Error playing audio: $e');
        if (mounted) setState(() => _isPlaying = false);
      }
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString();
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    _durationSub?.cancel();
    _stateSub?.cancel();

    _player.dispose();
    if (_tempFilePath != null) {
      final file = File(_tempFilePath!);
      if (file.existsSync()) file.deleteSync();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void safeAddEvent(MessagingEvent event) {
      final bloc = context.read<MessagingBloc>();
      if (!bloc.isClosed) {
        bloc.add(event);
      } else {
        debugPrint("MessagingBloc is closed. Event not added.");
      }
    }

    void handleOnPressMessage() {
      showMenu(
        context: context,
        position: RelativeRect.fill,
        items: [
          PopupMenuItem(
            enabled: false,
            value: widget.message?.text,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${widget.message!.text!.length < 20 ? widget.message?.text : '${widget.message?.text?.substring(
                      0,
                      20,
                    )} ...'}',
                  maxLines: 1,
                  style: TextStyle(
                    fontFamily: 'iranSans',
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: widget.themeState.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuItem(
            onTap: () {
              // showDialog(
              //   context: context,
              //   builder: (context) => ReplyMessageDialog(
              //     message: widget.message,
              //     token: userProfile.token!,
              //   ),
              // );
              if (context.read<MessagingBloc>().isClosed) {
                return;
              } else {
                // var correctReceiverID = '';
                // if (userProfile.id == widget.message.senderID &&
                //     widget.message.receiverID != null) {
                //   correctReceiverID = widget.message.receiverID!;
                // } else {
                //   correctReceiverID = widget.message.senderID!;
                // }
                var message = widget.message;
                safeAddEvent(
                  MessagingReplyMessageEvent(
                    message: message!,
                  ),
                );
              }
            },
            value: "reply",
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Reply"),
                SizedBox(
                  width: 5,
                ),
                Icon(Icons.reply),
              ],
            ),
          ),
          // PopupMenuItem(
          //   onTap: () {
          //     ClipboardData(
          //       text: widget.message!.text!,
          //     );
          //     context.showInfoBar(
          //       content: Text(
          //         "'${widget.message!.text!.length < 20 ? widget.message!.text : '${widget.message!.text?.substring(0, 20)} ...'}' Copied!",
          //       ),
          //     );
          //   },
          //   value: "copy",
          //   child: const Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Text("Copy"),
          //       SizedBox(
          //         width: 5,
          //       ),
          //       Icon(Icons.copy),
          //     ],
          //   ),
          // ),

          // PopupMenuItem(
          //   onTap: () async {
          //     // ignore: use_build_context_synchronously
          //     await showModalBottomSheet(
          //         backgroundColor: widget.themeState.colorScheme.primary,
          //         context: context,
          //         builder: (context) => ForwardModalSheet(
          //               message: widget.message!,
          //             ));
          //   },
          //   value: "forward",
          //   child: const Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Text("Forward"),
          //       SizedBox(
          //         width: 5,
          //       ),
          //       Icon(Icons.fast_forward),
          //     ],
          //   ),
          // ),
          // PopupMenuItem(
          //   onTap: () async {
          //     try {
          //       if (widget.message?.senderID == userProfile.id) {
          //         context.read<MessagingBloc>().add(
          //               MessagingEditMessageEvent(
          //                 message: widget.message!,
          //                 token: userProfile.token!,
          //               ),
          //               // MessagingEnterEditMode(
          //               //   message: widget.message,
          //               // ),
          //             );
          //       } else {
          //         return;
          //       }
          //     } catch (e) {
          //       context.showErrorBar(
          //         content: Text(
          //           e.toString(),
          //         ),
          //       );
          //     }
          //     // // }
          //   },
          //   value: "edit",
          //   child: const Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Text("Edit"),
          //       SizedBox(
          //         width: 5,
          //       ),
          //       Icon(Icons.edit),
          //     ],
          //   ),
          // ),

          PopupMenuItem(
            onTap: () async {
              try {
                await APIService().deleteMessage(
                  token: userProfile.token!,
                  messageID: widget.message!.messageID,
                );
                context.read<MessagingBloc>().add(
                      MessagingDeleteMessageSignalR(
                        // chatID: widget.message.chatID ??
                        //     widget.message.groupID!,
                        message: widget.message!,
                        token: userProfile.token!,
                      ),
                    );
              } catch (e) {
                context.showErrorBar(
                  content: Text(e.toString()),
                );
              }
            },
            value: "delete",
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Delete"),
                SizedBox(
                  width: 5,
                ),
                Icon(Icons.delete),
              ],
            ),
          ),
        ],
      ).then(
        (value) {
          if (value != null) {
            print("Selected: $value");
          }
        },
      );
    }

    final replyText = widget.message?.replyToMessageText;
    final isLong = replyText != null && replyText.length > 20;
    final displayText = replyText == null
        ? ''
        : isLong
            ? '${replyText.substring(0, 12)}...'
            : replyText;

    if (_tempFilePath == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final progress = _duration.inMilliseconds == 0
        ? 0.0
        : _position.inMilliseconds / _duration.inMilliseconds;

    return GestureDetector(
      onTap: handleOnPressMessage,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        margin: widget.isMessage!
            ? const EdgeInsets.only(top: 5, left: 10, right: 10)
            : const EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.message?.forwardedFromDisplayName != null &&
                widget.message!.forwardedFromDisplayName!.isNotEmpty)
              Text(
                'Forwarded from ${widget.message!.forwardedFromDisplayName}',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: 'iranSans',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: widget.themeState.colorScheme.onSecondary,
                ),
              )
            else
              Text(
                widget.message?.senderDisplayName ??
                    widget.message?.senderMobileNumber ??
                    '',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: 'iranSans',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: widget.themeState.colorScheme.background,
                ),
              ),
            if (widget.message?.replyToMessageID != null &&
                widget.message!.replyToMessageID!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 10,
                    ),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: widget.themeState.colorScheme.secondary,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.message?.senderDisplayName ?? '',
                          style: TextStyle(
                            fontFamily: 'iranSans',
                            fontSize: 8,
                            color: widget.themeState.colorScheme.onSecondary,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          'Reply to: $displayText',
                          style: TextStyle(
                            fontFamily: 'iranSans',
                            color: widget.themeState.colorScheme.onSecondary,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    _isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_fill,
                    size: 36,
                    color: widget.foregroundColor,
                  ),
                  onPressed: _togglePlayback,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: widget.foregroundColor.withOpacity(0.2),
                    valueColor:
                        AlwaysStoppedAnimation<Color>(widget.foregroundColor),
                    minHeight: 4,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _formatDuration(_position),
                  style: TextStyle(
                    fontFamily: 'iranSans',
                    fontSize: 14,
                    color: widget.foregroundColor,
                    fontWeight: FontWeight.w300,
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
