class MutilCheckModel {
  String name;
  bool isChecked;

  MutilCheckModel(this.name, this.isChecked);

  @override
  String toString() {
    return name + "====" + isChecked.toString();
  }
}
