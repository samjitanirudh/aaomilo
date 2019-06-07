import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;


class Categories{

  var txtID;
  var txtCategoryName;

  Categories(this.txtID,this.txtCategoryName);
}

class CategoryClass{

  var uri ="http://convergepro.xyz/meetupapi/work/action.php?action=categories";
  static List<Categories> categoryList = new List();

  List<Categories> getCategoryList(){
    return categoryList;
  }

  void categoryGetRequest() {
    getCategories(uri)
        .then((String res) {
      if (res == null) throw new Exception("error");
      return res;
    });
  }

  Future<String> getCategories(String url) {
    return http.post(url).then((http.Response response) {

      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      getListCategories(json.decode(response.body));
      return response.body;
    });
  }

  void getListCategories(List<dynamic> webList){
    categoryList.clear();

    for(int i =0;i<webList.length;i++){
      Categories c= new Categories(webList[i]["id"], webList[i]["category"]);
      categoryList.add(c);
    }
  }

}