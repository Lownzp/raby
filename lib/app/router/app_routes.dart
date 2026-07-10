abstract final class AppRoutes {
  static const startup = '/startup';
  static const onboardingRabbit = '/onboarding/rabbit';
  static const records = '/records';
  static const recordsSearch = '/records/search';
  static const recordsNew = '/records/new';
  static const recordDetailPattern = '/records/:id';
  static const recordEditPattern = '/records/:id/edit';
  static const weight = '/weight';
  static const weightNew = '/weight/new';
  static const weightEditPattern = '/weight/:id/edit';
  static const me = '/me';
  static const rabbitDetail = '/me/rabbit';
  static const rabbitEdit = '/me/rabbit/edit';
  static const settings = '/settings';
  static const mediaAlbum = '/media/album';
  static const mediaPhotos = '/media/photos';

  static String recordDetail(String diaryId) => '/records/$diaryId';
  static String recordEdit(String diaryId) => '/records/$diaryId/edit';
  static String weightEdit(String recordId) => '/weight/$recordId/edit';
}
