package com.example.smartcity;

import android.app.Activity;
import android.content.Context;
import android.graphics.Point;
import android.location.Location;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.animation.Interpolator;
import android.widget.TextView;

import com.amap.api.location.AMapLocation;
import com.amap.api.location.AMapLocationClient;
import com.amap.api.location.AMapLocationClientOption;
import com.amap.api.location.AMapLocationListener;
import com.amap.api.maps.AMap;
import com.amap.api.maps.AMapOptions;
import com.amap.api.maps.CameraUpdate;
import com.amap.api.maps.CameraUpdateFactory;
import com.amap.api.maps.MapView;
import com.amap.api.maps.model.BitmapDescriptorFactory;
import com.amap.api.maps.model.CameraPosition;
import com.amap.api.maps.model.LatLng;
import com.amap.api.maps.model.Marker;
import com.amap.api.maps.model.MarkerOptions;
import com.amap.api.maps.model.MyLocationStyle;
import com.amap.api.maps.model.VisibleRegion;
import com.amap.api.maps.model.animation.Animation;
import com.amap.api.maps.model.animation.TranslateAnimation;
import com.amap.api.services.core.AMapException;
import com.amap.api.services.core.LatLonPoint;
import com.amap.api.services.core.PoiItem;
import com.amap.api.services.core.SuggestionCity;
import com.amap.api.services.geocoder.GeocodeResult;
import com.amap.api.services.geocoder.GeocodeSearch;
import com.amap.api.services.geocoder.RegeocodeAddress;
import com.amap.api.services.geocoder.RegeocodeQuery;
import com.amap.api.services.geocoder.RegeocodeResult;
import com.amap.api.services.poisearch.PoiResult;
import com.amap.api.services.poisearch.PoiSearch;

import java.util.List;

import static com.tekartik.sqflite.Constant.TAG;

public class LocationEdtitActivtiy extends Activity implements AMap.OnMyLocationChangeListener, GeocodeSearch.OnGeocodeSearchListener, PoiSearch.OnPoiSearchListener{
    MapView mapView = null;
    protected Bundle mSavedInstanceState;

    private TextView cancel;
    private TextView sure;
    private AMap aMap;
    public AMapLocationClient mLocationClient = null;
    private AMapLocationClientOption mLocationOption;
    //屏幕中间的mark
    private Marker screenMarker;
    private double longitude;
    private double latitude;
    //逆地理编码（坐标转地址）
    private GeocodeSearch geocoderSearch;


    private double tempLatitude;
    private double tempLongitude;
    public Bundle getSavedInstanceState() {
        return mSavedInstanceState;
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_location_edtit_activtiy);
        mapView = (MapView) findViewById(R.id.map);
        //在activity执行onCreate时执行mMapView.onCreate(savedInstanceState)，创建地图
        mapView.onCreate(savedInstanceState);
        Bundle saved = getSavedInstanceState();
        mapView.onCreate(saved);
        cancel = findViewById(R.id.cancel);
        cancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });

        sure = findViewById(R.id.sure);
        sure.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });

        init();
    }




    private void init() {

        if (aMap == null) {
            aMap = mapView.getMap();
//            addMarkersToMap();// 往地图上添加marker


            MyLocationStyle myLocationStyle = new MyLocationStyle();
//            myLocationStyle.myLocationIcon();
            myLocationStyle.myLocationType(MyLocationStyle.LOCATION_TYPE_LOCATE);//定位一次，且将视角移动到地图中心点。
//            myLocationStyle.interval(2000); //设置连续定位模式下的定位间隔，只在连续定位模式下生效，单次定位模式下不会生效。单位为毫秒。
            aMap.setMyLocationStyle(myLocationStyle);//设置定位蓝点的Style
            aMap.getUiSettings().setMyLocationButtonEnabled(true);  //设置默认定位按钮是否显示，非必需设置。

            aMap.getUiSettings().setZoomPosition(AMapOptions.ZOOM_POSITION_RIGHT_BUTTOM);

            aMap.setMyLocationEnabled(true);// 设置为true表示启动显示定位蓝点，false表示隐藏定位蓝点并不进行定位，默认是false。



            // 绑定 Marker 被点击事件
//            aMap.setOnMarkerClickListener(markerClickListener);


            aMap.setOnMapLoadedListener(new AMap.OnMapLoadedListener() {
                @Override
                public void onMapLoaded() {
//                    addMarkersToMap();// 往地图上添加marker
                }
            });



        }



        mLocationClient = new AMapLocationClient(getApplicationContext());

        //初始化AMapLocationClientOption对象
        mLocationOption = new AMapLocationClientOption();
        //设置定位回调监听
        mLocationClient.setLocationListener(mLocationListener);

        //设置定位模式为AMapLocationMode.Hight_Accuracy，高精度模式。
        mLocationOption.setLocationMode(AMapLocationClientOption.AMapLocationMode.Hight_Accuracy);
        //设置定位间隔,单位毫秒,默认为2000ms，最低1000ms。
        //五分钟定位一次
//        mLocationOption.setInterval(1000*60*5);

        //该方法默认为false。
        // 获取一次定位结果：  该方法默认为false。
        mLocationOption.setOnceLocation(true);
        //给定位客户端对象设置定位参数
        mLocationClient.setLocationOption(mLocationOption);



        //启动定位
        mLocationClient.startLocation();


        aMap.setOnCameraChangeListener(new AMap.OnCameraChangeListener() {
            @Override
            public void onCameraChange(CameraPosition cameraPosition) {

            }

            @Override
            public void onCameraChangeFinish(CameraPosition cameraPosition) {


                //屏幕中心的Marker跳动
                startJumpAnimation();

//                textCurrentLevel.setText("当前地图的缩放级别为: " + cameraPosition.zoom);
                Log.e(TAG, "onCameraChangeFinish:" + cameraPosition.toString());
                VisibleRegion visibleRegion = aMap.getProjection().getVisibleRegion(); // 获取可视区域、

                LatLng target = cameraPosition.target;
                tempLatitude = target.latitude;
                tempLongitude = target.longitude;



                LatLng center = new LatLng(tempLatitude, tempLongitude);// 北京市经纬度


                Log.e(TAG,"onCameraChangeFinish");


                LatLonPoint latLonPoint = new LatLonPoint(tempLatitude, tempLongitude);

                doRegeocodeQuery(latLonPoint);


            }
        });


        //地理编码部分
        geocoderSearch = new GeocodeSearch(this);
        geocoderSearch.setOnGeocodeSearchListener(this);


    }


    /**
     * 开始进行逆地理编码 查询
     * 根据地理位置查询 具体位置 和拼装当前位置
     */
    protected void doRegeocodeQuery(LatLonPoint lp) {


        Log.e(TAG,"开始进行逆地理编码 查询");


        // 第一个参数表示一个Latlng，第二参数表示范围多少米，第三个参数表示是火系坐标系还是GPS原生坐标系
        RegeocodeQuery query = new RegeocodeQuery(lp, 1000, GeocodeSearch.AMAP);

        geocoderSearch.getFromLocationAsyn(query);


    }


    public void startJumpAnimation() {

        if (screenMarker != null) {
            //根据屏幕距离计算需要移动的目标点
            final LatLng latLng = screenMarker.getPosition();
            Point point = aMap.getProjection().toScreenLocation(latLng);
            point.y -= dip2px(this, 125);
            LatLng target = aMap.getProjection()
                    .fromScreenLocation(point);
            //使用TranslateAnimation,填写一个需要移动的目标点
            Animation animation = new TranslateAnimation(target);
            animation.setInterpolator(new Interpolator() {
                @Override
                public float getInterpolation(float input) {
                    // 模拟重加速度的interpolator
                    if (input <= 0.5) {
                        return (float) (0.5f - 2 * (0.5 - input) * (0.5 - input));
                    } else {
                        return (float) (0.5f - Math.sqrt((input - 0.5f) * (1.5f - input)));
                    }
                }
            });
            //整个移动所需要的时间
            animation.setDuration(600);
            //设置动画
            screenMarker.setAnimation(animation);
            //开始动画
            screenMarker.startAnimation();

        } else {
            Log.e("amap", "screenMarker is null");
        }
    }
    //dip和px转换
    private static int dip2px(Context context, float dpValue) {
        final float scale = context.getResources().getDisplayMetrics().density;
        return (int) (dpValue * scale + 0.5f);
    }


    //声明定位回调监听器
    public AMapLocationListener mLocationListener = new AMapLocationListener() {
        @Override
        public void onLocationChanged(AMapLocation aMapLocation) {

            if (aMapLocation != null) {
                if (aMapLocation.getErrorCode() == 0) {

                    mLocationClient.stopLocation();

                    //可在其中解析amapLocation获取相应内容。
                    longitude = aMapLocation.getLongitude();
                    latitude = aMapLocation.getLatitude();

//                    cityName = aMapLocation.getCity();
//                    switchCityTv.setText(cityName+"");


                    LatLonPoint latLonPoint = new LatLonPoint(latitude, longitude);
                    doRegeocodeQuery(latLonPoint);

                    // 显示系统小蓝点
//                    mLocationListener.onLocationChanged(aMapLocation);


//                    String poiName = aMapLocation.getPoiName();
//                    String province = aMapLocation.getProvince();
//                    String city = aMapLocation.getCity();
//                    String district = aMapLocation.getDistrict();
//                    //北京市朝阳区来广营西路8号 靠近国创产业园
//                    String address = aMapLocation.getAddress();
//                    //北京国盛汽车销售有限公司
//                    String aoiName = aMapLocation.getAoiName();
//                    //来广营西路
//                    String road = aMapLocation.getStreet();
//                    //8号
//                    String streetNum = aMapLocation.getStreetNum();
//
//                    //国创产业园附近
//                    String description = aMapLocation.getDescription();


                    Log.e(TAG,"定位回调===longitude="+longitude+"latitude=="+latitude);

//                    ToastUtil.showShort(getContext(),"longitude="+longitude+"latitude=="+latitude);

                } else {
                    //定位失败时，可通过ErrCode（错误码）信息来确定失败的原因，errInfo是错误信息，详见错误码表。
                    Log.e("AmapError", "location Error, ErrCode:"
                            + aMapLocation.getErrorCode() + ", errInfo:"
                            + aMapLocation.getErrorInfo());
                }
            }

        }
    };






    @Override
    protected void onDestroy() {
        super.onDestroy();
        //在activity执行onDestroy时执行mMapView.onDestroy()，销毁地图
        mapView.onDestroy();
    }
    @Override
    protected void onResume() {
        super.onResume();
        //在activity执行onResume时执行mMapView.onResume ()，重新绘制加载地图
        mapView.onResume();
    }
    @Override
    protected void onPause() {
        super.onPause();
        //在activity执行onPause时执行mMapView.onPause ()，暂停地图的绘制
        mapView.onPause();
    }
    @Override
    protected void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);
        //在activity执行onSaveInstanceState时执行mMapView.onSaveInstanceState (outState)，保存地图当前的状态
        mapView.onSaveInstanceState(outState);
    }

    @Override
    public void onMyLocationChange(Location location) {
        double longitude = location.getLongitude();
        double latitude = location.getLatitude();


    }

    @Override
    public void onRegeocodeSearched(RegeocodeResult result, int rCode) {
        RegeocodeQuery regeocodeQuery = result.getRegeocodeQuery();

        LatLonPoint point = regeocodeQuery.getPoint();

        double latitude = point.getLatitude();
        double longitude = point.getLongitude();
        Log.e(TAG, "逆地理编码 +latitudet=" + latitude + "longitude=" + longitude);

        Log.e(TAG, "逆地理编码 +regeocodeResult=" + result.toString());


        if (rCode == AMapException.CODE_AMAP_SUCCESS) {
            if (result != null && result.getRegeocodeAddress() != null && result.getRegeocodeAddress().getFormatAddress() != null) {

                String addressName = result.getRegeocodeAddress().getFormatAddress()
                        + "附近";

                RegeocodeAddress regeocodeAddress = result.getRegeocodeAddress();

                List<PoiItem> poiItems = regeocodeAddress.getPois();
                String province = regeocodeAddress.getProvince();
                String city = regeocodeAddress.getCity();



//                ToastUtil.show(getContext(), addressName);
            } else {
//                ToastUtil.show(getContext(),"对不起，没有搜索到相关数据！");
            }
        } else {
//            ToastUtil.show(getContext(), rCode);
        }


    }

    @Override
    public void onGeocodeSearched(GeocodeResult geocodeResult, int i) {

    }

    @Override
    public void onPoiSearched(PoiResult result, int rcode) {


        if (rcode == AMapException.CODE_AMAP_SUCCESS) {
            if (result != null && result.getQuery() != null) {// 搜索poi的结果
//                if (result.getQuery().equals(query)) {// 是否是同一条
                    PoiResult poiResult = result;




                    //poi数据
                    List<PoiItem> poiItems = poiResult.getPois();// 取得第一页的poiitem数据，页数从数字0开始
                    List<SuggestionCity> suggestionCities = poiResult
                            .getSearchSuggestionCitys();// 当搜索不到poiitem数据时，会返回含有搜索关键字的城市信息
                    if (poiItems != null && poiItems.size() > 0) {






                        if (poiItems.size()>=1) {

                            PoiItem poiItem = poiItems.get(0);
                            String adCode = poiItem.getAdCode();
                            LatLonPoint latLonPoint = poiItem.getLatLonPoint();



                            LatLng pointCenter = new LatLng(latLonPoint.getLatitude(), latLonPoint.getLongitude());
                            //滚动到某个位置
                            moveToPoint(pointCenter);



                        }






//                        supplierMapAdapter.notifyDataSetChanged();


//                    } else if (suggestionCities != null && suggestionCities.size() > 0) {
////                        showSuggestCity(suggestionCities);
//                    } else {
//                        ToastUtil.show(getContext(), "暂无结果");
//                    }
                }
            } else {
//                ToastUtil.show(getContext(), "暂无结果");
            }
        } else {
//            ToastUtil.show(getContext(),rcode + "");
        }
    }

    @Override
    public void onPoiItemSearched(PoiItem poiItem, int i) {

    }


    /**
     * 滚动到莫个点
     */
    private void moveToPoint( LatLng pointCenter ) {


        CameraUpdate cameraUpdate = CameraUpdateFactory.newCameraPosition(new CameraPosition(pointCenter, 18, 30, 30));
        aMap.moveCamera(cameraUpdate);
        aMap.clear();


        addMarkersToMap();


//        Point screenPosition = aMap.getProjection().toScreenLocation(pointCenter);
//        screenMarker = aMap.addMarker(new MarkerOptions()
//                .anchor(0.5f, 0.5f)
//                .icon(BitmapDescriptorFactory.fromResource(R.drawable.purple_pin)));
//        //设置Marker在屏幕上,不跟随地图移动
//        screenMarker.setPositionByPixels(screenPosition.x, screenPosition.y);

//                            aMap.addMarker(new MarkerOptions().position(pointCenter)
//                                    .icon(BitmapDescriptorFactory
//                                            .defaultMarker(BitmapDescriptorFactory.HUE_RED)));



    }


    private void addMarkersToMap() {

        addMarkerInScreenCenter();

//        addGrowMarker();
    }


    private void addMarkerInScreenCenter() {
        LatLng latLng = aMap.getCameraPosition().target;
        Point screenPosition = aMap.getProjection().toScreenLocation(latLng);
        screenMarker = aMap.addMarker(new MarkerOptions()
                .anchor(0.5f, 0.5f)
                .icon(BitmapDescriptorFactory.fromResource(R.mipmap.annotation)));
        //设置Marker在屏幕上,不跟随地图移动
        screenMarker.setPositionByPixels(screenPosition.x, screenPosition.y);

    }




}


