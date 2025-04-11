import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Testcard extends StatelessWidget {
  final Color color;
  final String subjectName;
  final String level;
  final int count;
  final String tile;
  const Testcard(
      {super.key,
      required this.subjectName,
      required this.level,
      required this.count,
      required this.color,
      required this.tile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16, right: 2),
      // height: 115,
      width: 260,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Flexible(
            flex: 3,
            child: SizedBox(
              height: 87,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        subjectName,
                        style: GoogleFonts.urbanist(
                            fontWeight: FontWeight.w400, fontSize: 16),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        "#$count",
                        style: GoogleFonts.urbanist(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    tile,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: GoogleFonts.urbanist(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                            top: 4, right: 12, bottom: 4, left: 12),
                        // height: 25,
                        decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(56)),
                        child: Text(
                          level,
                          style: GoogleFonts.urbanist(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 14),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Center(
              child: SizedBox(
                height: 16,
                width: 16,
                child: Image.asset('assets/icons/right_arrow.png'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
