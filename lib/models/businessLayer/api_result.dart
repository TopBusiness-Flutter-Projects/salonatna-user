class APIResult<T> {
  String? status;
  bool? isDisplayMessage;
  String? message;
  T? recordList;
  int? totalRecords;
  dynamic value;
  Error? error;

  APIResult({
    this.status,
    this.isDisplayMessage,
    this.message,
    this.recordList,
    this.totalRecords,
    this.value,
    this.error,
  });

  factory APIResult.fromJson(Map<String, dynamic> json, T recordList) => APIResult(
        status: json["status"].toString(),
        isDisplayMessage: json['isDisplayMessage'],
        message: json["message"],
        recordList: recordList,
        totalRecords: json["totalRecords"],
        value: json["data"],
        error: json["error"] != null ? Error.fromJson(json["error"]) : null,
      );
}

class Error {
  String? apiName;
  String? apiType;
  String? fileName;
  dynamic functionName;
  dynamic lineNumber;
  dynamic typeName;
  String? stack;

  Error({
    this.apiName,
    this.apiType,
    this.fileName,
    this.functionName,
    this.lineNumber,
    this.typeName,
    this.stack,
  });

  factory Error.fromJson(Map<String, dynamic> json) => Error(
        apiName: json["apiName"],
        apiType: json["apiType"],
        fileName: json["fileName"],
        functionName: json["functionName"],
        lineNumber: json["lineNumber"],
        typeName: json["typeName"],
        stack: json["stack"],
      );
}
