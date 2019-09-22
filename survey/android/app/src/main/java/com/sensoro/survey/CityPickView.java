package com.sensoro.survey;

import android.content.Context;
import android.graphics.Color;
import android.view.View;

import com.bigkoo.pickerview.builder.OptionsPickerBuilder;
import com.bigkoo.pickerview.listener.OnDismissListener;
import com.bigkoo.pickerview.listener.OnOptionsSelectChangeListener;
import com.bigkoo.pickerview.listener.OnOptionsSelectListener;
import com.bigkoo.pickerview.view.OptionsPickerView;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


public class CityPickView  {
    CityPickViewSelectInterface cityPickViewSelectInterface;
     List proviceList = new ArrayList();
     List citysList = new ArrayList();
     List areaList = new ArrayList();

     int last1 = 0;
     int last2 = 0;
     int last3 = 0;

    OptionsPickerView pvOptions;
    public void showCitySelect(Context context,CityPickViewSelectInterface cityPickViewSelectInterface){
        DBHelper helper = new DBHelper(context,"selectCity",null,1);
        this.cityPickViewSelectInterface = cityPickViewSelectInterface;
        try {
            helper.createDataBase();
        } catch (IOException e) {
            e.printStackTrace();
        }


        List citys = helper.getcityList("000000");
        proviceList.addAll(citys);

        Map map = (Map) citys.get(0);

        String code = (String) map.get("code");

        List citys1 = helper.getcityList(code);
        citysList.addAll(citys1);


        Map citymap = (Map) citys1.get(0);

        String areaCode = (String) citymap.get("code");

        List citys2 = helper.getcityList(areaCode);
        areaList.addAll(citys1);


        OptionsPickerBuilder builder = new OptionsPickerBuilder(context, new OnOptionsSelectListener() {
            @Override
            public void onOptionsSelect(int options1, int option2, int options3 ,View v) {
                //返回的分别是三个级别的选中位置
//                String tx = options1Items.get(options1).getPickerViewText()
//                        + options2Items.get(options1).get(option2)
//                        + options3Items.get(options1).get(option2).get(options3).getPickerViewText();
//                tvOptions.setText(tx);

                List<HashMap> list = new ArrayList<>();

                HashMap map1 = new HashMap();

                Map mapo1 = (Map) CityPickView.this.proviceList.get(options1);


                map1.put("code",mapo1.get("code"));
                map1.put("name",mapo1.get("short_name"));


                HashMap map2 = new HashMap();

                if (CityPickView.this.citysList.size()>option2){
                    Map mapo2 = (Map) CityPickView.this.citysList.get(option2);


                    map2.put("code",mapo2.get("code"));
                    map2.put("name",mapo2.get("short_name"));

                }else {
                    map2.put("code","");
                    map2.put("name","");
                }
                HashMap map3 = new HashMap();

                if (CityPickView.this.areaList.size()>options3){
                    Map mapo3 = (Map) CityPickView.this.areaList.get(options3);


                    map3.put("code",mapo3.get("code"));
                    map3.put("name",mapo3.get("short_name"));

                }else {
                    map3.put("code","");
                    map3.put("name","");
                }


                list.add(map1);
                list.add(map2);
                list.add(map3);


                cityPickViewSelectInterface.saveAction(list);

            }

        }

        );

        builder.setOptionsSelectChangeListener(new OnOptionsSelectChangeListener() {
            @Override
            public void onOptionsSelectChanged(int options1, int options2, int options3) {

                if(last1 != options1){
                    Map map = (Map) citys.get(options1);

                    String code = (String) map.get("code");

                    List citys1 = helper.getcityList(code);
                    citysList.clear();
                    citysList.addAll(citys1);
                    areaList.clear();
                    if(citys1.size()>0){
                        Map citymap = (Map) citys1.get(0);

                        String areaCode = (String) citymap.get("code");

                        List citys2 = helper.getcityList(areaCode);
                        areaList.addAll(citys2);
                    }

                    CityPickView.this.pvOptions.setNPicker(getSelectString(proviceList), getSelectString(citysList), getSelectString(areaList));
                    CityPickView.this.pvOptions.setSelectOptions(options1,0,0);

                    last1 =  options1;
                    last2 = 0;
                    last3 = 0;
                }else if (options2!=last2){

                    Map citymap = (Map) citysList.get(options2);

                    String areaCode = (String) citymap.get("code");

                    List citys2 = helper.getcityList(areaCode);
                    areaList.clear();
                    areaList.addAll(citys2);

                    CityPickView.this.pvOptions.setNPicker(getSelectString(proviceList), getSelectString(citysList), getSelectString(areaList));
                    CityPickView.this.pvOptions.setSelectOptions(options1,options2,0);
                    last1 =  options1;
                    last2 = options2;
                    last3 = 0;
                }else {
                    last1 =  options1;
                    last2 = options2;
                    last3 = options3;
                }
            }
        });

        OptionsPickerView pvOptions =  builder .build();
        this.pvOptions =pvOptions;
        pvOptions.setOnDismissListener(new OnDismissListener() {
            @Override
            public void onDismiss(Object o) {
                cityPickViewSelectInterface.dismissAction();
            }
        });



        pvOptions.setNPicker(getSelectString(proviceList), getSelectString(citysList), getSelectString(areaList));
        pvOptions.show();
    }




    private List<String> getSelectString(List<Map> citysList){
        List<String> list = new ArrayList<>();
        for (int i = 0;i<citysList.size();i++){
            Map map = citysList.get(i);

            String s = (String) map.get("short_name");
            list.add(s);
        }

            return  list;
    }

}
