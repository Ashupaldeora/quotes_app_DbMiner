class QuotesModel
{
  String quote,author,category;

  QuotesModel({required this.quote,required  this.author,required  this.category});

  factory QuotesModel.fromJson(Map json)
  {
    return QuotesModel(quote: json['quote'], author: json['author'], category: json['category']);
  }
}
