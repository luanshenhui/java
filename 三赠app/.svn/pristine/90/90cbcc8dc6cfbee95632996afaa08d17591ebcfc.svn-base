package com.sanzeng.hello_watch.utils;

import android.annotation.TargetApi;
import android.content.Context;
import android.content.SharedPreferences;
import android.os.Build;

import java.util.Map;
import java.util.Set;

/**
 * Preference Manager to help us complete shared preferences of saving, removing,adding and so on.
 * Created by YY on 2015/7/19.
 */
@SuppressWarnings("unused")
public class PfsUtils {

    private final static int DEF_PREFS_MODE = Context.MODE_PRIVATE;
    private static Context mContext;

    public static void init(Context context) {
        mContext = context;
    }

    public static void savePfs(String prefsName,
                               String key, Object value) {
        SharedPreferences sharedPrefs = mContext.getSharedPreferences(prefsName,
                DEF_PREFS_MODE);
        SharedPreferences.Editor editor = sharedPrefs.edit();

        if (value instanceof String)
            editor.putString(key, (String) value);
        else if (value instanceof Integer)
            editor.putInt(key, (Integer) value);
        else if (value instanceof Boolean)
            editor.putBoolean(key, (Boolean) value);
        else if (value instanceof Float)
            editor.putFloat(key, (Float) value);

        editor.apply();
    }

    public static void savePfs(String prefsName, int mode,
                               String key, Object value) {
        SharedPreferences sharedPrefs = mContext.getSharedPreferences(prefsName,
                mode);
        SharedPreferences.Editor editor = sharedPrefs.edit();

        if (value instanceof String)
            editor.putString(key, (String) value);
        else if (value instanceof Integer)
            editor.putInt(key, (Integer) value);
        else if (value instanceof Boolean)
            editor.putBoolean(key, (Boolean) value);
        else if (value instanceof Float)
            editor.putFloat(key, (Float) value);

        editor.apply();
    }

    public static void clearPfs(String prefsName) {
        SharedPreferences sharedPrefs = mContext.getSharedPreferences(prefsName,
                DEF_PREFS_MODE);
        SharedPreferences.Editor editor = sharedPrefs.edit();
        editor.clear().apply();
    }

    public static void clearPfs(String prefsName, int mode) {
        SharedPreferences sharedPrefs = mContext.getSharedPreferences(prefsName,
                mode);
        SharedPreferences.Editor editor = sharedPrefs.edit();
        editor.clear().apply();
    }


    public static void removePfs(String prefsName,
                                 int prefsMode, String key) {
        SharedPreferences sharedPrefs = mContext.getSharedPreferences(prefsName,
                prefsMode);
        SharedPreferences.Editor editor = sharedPrefs.edit();
        editor.remove(key).apply();
    }

    public static Object readPfs(String prefsName,
                                 int prefsMode, int type, String key) {
        SharedPreferences sharedPrefs = mContext.getSharedPreferences(prefsName,
                prefsMode);
        Object obj = null;
        switch (type) {
            case 0: {
                obj = sharedPrefs.getString(key, null);
                break;
            }
            case 1: {
                obj = sharedPrefs.getInt(key, -1);
                break;
            }
            case 2: {
                obj = sharedPrefs.getBoolean(key, false);
                break;
            }
            case 3: {
                obj = sharedPrefs.getFloat(key, 1);
                break;
            }
            default:
                break;
        }

        return obj;
    }

    public static String readString(String prefsName, String key) {
        SharedPreferences sharedPrefs = mContext.getSharedPreferences(prefsName,
                DEF_PREFS_MODE);

        return sharedPrefs.getString(key, null);
    }

    public static int readInteger(String prefsName, String key) {
        SharedPreferences sharedPrefs = mContext.getSharedPreferences(prefsName,
                DEF_PREFS_MODE);

        return sharedPrefs.getInt(key, 0);
    }

    public static boolean readBoolean(String prefsName, String key) {
        SharedPreferences sharedPrefs = mContext.getSharedPreferences(prefsName,
                DEF_PREFS_MODE);

        return sharedPrefs.getBoolean(key, false);
    }

    public static long readLong(String prefsName, String key) {
        SharedPreferences sharedPrefs = mContext.getSharedPreferences(prefsName,
                DEF_PREFS_MODE);

        return sharedPrefs.getLong(key, 0);
    }

    public static float readFloat(String prefsName, String key) {
        SharedPreferences sharedPrefs = mContext.getSharedPreferences(prefsName,
                DEF_PREFS_MODE);

        return sharedPrefs.getFloat(key, 0);
    }

    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public static Set<String> getStringSet(String prefsName, String key) {
        SharedPreferences sharedPrefs = mContext.getSharedPreferences(prefsName,
                DEF_PREFS_MODE);

        return sharedPrefs.getStringSet(key, null);
    }

    public static boolean isPfsEx(String prefsName,
                                  int prefsMode, String key) {
        SharedPreferences sharedPrefs = mContext.getSharedPreferences(prefsName,
                prefsMode);
        return sharedPrefs.contains(key);
    }

    public static boolean isPfsEx(String prefsName, String key) {
        SharedPreferences sharedPrefs = mContext.getSharedPreferences(prefsName,
                DEF_PREFS_MODE);
        return sharedPrefs.contains(key);
    }

    public static void updatePfs(String prefsName, String key, Object value) {
        if (!PfsUtils.isPfsEx(prefsName, key))
            return;

        PfsUtils.savePfs(prefsName, key, value);
    }

    public static Map<String, ?> readAll(String prefsName) {
        SharedPreferences sharedPreferences = mContext.getSharedPreferences(prefsName, DEF_PREFS_MODE);
        return sharedPreferences.getAll();
    }

    /**
     * 释放引用。在Application中的onTerminate()中调用。
     * <p/>
     * Added by HX-SC on 2016/6/28.
     */
    public static void dispose() {
        mContext = null;
    }
}