class Address {
  String placeFormattedAddress;
  String placeName;
  String placeId;
  String latitude;
  String longitude;
  Address({
    this.placeFormattedAddress,
    this.placeName,
    this.placeId,
    this.latitude,
    this.longitude,
  });

  Address.fromJson(Map<String, dynamic> json) {
    placeFormattedAddress = json['placeFormattedAddress'];
    placeName = json['placeName'];
    placeId = json['placeId'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toMap() {
    return {
      'placeFormattedAddress': placeFormattedAddress,
      'placeName': placeName,
      'placeId': placeId,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
