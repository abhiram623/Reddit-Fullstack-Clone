// ignore_for_file: public_member_api_docs, sort_constructors_first


class PostModel {
  final String id;
  final String title;
  final String? link;
  final String? description;
  final String communityName;
  final String communityProfilePic;
  final List<String> upVotes;
  final List<String> downVotes;
  final String userName;
  final String uid;
  final String type;
  final DateTime createdAt;
  final List<String> awards;
  PostModel({
    required this.id,
    required this.title,
    this.link,
    this.description,
    required this.communityName,
    required this.communityProfilePic,
    required this.upVotes,
    required this.downVotes,
    required this.userName,
    required this.uid,
    required this.type,
    required this.createdAt,
    required this.awards,
  });

  PostModel copyWith({
    String? id,
    String? title,
    String? link,
    String? description,
    String? communityName,
    String? communityProfilePic,
    List<String>? upVotes,
    List<String>? downVotes,
    String? userName,
    String? uid,
    String? type,
    DateTime? createdAt,
    List<String>? awards,
  }) {
    return PostModel(
      id: id ?? this.id,
      title: title ?? this.title,
      link: link ?? this.link,
      description: description ?? this.description,
      communityName: communityName ?? this.communityName,
      communityProfilePic: communityProfilePic ?? this.communityProfilePic,
      upVotes: upVotes ?? this.upVotes,
      downVotes: downVotes ?? this.downVotes,
      userName: userName ?? this.userName,
      uid: uid ?? this.uid,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      awards: awards ?? this.awards,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'link': link,
      'description': description,
      'communityName': communityName,
      'communityProfilePic': communityProfilePic,
      'upVotes': upVotes,
      'downVotes': downVotes,
      'userName': userName,
      'uid': uid,
      'type': type,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'awards': awards,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      
      id: map['id'] as dynamic,
      title: map['title'] as dynamic,
      link: map['link'] != null ? map['link'] as dynamic : null,
      description: map['description'] != null ? map['description'] as dynamic : null,
      communityName: map['communityName'] as dynamic,
      communityProfilePic: map['communityProfilePic'] as dynamic,
      upVotes: List<String>.from((map['upVotes'] as List<dynamic>)),
      downVotes: List<String>.from((map['downVotes'] as List<dynamic>)),
      userName: map['userName'] as dynamic,
      uid: map['uid'] as dynamic,
      type: map['type'] as dynamic,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      awards: List<String>.from((map['awards'] as List<dynamic>),
    ));
  }

}
