import 'package:flutter/material.dart';
import 'package:sensoro_survey/generated/customCalendar/lib/constants/constants.dart';
import 'package:sensoro_survey/generated/customCalendar/lib/controller.dart';
import 'package:sensoro_survey/generated/customCalendar/lib/model/date_model.dart';
import 'package:sensoro_survey/generated/customCalendar/lib/utils/date_util.dart';

/**
 * 月视图，显示整个月的日子
 */
class MonthView extends StatefulWidget {
  OnCalendarSelect onCalendarSelectListener;

  // Set<DateModel> selectedDateList; //被选中的日期
  List<DateModel> selectedDateList; //被选中的日期

  DateModel selectDateModel; //当前选择项,用于单选

  DayWidgetBuilder dayWidgetBuilder;

  OnMultiSelectOutOfRange multiSelectOutOfRange; //多选超出指定范围
  OnMultiSelectOutOfSize multiSelectOutOfSize; //多选超出限制个数

  int year;
  int month;
  int day;

  DateModel minSelectDate;
  DateModel maxSelectDate;

  int selectMode;
  int maxMultiSelectCount;

  Map<DateTime, Object> extraDataMap; //自定义额外的数据

  MonthView(
      {@required this.year,
      @required this.month,
      this.day,
      this.onCalendarSelectListener,
      this.dayWidgetBuilder,
      this.selectedDateList,
      this.selectDateModel,
      this.minSelectDate,
      this.maxSelectDate,
      this.selectMode,
      this.multiSelectOutOfSize,
      this.multiSelectOutOfRange,
      this.maxMultiSelectCount,
      this.extraDataMap});

  @override
  _MonthViewState createState() => _MonthViewState();
}

class _MonthViewState extends State<MonthView> {
  List<DateModel> items;

  int lineCount;

  double itemHeight;
  double totalHeight;
  double mainSpacing = 10;

  int year;
  int month;

  DateModel selectDateModel; //当前选择项,用于单选

  @override
  void initState() {
    super.initState();

    year = widget.year;
    month = widget.month;

    items = DateUtil.initCalendarForMonthView(
        year, month, DateTime.now(), DateTime.sunday,
        minSelectDate: widget.minSelectDate,
        maxSelectDate: widget.maxSelectDate,
        extraDataMap: widget.extraDataMap);

    lineCount = DateUtil.getMonthViewLineCount(year, month);

    selectDateModel = widget.selectDateModel;
  }

  @override
  Widget build(BuildContext context) {
    itemHeight = MediaQuery.of(context).size.width / 7;
    totalHeight = itemHeight * lineCount + mainSpacing * (lineCount - 1);

    return GestureDetector(
        onVerticalDragStart: (DragStartDetails detail) {
          print("onHorizontalDragStart:$detail");
        },
        child: Container(height: totalHeight, child: getView()));
  }

  Widget getView() {
    return new GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7, mainAxisSpacing: 10),
        itemCount: 7 * lineCount,
        itemBuilder: (context, index) {
          DateModel dateModel = items[index];
          //判断是否被选择
          if (widget.selectMode == Constants.MODE_MULTI_SELECT) {
            if (widget.selectedDateList.contains(dateModel)) {
              dateModel.isSelected = true;
            } else {
              dateModel.isSelected = false;
            }
          } else {
            if (selectDateModel == dateModel) {
              dateModel.isSelected = true;
            } else {
              dateModel.isSelected = false;
            }
          }

          return GestureDetector(
            onTap: () {
              //范围外不可点击
              if (!dateModel.isInRange) {
                //多选回调
                if (widget.selectMode == Constants.MODE_MULTI_SELECT) {
                  widget.multiSelectOutOfRange();
                }
                return;
              }

              //zyg修改
              if (widget.selectMode == Constants.MODE_MULTI_SELECT) {
                //多选，判断是否超过限制，超过范围
                if (widget.selectedDateList.length ==
                    widget.maxMultiSelectCount) {
                  widget.multiSelectOutOfSize();
                  return;
                }

                //多选也可以弄这些单选的代码
                selectDateModel = dateModel;
                widget.selectDateModel = dateModel;
                widget.onCalendarSelectListener(dateModel);
                setState(() {
                  //新的双选逻辑
                  if (widget.selectedDateList.length == 0) {
                    widget.selectedDateList.add(dateModel);
                  } else if (widget.selectedDateList.length == 1) {
                    if (widget.selectedDateList.contains(dateModel)) {
                      widget.selectedDateList.remove(dateModel);
                    } else {
                      DateModel model = widget.selectedDateList[0];
                      bool flag = false;
                      //新选的日期需要大于原有日期，否则替换
                      if (dateModel.year < model.year) {
                        flag = true;
                      }
                      if (dateModel.year == model.year &&
                          dateModel.month < model.month) {
                        flag = true;
                      }
                      if (dateModel.year == model.year &&
                          dateModel.month == model.month &&
                          dateModel.day < model.day) {
                        flag = true;
                      }
                      if (flag) {
                        widget.selectedDateList.removeAt(0);
                        widget.selectedDateList.add(dateModel);
                      } else {
                        int year = dateModel.year;
                        int month = dateModel.month;
                        int day = dateModel.day;
                        //不同年
                        if (dateModel.year == model.year + 1) {
                          for (int i = model.month; i <= 12; i++) {
                            if (i == model.month) {
                              for (int j = model.day + 1; j <= 31; j++) {
                                DateModel dateModel1 = new DateModel();
                                dateModel1.year = model.year;
                                dateModel1.month = i;
                                dateModel1.day = j;
                                widget.selectedDateList.add(dateModel1);
                              }
                            } else {
                              for (int j = 0; j <= 31; j++) {
                                DateModel dateModel1 = new DateModel();
                                dateModel1.year = model.year;
                                dateModel1.month = i;
                                dateModel1.day = j;
                                widget.selectedDateList.add(dateModel1);
                              }
                            }
                          }
                          for (int i = 1; i <= dateModel.month; i++) {
                            if (i == dateModel.month) {
                              for (int j = 1; j <= dateModel.day - 1; j++) {
                                DateModel dateModel1 = new DateModel();
                                dateModel1.year = dateModel.year;
                                dateModel1.month = i;
                                dateModel1.day = j;
                                widget.selectedDateList.add(dateModel1);
                              }
                            } else {
                              for (int j = 0; j <= 31; j++) {
                                DateModel dateModel1 = new DateModel();
                                dateModel1.year = dateModel.year;
                                dateModel1.month = i;
                                dateModel1.day = j;
                                widget.selectedDateList.add(dateModel1);
                              }
                            }
                          }
                        }

                        //不同月
                        if (dateModel.year == model.year &&
                            dateModel.month > model.month) {
                          for (int i = model.month; i <= dateModel.month; i++) {
                            if (i == model.month) {
                              for (int j = model.day + 1; j <= 31; j++) {
                                DateModel dateModel1 = new DateModel();
                                dateModel1.year = dateModel.year;
                                dateModel1.month = i;
                                dateModel1.day = j;
                                widget.selectedDateList.add(dateModel1);
                              }
                            } else if (i == dateModel.month) {
                              for (int j = 0; j <= dateModel.day - 1; j++) {
                                DateModel dateModel1 = new DateModel();
                                dateModel1.year = dateModel.year;
                                dateModel1.month = i;
                                dateModel1.day = j;
                                widget.selectedDateList.add(dateModel1);
                              }
                            } else {
                              for (int j = 0; j <= 31; j++) {
                                DateModel dateModel1 = new DateModel();
                                dateModel1.year = dateModel.year;
                                dateModel1.month = i;
                                dateModel1.day = j;
                                widget.selectedDateList.add(dateModel1);
                              }
                            }
                          }
                        }

                        //不同日
                        if (dateModel.year == model.year &&
                            dateModel.month == model.month &&
                            dateModel.day > model.day) {
                          for (int j = model.day + 1;
                              j <= dateModel.day - 1;
                              j++) {
                            DateModel dateModel1 = new DateModel();
                            dateModel1.year = dateModel.year;
                            dateModel1.month = dateModel.month;
                            dateModel1.day = j;
                            widget.selectedDateList.add(dateModel1);
                          }
                        }

                        widget.selectedDateList.add(dateModel);
                      }
                    }
                  }
                  //重新选择分段
                  else if (widget.selectedDateList.length > 1) {
                    widget.selectedDateList.clear();
                    widget.selectedDateList.add(dateModel);
                  }

                  //原有的多选逻辑
                  // if (widget.selectedDateList.contains(dateModel)) {
                  //   widget.selectedDateList.remove(dateModel);
                  // } else {
                  //   widget.selectedDateList.add(dateModel);
                  // }
                });
              } else {
                selectDateModel = dateModel;
                widget.selectDateModel = dateModel;
                widget.onCalendarSelectListener(dateModel);
                setState(() {});
              }
            },
            child: widget.dayWidgetBuilder(dateModel),
          );
        });
  }
}
