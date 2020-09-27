package cn.com.cgbchina.common.utils;

/**
 * Created by shangqinbin on 2016/7/1.
 */
public class BpsReturnCode {
    private static String errorCodeSucess[] = {"0000"};// errorCode为成功的

    private static String approveResultSucess[] = {"0000", "0010"};// approveResult为支付成功的

    private static String approveResultDealing[] = {"0200", "0210"};// approveResult为处理中

    private static String approveResultRefusal[] = {"0100"};// approveResult为支付失败

    /**
     * 判断Bp0005是否支付成功
     *
     * @param errorCode
     * @return
     */
    public static boolean isBp0005Sucess(String errorCode, String approveResult) {
        boolean falg = false;
        for (int i = 0; i < errorCodeSucess.length; i++) {
            if (errorCodeSucess[i].equals(errorCode)) {
                falg = true;
                break;
            }
        }
        if (falg == true) {
            falg = false;
            for (int i = 0; i < approveResultSucess.length; i++) {
                if (approveResultSucess[i].equals(approveResult)) {
                    falg = true;
                    break;
                }
            }
        }
        return falg;
    }

    /**
     * 判断Bp0005是否处理中
     *
     * @param errorCode
     * @return
     */
    public static boolean isBp0005Dealing(String errorCode, String approveResult) {
        boolean falg = false;
        for (int i = 0; i < errorCodeSucess.length; i++) {
            if (errorCodeSucess[i].equals(errorCode)) {
                falg = true;
                break;
            }
        }
        if (falg == true) {
            falg = false;
            for (int i = 0; i < approveResultDealing.length; i++) {
                if (approveResultDealing[i].equals(approveResult)) {
                    falg = true;
                    break;
                }
            }
        }
        return falg;
    }

    /**
     * 判断Bp0005是否支付失败
     *
     * @param errorCode
     * @return
     */
    public static boolean isBp0005Refusal(String errorCode, String approveResult) {
        boolean falg = false;
        for (int i = 0; i < errorCodeSucess.length; i++) {
            if (errorCodeSucess[i].equals(errorCode)) {
                falg = true;
            }
        }
        if (falg == false) {//如果错误码不是正常的
            return true;
        }

        if (falg == true) {//如果错误码是正常的
            falg = false;
            for (int i = 0; i < approveResultSucess.length; i++) {//判断是否有支付成功的返回码
                if (approveResultSucess[i].equals(approveResult)) {
                    falg = true;
                    break;
                }
            }
            if (falg == true) {
                return false;
            }
            falg = false;
            for (int i = 0; i < approveResultDealing.length; i++) {//判断是否有处理中的返回码
                if (approveResultDealing[i].equals(approveResult)) {
                    falg = true;
                    break;
                }
            }
            if (falg == true) {
                return false;
            }
        }
        return true;
    }

    /**
     * 判断是否状态未明
     *
     * @param errorCode
     * @param approveResult
     * @return
     */
    public static boolean isBp0005NoSure(String errorCode, String approveResult) {
        if (errorCode == null || "".equals(errorCode)) {
            return true;
        } else if ("0000".equals(errorCode)) {
            if (approveResult == null || "".equals(approveResult)) {
                return true;
            } else if (!("0000".equals(approveResult) || "0010".equals(approveResult) || "0100".equals(approveResult) || "0200".equals(approveResult) || "0210".equals(approveResult))) {
                return true;
            }
        }
        return false;
    }


    public static void main(String[] args) {
        System.out.println(BpsReturnCode.isBp0005Dealing("0000", "0200"));
    }


}
