package com.sensoro.survey;

import java.util.HashMap;
import java.util.List;

public class Transmission {
    private static Transmission mSingleton = null;
   public List<HashMap> list;
    public static Transmission getInstance() {
        if (mSingleton == null) {
            synchronized (Transmission.class) {
                if (mSingleton == null) {
                    mSingleton = new Transmission();
                }
            }
        }
        return mSingleton;

    }


}
