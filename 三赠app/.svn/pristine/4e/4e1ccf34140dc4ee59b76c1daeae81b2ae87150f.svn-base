package com.sanzeng.hello_watch.utils;

import android.content.Context;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.telephony.TelephonyManager;
import android.util.Log;

/**
 * Created by YY on 2016/6/16.
 * 网络状态检测
 */
public class NetworkUtil {

    /**
     * ZY 2016年5月26日13:43:05
     * 判断网络状态 返回值为网络状态类型(2G 3G 4G WIFI)
     */
    public static String GetNetworkType(Context context) {
        String strNetworkType = "";
        NetworkInfo networkInfo = getManager(context).getActiveNetworkInfo();
//        NetworkInfo networkInfo = (ConnectivityManager) getSystemService(Context.CONNECTIVITY_SERVICE).getActiveNetworkInfo();
        if (networkInfo != null && networkInfo.isConnected()) {
            if (networkInfo.getType() == ConnectivityManager.TYPE_WIFI) {
                strNetworkType = "WIFI";
            } else if (networkInfo.getType() == ConnectivityManager.TYPE_MOBILE) {
                String _strSubTypeName = networkInfo.getSubtypeName();

                Log.e("cocos2d-x", "Network getSubtypeName : " + _strSubTypeName);

                // TD-SCDMA  networkType is 17
                int networkType = networkInfo.getSubtype();
                switch (networkType) {
                    case TelephonyManager.NETWORK_TYPE_GPRS:
                    case TelephonyManager.NETWORK_TYPE_EDGE:
                    case TelephonyManager.NETWORK_TYPE_CDMA:
                    case TelephonyManager.NETWORK_TYPE_1xRTT:
                    case TelephonyManager.NETWORK_TYPE_IDEN: //api<8 : replace by 11
                        strNetworkType = "2G";
                        break;
                    case TelephonyManager.NETWORK_TYPE_UMTS:
                    case TelephonyManager.NETWORK_TYPE_EVDO_0:
                    case TelephonyManager.NETWORK_TYPE_EVDO_A:
                    case TelephonyManager.NETWORK_TYPE_HSDPA:
                    case TelephonyManager.NETWORK_TYPE_HSUPA:
                    case TelephonyManager.NETWORK_TYPE_HSPA:
                    case TelephonyManager.NETWORK_TYPE_EVDO_B: //api<9 : replace by 14
                    case TelephonyManager.NETWORK_TYPE_EHRPD: //api<11 : replace by 12
                    case TelephonyManager.NETWORK_TYPE_HSPAP: //api<13 : replace by 15
                        strNetworkType = "3G";
                        break;
                    case TelephonyManager.NETWORK_TYPE_LTE:  //api<11 : replace by 13
                        strNetworkType = "4G";
                        break;
                    default:
                        // http://baike.baidu.com/item/TD-SCDMA 中国移动 联通 电信 三种3G制式
                        if (_strSubTypeName.equalsIgnoreCase("TD-SCDMA") || _strSubTypeName.equalsIgnoreCase("WCDMA") || _strSubTypeName.equalsIgnoreCase("CDMA2000")) {
                            strNetworkType = "3G";
                        } else {
                            strNetworkType = _strSubTypeName;
                        }

                        break;
                }

                Log.e("cocos2d-x", "Network getSubtype : " + Integer.valueOf(networkType).toString());
            }
        }

        Log.e("cocos2d-x", "Network Type : " + strNetworkType);

        return strNetworkType;
    }

    /**
     * WIFI是否连通
     *
     * @param context
     * @return true 连通 false 没连通
     */
    public static boolean isWifiStatus(Context context) {
        return getManager(context)
                .getNetworkInfo(ConnectivityManager.TYPE_WIFI)
                .isConnectedOrConnecting();
    }

    /**
     * 是否有网络接入
     *
     * @param context
     * @return true 连通 false 没连通
     */
    public static boolean isNetworkPass(Context context) {
        if (context == null) return false;

        ConnectivityManager cManager = (ConnectivityManager) context.
                getSystemService(Context.CONNECTIVITY_SERVICE);

        //&& NetworkUtil.getNetworkState(context) == NetworkInfo.State.CONNECTED
        return !(cManager.getActiveNetworkInfo() == null ||
                NetworkUtil.getNetworkState(context) == NetworkInfo.State.DISCONNECTED);
    }

    private static ConnectivityManager getManager(Context context) {
        return (ConnectivityManager) context
                .getSystemService(Context.CONNECTIVITY_SERVICE);
    }

    /**
     * 返回一个网络的类型enum;
     *
     * @param context 当前环境
     * @return 一个代表网络状态的Enum;
     */
    public static NetworkInfo.State getNetworkState(Context context) {
        ConnectivityManager cManager = (ConnectivityManager) context.
                getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo networkInfo = cManager.getActiveNetworkInfo();
        if (networkInfo == null || !networkInfo.isAvailable()) {
            return NetworkInfo.State.DISCONNECTING;
        }
        return networkInfo.getState();
    }
}
