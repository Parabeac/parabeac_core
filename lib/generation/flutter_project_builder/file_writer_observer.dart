abstract class FileWriterObserver {
  ///Event receiver that a file was created. In the event,
  ///there is going to be access to the following parameters:
  ///
  ///`filePath`: the path of where the file was created at.
  ///`fileUUID`: the unique identifier of the file.
  void fileCreated(String filePath, String fileUUID);
}
