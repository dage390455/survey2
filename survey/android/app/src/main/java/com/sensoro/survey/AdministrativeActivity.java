package com.sensoro.survey;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.amap.api.location.AMapLocation;
import com.amap.api.location.AMapLocationClient;
import com.amap.api.location.AMapLocationClientOption;
import com.amap.api.location.AMapLocationListener;
import com.amap.api.maps.AMap;
import com.amap.api.maps.CameraUpdate;
import com.amap.api.maps.CameraUpdateFactory;
import com.amap.api.maps.CoordinateConverter;
import com.amap.api.maps.TextureMapView;
import com.amap.api.maps.model.BitmapDescriptor;
import com.amap.api.maps.model.BitmapDescriptorFactory;
import com.amap.api.maps.model.CameraPosition;
import com.amap.api.maps.model.LatLng;
import com.amap.api.maps.model.Marker;
import com.amap.api.maps.model.MarkerOptions;
import com.amap.api.services.core.LatLonPoint;
import com.amap.api.services.geocoder.GeocodeAddress;
import com.amap.api.services.geocoder.GeocodeQuery;
import com.amap.api.services.geocoder.GeocodeResult;
import com.amap.api.services.geocoder.GeocodeSearch;
import com.amap.api.services.geocoder.RegeocodeAddress;
import com.amap.api.services.geocoder.RegeocodeQuery;
import com.amap.api.services.geocoder.RegeocodeResult;
import com.amap.api.services.geocoder.RegeocodeRoad;
import com.amap.api.services.geocoder.StreetNumber;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

public class AdministrativeActivity extends Activity implements AMap.OnCameraChangeListener, AMap.OnMarkerClickListener, AMap.OnMapLoadedListener, AMap.InfoWindowAdapter, GeocodeSearch.OnGeocodeSearchListener, AMapLocationListener {
    ImageView includeTextTitleImvArrowsLeft;
    TextView includeTextTitleTvTitle;
    TextView includeTextTitleTvSubtitle;
    TextureMapView tmDeployMap;
    ImageView ivDeployMapLocation;

    private Activity mActivity = this;
    private AMap aMap;
    private Marker deviceMarker;
    private GeocodeSearch geocoderSearch;
    private Handler mHandler = new Handler(Looper.getMainLooper());
    private Marker locationMarker;
    public AMapLocationClient mLocationClient;

    private TextView administrativeAreasTv;
    private int isReadOnly = 0;

    private double lan = 0;
    private double log = 0;
    private PickerViewUtil pickerViewUtil;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_areas_map);
        mActivity = this;
        setTheme(R.style.MyTheme);
        //取消bar
//        ActionBar supportActionBar = mActivity.getSupportActionBar();
//        if (supportActionBar != null) {
//            supportActionBar.hide();
//        }


        if (!TextUtils.isEmpty(getIntent().getStringExtra("isReadOnly"))) {
            isReadOnly = Integer.parseInt(getIntent().getStringExtra("isReadOnly"));
            if (!TextUtils.isEmpty(getIntent().getStringExtra("lan"))) {
                lan = Double.parseDouble(getIntent().getStringExtra("lan"));
            }
            if (!TextUtils.isEmpty(getIntent().getStringExtra("log"))) {
                log = Double.parseDouble(getIntent().getStringExtra("log"));
            }
        }
        iniView();
        locate();

        tmDeployMap.onCreate(savedInstanceState);

        Log.d("=====", sHA1(mActivity));
    }

    private void iniView() {
        administrativeAreasTv = findViewById(R.id.administrative_areas_tv);
        ivDeployMapLocation = findViewById(R.id.iv_deploy_map_location);
        includeTextTitleTvSubtitle = findViewById(R.id.include_text_title_tv_subtitle);
        includeTextTitleTvTitle = findViewById(R.id.include_text_title_tv_title);
        includeTextTitleImvArrowsLeft = findViewById(R.id.include_text_title_imv_arrows_left);
        tmDeployMap = findViewById(R.id.tm_deploy_map);
        includeTextTitleTvTitle.setText("定位位置");


        if (isReadOnly == 0) {
            includeTextTitleTvSubtitle.setVisibility(View.VISIBLE);

            includeTextTitleTvSubtitle.setText("保存");

        }


        includeTextTitleTvSubtitle.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                LatLng position = deviceMarker.getPosition();

                CoordinateConverter converter = new CoordinateConverter(AdministrativeActivity.this);
                converter.from(CoordinateConverter.CoordType.BAIDU);
                converter.coord(position);
                LatLng desLatLng = converter.convert();
                if (null != position) {
                    String title = deviceMarker.getTitle();
                    Intent intent = new Intent();


                    intent.putExtra("title", title);
                    intent.putExtra("latitude", position.latitude);
                    intent.putExtra("longitude", position.longitude);
                    setResult(RESULT_OK, intent);
                    finish();
                }


            }
        });


        ivDeployMapLocation.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                backToCurrentLocation();
            }
        });

        findViewById(R.id.include_text_title_imv_arrows_left).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });

        pickerViewUtil = new PickerViewUtil();


        geocoderSearch = new GeocodeSearch(mActivity);
        geocoderSearch.setOnGeocodeSearchListener(this);
        initMap(tmDeployMap.getMap());
    }

    private void locate() {
        mLocationClient = new AMapLocationClient(this);
        //设置定位回调监听
        mLocationClient.setLocationListener(this);
        //初始化定位参数
        AMapLocationClientOption mLocationOption = new AMapLocationClientOption();
        //设置定位模式为Hight_Accuracy高精度模式，Battery_Saving为低功耗模式，Device_Sensors是仅设备模式
        mLocationOption.setLocationMode(AMapLocationClientOption.AMapLocationMode.Hight_Accuracy);
        //设置是否返回地址信息（默认返回地址信息）
        mLocationOption.setNeedAddress(true);
        //设置是否允许模拟位置,默认为false，不允许模拟位置
        mLocationOption.setMockEnable(false);
        //设置定位间隔,单位毫秒,默认为2000ms
        mLocationOption.setInterval(2000);
        mLocationOption.setHttpTimeOut(20000);
        //给定位客户端对象设置定位参数
        mLocationClient.setLocationOption(mLocationOption);
        //启动定位
        mLocationClient.startLocation();
    }

    @Override
    public void onLocationChanged(AMapLocation aMapLocation) {
        if (aMapLocation != null) {
            if (aMapLocation.getErrorCode() == 0) {
                //可在其中解析amapLocation获取相应内容。
                double lat = aMapLocation.getLatitude();//获取纬度
                double lon = aMapLocation.getLongitude();//获取经度
//            mStartPosition = new LatLng(lat, lon);
                try {
                    Log.d("定位信息", "定位信息------->lat = " + lat + ",lon = =" + lon);
                } catch (Throwable throwable) {
                    throwable.printStackTrace();
                }
            } else {
                //定位失败时，可通过ErrCode（错误码）信息来确定失败的原因，errInfo是错误信息，详见错误码表。
                Log.e("地图错误", "定位失败, 错误码:" + aMapLocation.getErrorCode() + ", 错误信息:"
                        + aMapLocation.getErrorInfo());
            }

        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        tmDeployMap.onDestroy();
        mHandler.removeCallbacksAndMessages(null);
        mLocationClient.onDestroy();


    }

    @Override
    public void onLowMemory() {
        super.onLowMemory();
        tmDeployMap.onLowMemory();
    }

    /**
     * 方法必须重写
     */
    @Override
    public void onResume() {
        super.onResume();
        tmDeployMap.onResume();
    }

    /**
     * 方法必须重写
     */
    @Override
    public void onPause() {
        super.onPause();
        tmDeployMap.onPause();
    }

    /**
     * 方法必须重写
     */
    @Override
    public void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);
        tmDeployMap.onSaveInstanceState(outState);
    }

    private void setMarkerAddress(RegeocodeAddress regeocodeAddress) {
        StringBuilder stringBuilder = new StringBuilder();
        //
        String province = regeocodeAddress.getProvince();
        String city = regeocodeAddress.getCity();
        //
        String district = regeocodeAddress.getDistrict();// 区或县或县级市


        StringBuffer stringBuffer = new StringBuffer();

        stringBuffer.append(province).append(" ").append(city).append(" ").append(district);


        administrativeAreasTv.setText(stringBuffer.toString());
//        administrativeAreasTv.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//
//
//                pickerViewUtil.showPickerView(AdministrativeActivity.this, administrativeAreasTv.getText().toString());
//                pickerViewUtil.setOnPickerViewResListener(new PickerViewUtil.OnPickerViewResListener() {
//                    @Override
//                    public void onSelectedRes(String res) {
//                        administrativeAreasTv.setText(res);
//
//                        // TODO: 2019-09-17 移动地图
//
//                        GeocodeSearch geocodeSearch = new GeocodeSearch(AdministrativeActivity.this);
//                        geocodeSearch.setOnGeocodeSearchListener(new GeocodeSearch.OnGeocodeSearchListener() {
//                            @Override
//                            public void onRegeocodeSearched(RegeocodeResult regeocodeResult, int i) {
//
//                            }
//
//                            @Override
//                            public void onGeocodeSearched(GeocodeResult geocodeResult, int i) {
//
//                                if (i == 1000) {
//                                    if (geocodeResult != null && geocodeResult.getGeocodeAddressList() != null &&
//
//                                            geocodeResult.getGeocodeAddressList().size() > 0) {
//                                        GeocodeAddress geocodeAddress = geocodeResult.getGeocodeAddressList().get(0);
//
//                                        double latitude = geocodeAddress.getLatLonPoint().getLatitude();//纬度
//
//                                        double longititude = geocodeAddress.getLatLonPoint().getLongitude();//经度
//
//
//                                        LatLng latLng = new LatLng(latitude, longititude);
//                                        //可视化区域，将指定位置指定到屏幕中心位置
//                                        CameraUpdate update = CameraUpdateFactory
//                                                .newCameraPosition(new CameraPosition(latLng, 15, 0, 0));
//                                        aMap.moveCamera(update);
//                                        if (locationMarker != null) {
//                                            locationMarker.setPosition(latLng);
//                                        }
//
//                                    } else {
//
//                                        Toast.makeText(AdministrativeActivity.this, "地名出错", Toast.LENGTH_SHORT).show();
//
//
//                                    }
//
//                                }
//                            }
//                        });
//
//                        GeocodeQuery geocodeQuery = new GeocodeQuery(res, "29");
//                        geocodeSearch.getFromLocationNameAsyn(geocodeQuery);
//
//
//                    }
//                });
//
//            }
//        });
        //
        //
        String township = regeocodeAddress.getTownship();// 乡镇
        //
        String streetName = null;// 道路
        List<RegeocodeRoad> regeocodeRoads = regeocodeAddress.getRoads();// 道路列表
        if (regeocodeRoads != null && regeocodeRoads.size() > 0) {
            RegeocodeRoad regeocodeRoad = regeocodeRoads.get(0);
            if (regeocodeRoad != null) {
                streetName = regeocodeRoad.getName();
            }
        }
        //
        String streetNumber = null;// 门牌号
        StreetNumber number = regeocodeAddress.getStreetNumber();
        if (number != null) {
            String street = number.getStreet();
            if (street != null) {
                streetNumber = street + number.getNumber();
            } else {
                streetNumber = number.getNumber();
            }
        }
        //
        String building = regeocodeAddress.getBuilding();// 标志性建筑,当道路为null时显示
        //省
        if (!TextUtils.isEmpty(province)) {
            stringBuilder.append(province);
        }
        //市
        if (!TextUtils.isEmpty(city)) {
            if (!city.contains(province)) {
                stringBuilder.append(city);
            }
        }
        //区县
        if (!TextUtils.isEmpty(district)) {
            stringBuilder.append(district);
        }
        //乡镇
        if (!TextUtils.isEmpty(township)) {
            stringBuilder.append(township);
        }
        //道路
        if (!TextUtils.isEmpty(streetName)) {
            stringBuilder.append(streetName);
        }
        //标志性建筑
        if (!TextUtils.isEmpty(building)) {
            stringBuilder.append(building);
        } else {
            //门牌号
            if (!TextUtils.isEmpty(streetNumber)) {
                stringBuilder.append(streetNumber);
            }
        }
        String address;
        if (TextUtils.isEmpty(stringBuilder)) {
            address = township;
        } else {
            address = stringBuilder.append("附近").toString();
        }
        if (TextUtils.isEmpty(address)) {
            deviceMarker.hideInfoWindow();
        } else {
            deviceMarker.setTitle(address);
            mHandler.post(new Runnable() {
                @Override
                public void run() {
                    deviceMarker.showInfoWindow();
                }
            });
        }
        //
    }


    public void initMap(AMap map) {
        this.aMap = map;
//        setMapCustomStyleFile();
        aMap.getUiSettings().setTiltGesturesEnabled(false);
        aMap.getUiSettings().setZoomControlsEnabled(false);
        aMap.getUiSettings().setMyLocationButtonEnabled(false);
        aMap.getUiSettings().setLogoBottomMargin(-50);
//        aMap.setMyLocationEnabled(false);
//        aMap.setMapCustomEnable(true);
//        String styleName = "custom_config.data";
//        aMap.setCustomMapStylePath(mContext.getFilesDir().getAbsolutePath() + "/" + styleName);
        aMap.setOnMapLoadedListener(this);
        aMap.setOnMarkerClickListener(this);
        aMap.setInfoWindowAdapter(this);

        if (isReadOnly == 0) {
            aMap.setOnCameraChangeListener(this);
        }

//        aMap.setOnMapTouchListener(this);
    }


    @Override
    public void onCameraChange(CameraPosition cameraPosition) {
        //解决不能回显的bug 不能直接赋值
        deviceMarker.setPosition(cameraPosition.target);
        System.out.println("====>onCameraChange=>" + cameraPosition.target.latitude + "=====" + cameraPosition.target.longitude);
    }

    @Override
    public void onCameraChangeFinish(CameraPosition cameraPosition) {
        if (cameraPosition != null) {
            //
            LatLonPoint lp = new LatLonPoint(cameraPosition.target.latitude, cameraPosition.target.longitude);
            RegeocodeQuery query = new RegeocodeQuery(lp, 200, GeocodeSearch.AMAP);
            System.out.println("====>onCameraChangeFinish=>" + lp.getLatitude() + "=====" + lp.getLongitude());
//                    deviceMarker.setPosition(cameraPosition.target);
            geocoderSearch.getFromLocationAsyn(query);
        }


    }

    @Override
    public boolean onMarkerClick(Marker marker) {
        return false;
    }

    @Override
    public void onMapLoaded() {
        //
        MarkerOptions locationOption = new MarkerOptions().icon(BitmapDescriptorFactory.fromResource(R.mipmap.deploy_map_location))
                .anchor(0.5f, 0.6f)
                .draggable(false);
        locationMarker = aMap.addMarker(locationOption);
        AMapLocation lastKnownLocation = mLocationClient.getLastKnownLocation();

        BitmapDescriptor bitmapDescriptor = BitmapDescriptorFactory.fromResource(R.mipmap.deploy_map_cur);
        MarkerOptions markerOption = new MarkerOptions().icon(bitmapDescriptor)
                .anchor(0.5f, 1)
                .draggable(true);
        deviceMarker = aMap.addMarker(markerOption);
        if (lan > 0) {
            double lat = lastKnownLocation.getLatitude();//获取纬度
            double lon = lastKnownLocation.getLongitude();//获取经度
//
            CameraUpdate update;
            update = CameraUpdateFactory
                    .newCameraPosition(new CameraPosition(new LatLng(lan, log), 15, 0, 0));
            aMap.moveCamera(update);
            if (locationMarker != null) {
                locationMarker.setPosition(new LatLng(lat, lon));
            }
            deviceMarker.setPosition(new LatLng(lan, log));

            LatLonPoint lp = new LatLonPoint(lan, log);
            RegeocodeQuery query = new RegeocodeQuery(lp, 200, GeocodeSearch.AMAP);
            System.out.println("====>onCameraChangeFinish=>" + lp.getLatitude() + "=====" + lp.getLongitude());
//                    deviceMarker.setPosition(cameraPosition.target);
            geocoderSearch.getFromLocationAsyn(query);
        } else {
            if (lastKnownLocation != null) {
                double lat = lastKnownLocation.getLatitude();//获取纬度
                double lon = lastKnownLocation.getLongitude();//获取经度
                locationMarker.setPosition(new LatLng(lat, lon));
                backToCurrentLocation();
            }

        }

        //加载完地图之后添加监听防止位置错乱
//        if (deployAnalyzerModel.latLng.size() == 2) {
////可视化区域，将指定位置指定到屏幕中心位置
//            LatLng latLng = new LatLng(deployAnalyzerModel.latLng.get(1), deployAnalyzerModel.latLng.get(0));
//            CameraUpdate update = CameraUpdateFactory
//                    .newCameraPosition(new CameraPosition(latLng, 15, 0, 0));
//            aMap.moveCamera(update);
//            deviceMarker.setPosition(latLng);
//            LatLonPoint lp = new LatLonPoint(latLng.latitude, latLng.longitude);
//            RegeocodeQuery query = new RegeocodeQuery(lp, 200, GeocodeSearch.AMAP);
//            geocoderSearch.getFromLocationAsyn(query);
//        } else {
//        backToCurrentLocation();
//        }

    }

    @Override
    public void onRegeocodeSearched(RegeocodeResult result, int i) {
        System.out.println("====>onRegeocodeSearched");
        try {
            if (i == 1000) {
                RegeocodeAddress regeocodeAddress = result.getRegeocodeAddress();
                setMarkerAddress(regeocodeAddress);
            }
//            updateAddressInfo(result, i);
            //
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    @Override
    public void onGeocodeSearched(GeocodeResult geocodeResult, int i) {

    }


    @Override
    public View getInfoWindow(Marker marker) {
        View view = mActivity.getLayoutInflater().inflate(R.layout.layout_marker, null);
        TextView info = (TextView) view.findViewById(R.id.marker_info);
        info.setText(marker.getTitle());
        return view;
    }

    @Override
    public View getInfoContents(Marker marker) {
        return null;
    }

    public void backToCurrentLocation() {
        if (aMap != null && deviceMarker != null) {
            LatLng latLng;
            CameraUpdate update;
            AMapLocation lastKnownLocation = mLocationClient.getLastKnownLocation();
            if (lastKnownLocation != null) {
                double lat = lastKnownLocation.getLatitude();//获取纬度
                double lon = lastKnownLocation.getLongitude();//获取经度
                latLng = new LatLng(lat, lon);
                //可视化区域，将指定位置指定到屏幕中心位置
                update = CameraUpdateFactory
                        .newCameraPosition(new CameraPosition(latLng, 15, 0, 0));
                aMap.moveCamera(update);
                if (locationMarker != null) {
                    locationMarker.setPosition(latLng);
                }

                if (isReadOnly == 0) {
                    deviceMarker.setPosition(latLng);
                }


            }
        }

    }

    public static String sHA1(Context context) {
        try {
            PackageInfo info = context.getPackageManager().getPackageInfo(
                    context.getPackageName(), PackageManager.GET_SIGNATURES);
            byte[] cert = info.signatures[0].toByteArray();
            MessageDigest md = MessageDigest.getInstance("SHA1");
            byte[] publicKey = md.digest(cert);
            StringBuffer hexString = new StringBuffer();
            for (int i = 0; i < publicKey.length; i++) {
                String appendString = Integer.toHexString(0xFF & publicKey[i])
                        .toUpperCase(Locale.US);
                if (appendString.length() == 1)
                    hexString.append("0");
                hexString.append(appendString);
                hexString.append(":");
            }
            String result = hexString.toString();
            return result.substring(0, result.length() - 1);
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
        return null;
    }

}


