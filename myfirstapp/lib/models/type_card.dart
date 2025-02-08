
class TypeModel {
  String? imageAsset;
  String? typeName;

  TypeModel({
      this.imageAsset,
      this.typeName,
    });
}



final typeImages = [
  TypeModel(
    imageAsset: "assets/images/type-man.png",
    typeName: "Man",
  ),
  TypeModel(
    imageAsset: "assets/images/type-kid.png",
    typeName: "Kid",
  ),
  TypeModel(
    imageAsset: "assets/images/type-woman.png",
    typeName: "Woman",
  ),
];