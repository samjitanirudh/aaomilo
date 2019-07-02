class Invite{

  var _id;
  var _title;
  var _description;
  var _category_id;
  var _time;
  var _venue;
  var _image;
  var _allowed_member_count;
  var _created_by;
  var _created_date;
  var _first_name;
  var _joined;
  var _joinees;
  var _isJoined;

  get joinees => _joinees;

  set joinees(value) {
    _joinees = value;
  }

  List<InviteJoinees> _joineList;

  Invite();

  get id => _id;

  List<InviteJoinees> getJoinees() {
   return _joineList;
  }

    void sid(value) {
      _id = value;
    }

    get title => _title;

    void setTitle(value) {
      _title = value;
    }

    get description => _description;

    void setDescription(value) {
      _description = value;
    }

    get category_id => _category_id;

    void setCategory_id(value) {
      _category_id = value;
    }

    get time => _time;

    void setTime(value) {
      _time = value;
    }

    get venue => _venue;

    void setVenue(value) {
      _venue = value;
    }

    get image => _image;

    void setImage(value) {
      _image = value;
    }

    get allowed_member_count => _allowed_member_count;

    void setAllowed_member_count(value) {
      _allowed_member_count = value;
    }

    get created_by => _created_by;

    void setCreated_by(value) {
      _created_by = value;
    }

    get created_date => _created_date;

    void setCreated_date(value) {
      _created_date = value;
    }

    get first_name => _first_name;

    void setFirst_name(value) {
      _first_name = value;
    }

    get joined => _joined;

    void setJoined(value) {
      _joined = value;
    }

    get joinee => _joinees;

    void setJoinees(value) {
      _joinees = value;
    }

    void setJoineList(List<InviteJoinees> jList){
      _joineList=jList;
    }

  getisJoined() { return _isJoined;}

  setisJoined(value) {
    _isJoined = value;
  }

}



class InviteJoinees{

  var _sg_id;
  var _name;
  var _designation;
  var _profile_img;

  get sg_id => _sg_id;
  get name => _name;
  get designation => _designation;
  get profile_img => _profile_img;

  setsg_id(value) {
    _sg_id = value;
  }

  setName(value) {
    _name = value;
  }

  setDesignation(value) {
    _designation = value;
  }

  setProfile_img(value) {
    _profile_img = value;
  }


}