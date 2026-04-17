import 'package:flutter/material.dart';

class Club {
  final String id;
  final String name;
  final String logo;
  final String description;
  final String room;
  final String fbUrl;
  final String websiteUrl;
  final List<ClubEvent> previousEvents;
  final List<ClubEvent> upcomingEvents;
  final IconData icon; 
  final Color color;

  // Mentor Details
  final String mentorName;
  final String mentorDesignation;
  final String mentorDept;
  final String mentorImage;

  // Lead (CA/CD) Details
  final String leadName;
  final String leadDesignation; // CA or CD
  final String leadId;
  final String leadBatch;
  final String leadSection;
  final String leadDept;
  final String leadContact;
  final String leadImage;

  Club({
    required this.id,
    required this.name,
    required this.logo,
    required this.description,
    required this.room,
    required this.fbUrl,
    required this.websiteUrl,
    required this.previousEvents,
    required this.upcomingEvents,
    required this.icon,
    required this.color,
    required this.mentorName,
    required this.mentorDesignation,
    required this.mentorDept,
    required this.mentorImage,
    required this.leadName,
    required this.leadDesignation,
    required this.leadId,
    required this.leadBatch,
    required this.leadSection,
    required this.leadDept,
    required this.leadContact,
    required this.leadImage,
  });
}

class ClubEvent {
  final String title;
  final String date;
  final String location;
  final String image;
  final String clubName;
  final String clubId;

  ClubEvent({
    required this.title,
    required this.date,
    required this.location,
    required this.image,
    required this.clubName,
    required this.clubId,
  });
}

class ClubProvider with ChangeNotifier {
  final List<Club> _allClubs = [
    Club(
      id: '1',
      name: 'Robotics Society, Varendra University (RSVU)',
      logo: 'assets/images/clubs/rsvu.png',
      description: 'Innovating the future through robotics and automation. Join us to build amazing robots and compete in national competitions.',
      mentorName: 'Prof. Sarah Jenkins',
      mentorDesignation: 'Professor',
      mentorDept: 'Dept. of CSE',
      mentorImage: 'assets/images/clubs/mentor_1.png',
      leadName: 'Rafid Hasan',
      leadDesignation: 'CD',
      leadId: '211311000',
      leadBatch: '21st',
      leadSection: 'A',
      leadDept: 'Dept. of CSE',
      leadContact: '01700000000',
      leadImage: 'assets/images/clubs/lead_1.png',
      room: 'Robotics Lab, Ground Floor',
      fbUrl: 'https://facebook.com/rsvu',
      websiteUrl: 'https://rsvu.vu.edu.bd',
      icon: Icons.precision_manufacturing_rounded,
      color: Colors.orange,
      previousEvents: [
        ClubEvent(title: 'RoboQuest 2024', date: '20 Nov 2024', location: 'Auditorium', image: 'assets/images/events/rob_prev.png', clubName: 'Robotics Society (RSVU)', clubId: '1'),
      ],
      upcomingEvents: [
        ClubEvent(title: 'Line Follower Contest', date: '15 April 2026', location: 'Auditorium', image: 'assets/images/events/rob_up.png', clubName: 'Robotics Society (RSVU)', clubId: '1'),
      ],
    ),
    Club(
      id: '2',
      name: 'Varendra University Programming Club (VUPC)',
      logo: 'assets/images/clubs/vupc.png',
      description: 'The hub for competitive programmers and tech enthusiasts. We organize hackathons and coding contests.',
      mentorName: 'Dr. Md. Sayeedul Aman',
      mentorDesignation: 'Assistant Professor',
      mentorDept: 'Dept. of CSE',
      mentorImage: 'assets/images/clubs/mentor_2.png',
      leadName: 'Tawsif Ahmed',
      leadDesignation: 'CA',
      leadId: '211311055',
      leadBatch: '21st',
      leadSection: 'B',
      leadDept: 'Dept. of CSE',
      leadContact: '01800000000',
      leadImage: 'assets/images/clubs/lead_2.png',
      room: 'Room 402, Building 1',
      fbUrl: 'https://facebook.com/vupc',
      websiteUrl: 'https://vupc.vu.edu.bd',
      icon: Icons.code_rounded,
      color: Colors.cyan,
      previousEvents: [],
      upcomingEvents: [
        ClubEvent(title: 'CodeSprint 2025', date: '15 Jan 2025', location: 'Lab 101', image: 'assets/images/events/cpc_prev.png', clubName: 'Programming Club (VUPC)', clubId: '2'),
      ],
    ),
    Club(
      id: '3',
      name: 'Web Development Club (VUWDC)',
      logo: 'assets/images/clubs/vuwdc.png',
      description: 'Focusing on modern web technologies and full-stack development.',
      mentorName: 'Mr. X',
      mentorDesignation: 'Lecturer',
      mentorDept: 'Dept. of CSE',
      mentorImage: 'assets/images/clubs/mentor_3.png',
      leadName: 'Lead Y',
      leadDesignation: 'CA',
      leadId: '211311099',
      leadBatch: '22nd',
      leadSection: 'A',
      leadDept: 'Dept. of CSE',
      leadContact: '01900000000',
      leadImage: 'assets/images/clubs/lead_3.png',
      room: 'Room 305',
      fbUrl: 'https://facebook.com/vuwdc',
      websiteUrl: 'https://vuwdc.vu.edu.bd',
      icon: Icons.web_rounded,
      color: Colors.blue,
      previousEvents: [],
      upcomingEvents: [],
    ),
    Club(
      id: '4',
      name: 'CSE Sports Club',
      logo: 'assets/images/clubs/sports.png',
      description: 'Promoting physical activities and organizing sports tournaments for CSE students.',
      mentorName: 'Mr. Coach',
      mentorDesignation: 'Lecturer',
      mentorDept: 'Dept. of CSE',
      mentorImage: 'assets/images/clubs/mentor_4.png',
      leadName: 'Lead Z',
      leadDesignation: 'CD',
      leadId: '211311011',
      leadBatch: '20th',
      leadSection: 'C',
      leadDept: 'Dept. of CSE',
      leadContact: '01600000000',
      leadImage: 'assets/images/clubs/lead_4.png',
      room: 'Sports Room',
      fbUrl: 'https://facebook.com/csesports',
      websiteUrl: '',
      icon: Icons.sports_cricket_rounded,
      color: Colors.green,
      previousEvents: [],
      upcomingEvents: [],
    ),
    Club(
      id: '5',
      name: 'Hult Prize at Varendra University (HPVU)',
      logo: 'assets/images/clubs/hpvu.png',
      description: 'The world\'s largest student competition for social good.',
      mentorName: 'Ms. Hult',
      mentorDesignation: 'Advisor',
      mentorDept: 'Dept. of BBA',
      mentorImage: 'assets/images/clubs/mentor_5.png',
      leadName: 'Lead H',
      leadDesignation: 'CA',
      leadId: '221311000',
      leadBatch: '22nd',
      leadSection: 'A',
      leadDept: 'Dept. of CSE',
      leadContact: '01500000000',
      leadImage: 'assets/images/clubs/lead_5.png',
      room: 'Room 102',
      fbUrl: 'https://facebook.com/hpvu',
      websiteUrl: 'https://hultprize.org',
      icon: Icons.lightbulb_rounded,
      color: Colors.pink,
      previousEvents: [],
      upcomingEvents: [],
    ),
    Club(
      id: '6',
      name: 'BASIS Student Forum, VU Chapter',
      logo: 'assets/images/clubs/basis.png',
      description: 'Bridging the gap between industry and academia.',
      mentorName: 'Mr. Basis',
      mentorDesignation: 'Assistant Professor',
      mentorDept: 'Dept. of CSE',
      mentorImage: 'assets/images/clubs/mentor_6.png',
      leadName: 'Lead B',
      leadDesignation: 'CA',
      leadId: '201311000',
      leadBatch: '20th',
      leadSection: 'A',
      leadDept: 'Dept. of CSE',
      leadContact: '01400000000',
      leadImage: 'assets/images/clubs/lead_6.png',
      room: 'Room 501',
      fbUrl: 'https://facebook.com/basis.vu',
      websiteUrl: '',
      icon: Icons.business_center_rounded,
      color: Colors.indigo,
      previousEvents: [],
      upcomingEvents: [],
    ),
    Club(
      id: '7',
      name: 'BD Apps, Varendra University Chapter',
      logo: 'assets/images/clubs/bdapps.png',
      description: 'The largest app ecosystem in Bangladesh.',
      mentorName: 'Mr. App',
      mentorDesignation: 'Lecturer',
      mentorDept: 'Dept. of CSE',
      mentorImage: 'assets/images/clubs/mentor_7.png',
      leadName: 'Lead A',
      leadDesignation: 'CA',
      leadId: '211311007',
      leadBatch: '21st',
      leadSection: 'B',
      leadDept: 'Dept. of CSE',
      leadContact: '01300000000',
      leadImage: 'assets/images/clubs/lead_7.png',
      room: 'Room 502',
      fbUrl: 'https://facebook.com/bdapps.vu',
      websiteUrl: '',
      icon: Icons.android_rounded,
      color: Colors.red,
      previousEvents: [],
      upcomingEvents: [],
    ),
  ];

  final Set<String> _myClubIds = {'1'};

  List<Club> get allClubs => _allClubs;
  List<Club> get myClubs => _allClubs.where((c) => _myClubIds.contains(c.id)).toList();

  List<ClubEvent> get allUpcomingEvents {
    List<ClubEvent> events = [];
    for (var club in _allClubs) {
      events.addAll(club.upcomingEvents);
    }
    return events;
  }

  void toggleMembership(String clubId) {
    if (_myClubIds.contains(clubId)) {
      _myClubIds.remove(clubId);
    } else {
      _myClubIds.add(clubId);
    }
    notifyListeners();
  }

  bool isMember(String clubId) => _myClubIds.contains(clubId);
}
