package com.sensoro.survey;



import android.app.Activity;
import android.app.ActivityOptions;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.os.Parcelable;
import android.view.Window;
import android.view.WindowManager;

import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.List;

public class SelectCityActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);

        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_FULLSCREEN);

        setContentView(R.layout.activity_select_city);
        translucentActivity(this);
        CityPickView cityPickView =   new  CityPickView();
        cityPickView.showCitySelect(SelectCityActivity.this, new CityPickViewSelectInterface() {
            @Override
            public void dismissAction() {
                finish();
            }

            @Override
            public void saveAction(List<HashMap> list) {

                Transmission.getInstance().list = list;
//                object.list = list;
                Intent intent =getIntent();


                setResult(RESULT_OK,intent);

                finish();
            }
        });
    }


    private void translucentActivity(Activity activity) {

        try {
            activity.getWindow().setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
            activity.getWindow().getDecorView().setBackground(null);
            Method activityOptions = Activity.class.getDeclaredMethod("getActivityOptions");
            activityOptions.setAccessible(true);
            Object options = activityOptions.invoke(activity);

            Class<?>[] classes = Activity.class.getDeclaredClasses();
            Class<?> aClass = null;
            for (Class clazz : classes) {
                if (clazz.getSimpleName().contains("TranslucentConversionListener")) {
                    aClass = clazz;
                }
            }
            Method method = Activity.class.getDeclaredMethod("convertToTranslucent",
                    aClass, ActivityOptions.class);
            method.setAccessible(true);
            method.invoke(activity, null, options);
        } catch (Throwable t) {
            t.printStackTrace();
        }
    }

}
