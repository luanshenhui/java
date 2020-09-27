package cn.com.cgbchina.common.utils;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by shangqinbin on 2016/6/30.
 */
public class CardUtil {

    private static String perBankCard[] = { "0","1","2","3","4","5","6","7","8","9","X" };// 成功返回码
    private static String bpsCard[] = { "01","02" ,"03","04","05","06","07","08","09","10","99"};// 成功返回码
    private static Map mapFromPerBank=null;
    private static Map mapFrombps=null;

    /**
     * 根据个人网银的证件类型得到bps的证件类型
     * @param type
     * @return
     */
    public static String getbpsFromPerBankCardType(String type){
        if(mapFromPerBank==null){
            mapFromPerBank=new HashMap();
            for(int i=0;i<perBankCard.length;i++){
                mapFromPerBank.put(perBankCard[i], bpsCard[i]);
            }
        }
        String returnType=null;
        if(type!=null){
            returnType=	(String)mapFromPerBank.get(type.trim());
        }
        if(returnType==null){
            returnType="";
        }
        return returnType;
    }

    /**
     * 根据个人网银的证件类型得到bps的证件类型
     * @param type
     * @return
     */
    public static String getPerBankFrombpsCardType(String type){
        if(mapFrombps==null){
            mapFrombps=new HashMap();
            for(int i=0;i<bpsCard.length;i++){
                mapFrombps.put(bpsCard[i], perBankCard[i]);
            }
        }
        String returnType=null;
        if(type!=null){
            returnType=	(String)mapFrombps.get(type.trim());
        }
        if(returnType==null){
            returnType="";
        }
        return returnType;
    }

    /**
     * 获取帐号类型 C：信用卡  Y：借记卡
     * @param account
     * @return
     */
    public static String getCardType(String account) {
        if (account == null||"".equals(account.trim())) {
            return "";
        } else if (account.trim().length() == 16) {// 信用卡
            return "C";
        } else {//借记卡
            return "Y";
        }
    }

    public static void dd(){

    }

    /**
     * @param args
     */
    public static void main(String[] args) {
        System.out.println(CardUtil.getbpsFromPerBankCardType("0"));
    }


}
