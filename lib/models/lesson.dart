class Lesson {
  final int id;
  final String title;
  final String category;
  final String description;
  final String status;
  final String image;

  Lesson({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.status,
    required this.image,
  });

  factory Lesson.fromMap(Map<String, dynamic> json) => Lesson(
    id: json['id'],
    title: json['title'],
    category: json['category'],
    description: json['description'],
    status: json['status'],
    image: json['image'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'category': category,
    'description': description,
    'status': status,
    'image': image,
  };
}
