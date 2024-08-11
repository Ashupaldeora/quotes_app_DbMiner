class QuotesModel
{
  final int? id;
  String quote,author,category;
  bool isFavorite;

  QuotesModel({this.id,required this.quote,required  this.author,required  this.category,this.isFavorite=false});

  factory QuotesModel.fromJson(Map json)
  {
    return QuotesModel(quote: json['quote'], author: json['author'], category: json['category'],);
  }
  Map<String, dynamic> toMap() {
    return {

      'quote': quote,
      'author': author,
      'category': category,
      'is_favorite': isFavorite ? 1 : 0,
    };
  }

  factory QuotesModel.fromMap(Map<String, dynamic> map) {
    return QuotesModel(
      id: map['id'], // Retrieve ID from database
      quote: map['quote'],
      author: map['author'],
      category: map['category'],
      isFavorite: map['is_favorite'] == 1, // Convert from integer to boolean
    );
  }
}
