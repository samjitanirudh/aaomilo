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

  Invite();

  get id => _id;

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


}