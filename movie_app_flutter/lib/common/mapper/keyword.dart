
import '../../core/entity/keyword.dart';
import '../../core/model/keyword.dart';

class KeywordMapper {

  static KeywordEntity toEntity(KeywordModel keywordModel) {
    return KeywordEntity(
        name: keywordModel.name,
        id: keywordModel.id
    );
  }
}