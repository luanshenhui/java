package cn.com.cgbchina.common.utils;

/**
 * Created by shangqinbin on 2016/6/30.
 */
public class PayReturnCode {

    private static String stateNoSure[] = {"PP028001", "CS000012", "CS000888", "EBLN2000"};// 状态未明返回码

    private static String stateSucess[] = {"RC000"};// 成功返回码

    private static String stateDuplicate[] = {"PP031001"};// 重复支付返回码

    /**
     * 判断是否状态未明
     *
     * @param returnCode
     * @return
     */
    public static boolean isStateNoSure(String returnCode) {
        for (int i = 0; i < stateNoSure.length; i++) {
            if (stateNoSure[i].equals(returnCode.trim())) {
                return true;
            }
        }
        return false;
    }

    /**
     * 判断是否状态成功
     *
     * @param returnCode
     * @return
     */
    public static boolean isSucess(String returnCode) {
        for (int i = 0; i < stateSucess.length; i++) {
            if (stateSucess[i].equals(returnCode.trim())) {
                return true;
            }
        }
        return false;
    }

    /**
     * 判断是否重复支付
     *
     * @param returnCode
     * @return
     */
    public static boolean isDuplicate(String returnCode) {
        for (int i = 0; i < stateDuplicate.length; i++) {
            if (stateDuplicate[i].equals(returnCode.trim())) {
                return true;
            }
        }
        return false;
    }
}
