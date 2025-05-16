import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utility {
  static Color primaryPurple = Color(0xFF6B2C91);
  static Color lightPurple = Color(0xFF8A4EAF);
  static Color darkPurple = Color(0xFF4A1D64);

  static String getIconUrl(String iconCode, {double size = 2.0}) {
    final String sizeString = size == 2.0 ? '@2x' : (size == 4.0 ? '@4x' : '');
    return 'https://openweathermap.org/img/wn/$iconCode${sizeString}.png';
  }

  static String formatDateFromTimestamp(int timestamp) {
    final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
      timestamp * 1000,
    );
    final DateFormat formatter = DateFormat('EEEE, MMMM d');
    return formatter.format(dateTime);
  }

  static Widget customNewsCard({
    required String title,
    required String source,
    required String time,
    required String imageUrl,
    required VoidCallback onPress,
    String? tag,
  }) {
    return InkWell(
      onTap: onPress,
      child: Container(
        height: 100,
        margin: const EdgeInsets.fromLTRB(5, 10, 5, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Utility.darkPurple.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // News Image
            Container(
              width: 85,
              height: 85,
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                // borderRadius: const BorderRadius.only(
                //   topLeft: Radius.circular(12),
                //   bottomLeft: Radius.circular(12),
                // ),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(imageUrl),
                ),
              ),
            ),
            // News Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: darkPurple,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        Text(
                          source,
                          style: TextStyle(fontSize: 12, color: primaryPurple),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          time.substring(0, 10),
                          style: TextStyle(
                            fontSize: 12,
                            color: darkPurple.withOpacity(0.7),
                          ),
                        ),
                        if (tag != null && tag.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: primaryPurple.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              tag,
                              style: TextStyle(
                                fontSize: 10,
                                color: primaryPurple,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
