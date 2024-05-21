import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<Map<String, String>> getUserDetails(String userId) async {
  try {
    // Get user document snapshot from Firestore
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userSnapshot.exists) {
      // Extract username and name from the document snapshot
      String username = userSnapshot.get('username');
      String name = userSnapshot.get('name');

      // Return the username and name as a map
      return {'username': username, 'name': name};
    } else {
      // User document does not exist
      throw Exception('User not found');
    }
  } catch (e) {
    // Error occurred
    print('Error fetching user details: $e');
    throw Exception('Failed to fetch user details');
  }
}

Future<String?> getUserProfileImageUrl(String userId) async {
  String? imageUrl;

  try {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    imageUrl = userDoc.get('image_url');
  } catch (e) {
    print('Error retrieving profile image URL: $e');
  }

  return imageUrl;
}

Widget profilecircleuser(double a, String userid) {
  return FutureBuilder<String?>(
    future: getUserProfileImageUrl(userid),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircleAvatar(
          radius: a,
          backgroundColor: Colors.grey,
        );
      } else if (snapshot.hasData && snapshot.data != null) {
        return CircleAvatar(
          radius: a,
          backgroundImage: NetworkImage(snapshot.data!),
        );
      } else {
        return CircleAvatar(
          radius: a,
          backgroundColor: Colors.grey,
        );
      }
    },
  );
}

// Existing code...

String formatRelativeTime(DateTime dateTime) {
  Duration difference = DateTime.now().difference(dateTime);
  if (difference.inDays >= 365) {
    int years = difference.inDays ~/ 365;
    return '${years}y';
  } else if (difference.inDays >= 30) {
    int months = difference.inDays ~/ 30;
    return '${months}mon';
  } else if (difference.inDays >= 2) {
    return '${difference.inDays}d';
  } else if (difference.inDays == 1) {
    return '1d';
  } else if (difference.inHours >= 2) {
    return '${difference.inHours}h';
  } else if (difference.inHours == 1) {
    return '1h';
  } else if (difference.inMinutes >= 2) {
    return '${difference.inMinutes}min';
  } else {
    return 'Just now';
  }
}
