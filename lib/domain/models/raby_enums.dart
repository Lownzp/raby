enum RabbitSex {
  male('male'),
  female('female'),
  unknown('unknown');

  const RabbitSex(this.value);

  final String value;

  static RabbitSex fromValue(String value) {
    return RabbitSex.values.firstWhere(
      (sex) => sex.value == value,
      orElse: () => RabbitSex.unknown,
    );
  }
}

enum NeuteredStatus {
  notNeutered('not_neutered'),
  neutered('neutered'),
  unknown('unknown');

  const NeuteredStatus(this.value);

  final String value;

  static NeuteredStatus fromValue(String value) {
    return NeuteredStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => NeuteredStatus.unknown,
    );
  }
}

enum MediaType {
  image('image'),
  video('video');

  const MediaType(this.value);

  final String value;

  static MediaType fromValue(String value) {
    return MediaType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => MediaType.image,
    );
  }
}

enum TagKind {
  normal('normal'),
  milestone('milestone');

  const TagKind(this.value);

  final String value;

  static TagKind fromValue(String value) {
    return TagKind.values.firstWhere(
      (kind) => kind.value == value,
      orElse: () => TagKind.normal,
    );
  }
}
