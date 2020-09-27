package cn.com.cgbchina.common.utils;

import cn.com.cgbchina.common.contants.Contants;

/**
 * <p>Description: 相关转换工具类</p>
 */
public class CustLevelChangeUtil {
    /**
     *
     * <p>Description:客户级别中文解释转换</p>
     * @param levelStr 客户级别
     * @return
     * @author:panhui
     * @update:2013-6-8
     */
    public static String custLevelChange(String levelStr){
        if("A".equals(levelStr)){
            return  "金普";
        }else if("B".equals(levelStr)){
            return  "钛金/臻享白金";
        }else if("C".equals(levelStr)){
            return  "顶级/增值白金";
        }else if("D".equals(levelStr)){
            return  "VIP";
        }

        return "";
    }

    /**
     *
     * <p>Description:上送积分系统渠道标志转换</p>
     * @param sourceId
     * @return
     * @author:panhui
     * @update:2014-9-4
     */
    public static String sourceIdChangeToChannel(String sourceId){
        if(Contants.SOURCE_ID_MALL.equals(sourceId)){
            return Contants.SOURCE_ID_MALL_TYPY;
        }
        if(Contants.SOURCE_ID_CC.equals(sourceId)){
            return Contants.SOURCE_ID_CC_TYPY;
        }
        if(Contants.SOURCE_ID_IVR.equals(sourceId)){
            return Contants.SOURCE_ID_IVR_TYPY;
        }
        if(Contants.SOURCE_ID_CELL.equals(sourceId)){
            return Contants.SOURCE_ID_CELL_TYPY;
        }
        if(Contants.SOURCE_ID_MESSAGE.equals(sourceId)){
            return Contants.SOURCE_ID_MESSAGE_TYPY;
        }
        if(Contants.SOURCE_ID_WX_BANK.equals(sourceId) || Contants.SOURCE_ID_WX_CARD.equals(sourceId)){
            return Contants.SOURCE_ID_WX_TYPY;
        }
        if(Contants.SOURCE_ID_APP.equals(sourceId)){
            return Contants.SOURCE_ID_APP_TYPY;
        }
        return Contants.SOURCE_ID_MALL_TYPY;
    }
}
