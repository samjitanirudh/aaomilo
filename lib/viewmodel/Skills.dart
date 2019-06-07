import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;


class Skill{

  var txtID;
  var txtSkill;

  Skill(this.txtID,this.txtSkill);
}

class SkillClass{

  var uri ="http://convergepro.xyz/meetupapi/work/action.php?action=skills";
  static List<Skill> skillList = new List();

  List<Skill> getSkillList(){
    return skillList;
  }

  void skillGetRequest() {
    getSkill(uri)
        .then((String res) {
      if (res == null) throw new Exception("error");
      return res;
    });
  }

  Future<String> getSkill(String url) {
    return http.post(url).then((http.Response response) {

      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      getListSkill(json.decode(response.body));
      return response.body;
    });
  }

  void getListSkill(List<dynamic> webList){
    skillList.clear();
    for(int i =0;i<webList.length;i++){
      Skill c= new Skill(webList[i]["id"], webList[i]["skillname"] );
      skillList.add(c);
    }
  }

}