import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/core/util/constants/app_constants.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AddTopicCard extends StatefulWidget {
  bool value;
  final String text;
  Function(bool) onTap;

  AddTopicCard({
    super.key,
    required this.value,
    required this.onTap,
    required this.text,
  });

  @override
  State<AddTopicCard> createState() => _AddTopicCardState();
}

class _AddTopicCardState extends State<AddTopicCard> {
  @override
  Widget build(BuildContext context) {
    log("widget.value:${widget.value}");
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          color: widget.value
              ? const Color.fromARGB(255, 209, 207, 229)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            setState(() {
              widget.value = !widget.value;
              widget.onTap(widget.value);
            });
          },
          child: Container(
            padding: EdgeInsets.all(
              Constant.figmaScreenWidth * (16 / Constant.figmaScreenWidth),
            ),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width:
                      Constant.screenWidth * (278 / Constant.figmaScreenWidth),
                  child: Text(
                    widget.text,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.urbanist(
                      fontSize: Constant.screenWidth *
                          (16 / Constant.figmaScreenWidth),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                widget.value
                    ? Icon(
                        PhosphorIcons.checkCircle(PhosphorIconsStyle.fill),
                        color: Colors.green,
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
