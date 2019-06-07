import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;


class Venue{

  var txtID;
  var txtVenue;

  Venue(this.txtID,this.txtVenue);
}

class VenueClass{

  var uri ="http://convergepro.xyz/meetupapi/work/action.php?action=venue";
  static List<Venue> VenueList = new List();

  List<Venue> getVenueList(){
    return VenueList;
  }

  void venueGetRequest() {
    getVenue(uri)
        .then((String res) {
      if (res == null) throw new Exception("error");
      return res;
    });
  }

  Future<String> getVenue(String url) {
    return http.post(url).then((http.Response response) {

      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      getListVenue(json.decode(response.body));
      return response.body;
    });
  }

  void getListVenue(List<dynamic> webList){
    VenueList.clear();
    for(int i =0;i<webList.length;i++){
      Venue c= new Venue(webList[i]["id"], webList[i]["venue"] );
      VenueList.add(c);
    }
  }

}