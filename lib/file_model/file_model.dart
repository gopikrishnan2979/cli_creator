class FileModel {
  final String _directory;
  final String _fileName;
  final String _snippet;

  FileModel(this._directory, this._fileName, this._snippet);
  String get filePath => "$_directory/$_fileName";
  String get snippet => _snippet;
}
