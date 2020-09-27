/**
 * Copyright © 2016 广东发展银行 All right reserved.
 */
package cn.com.cgbchina.user.service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.user.dao.ACardCustToelectronbankDao;
import cn.com.cgbchina.user.dao.ACustToelectronbankDao;
import cn.com.cgbchina.user.dao.LocalCardRelateDao;
import cn.com.cgbchina.user.model.ACardCustToelectronbankModel;
import cn.com.cgbchina.user.model.ACustToelectronbankModel;
import cn.com.cgbchina.user.model.LocalCardRelateModel;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * @author jiao.wu
 * @version 1.0
 * @Since 2016/6/14.
 */
@Service
@Slf4j
public class CustInfoCommonServiceImpl implements CustInfoCommonService {

    @Resource
    private ACustToelectronbankDao aCustToelectronbankDao;

    @Resource
    private ACardCustToelectronbankDao aCardCustToelectronbankDao;

    @Resource
    private LocalCardRelateDao localCardRelateDao;

    /**
     * 通过客户证件号码取得客户最高卡等级对应的信息
     *
     * @param certNbr
     * @return
     */
    public ACustToelectronbankModel getMaxCardLevelCustInfoByCertNbr(String certNbr) {
        return aCustToelectronbankDao.findMaxCardLevelInfo(certNbr);
    }

    /**
     * 通过客户证件号码,客户级别（数据集市提供的数据）,客户标识计算出客户最优等级（商城的客户级别）
     *
     * @param certNbr
     * @param cardLevel
     * @param vipTp
     * @return
     */
    public String calMemberLevel(String certNbr, String cardLevel, String vipTp) {
        // 格式化客户标识
        if (vipTp != null && vipTp.length() > 2) {
            vipTp = vipTp.substring(0, 2);
        }
        if (Contants.LEVEL_CODE_4.equals(cardLevel)) {
            // 若为顶级卡,返回增值白金/顶级级别
            return Contants.MEMBER_LEVEL_DJ;
        } else if (Contants.LEVEL_CODE_3.equals(cardLevel)) {
            // 若为白金卡,通过卡板代码判断白金等级
            List<ACardCustToelectronbankModel> cardInfoList = aCardCustToelectronbankDao.findListByCertNbr(certNbr);
            if (cardInfoList != null) {
                for (ACardCustToelectronbankModel aCardCustToelectronbankModel : cardInfoList) {
                    LocalCardRelateModel localCardRelateModel = localCardRelateDao.findByFormatId(aCardCustToelectronbankModel.getCardFormatNbr());
                    if (localCardRelateModel != null && Contants.INCREMENT_BJ.equals(localCardRelateModel.getProCode())) {
                        // 若为增值白金卡板,返回顶级卡级别
                        return Contants.MEMBER_LEVEL_DJ;
                    }
                }
            }
            // 若为普通白金,判断客户标识
            if ("VV".equals(vipTp) || "P1".equals(vipTp)) {
                // 客户标识为VV/P1,提升客户等级为顶级/增值白金等级
                return Contants.MEMBER_LEVEL_DJ;
            } else {
                return Contants.MEMBER_LEVEL_TJ;
            }
        } else if (Contants.LEVEL_CODE_2.equals(cardLevel)) {
            // 若为钛金卡,判断客户标识
            if ("VV".equals(vipTp) || "P1".equals(vipTp)) {
                // 客户标识为VV/P1,提升客户等级为顶级/增值白金等级
                return Contants.MEMBER_LEVEL_DJ;
            } else {
                return Contants.MEMBER_LEVEL_TJ;
            }
        } else {
            // 若为金卡或普卡,判断客户标识
            if ("VV".equals(vipTp) || "P1".equals(vipTp)) {
                // 客户标识为VV/P1,提升客户等级为顶级/增值白金等级
                return Contants.MEMBER_LEVEL_DJ;
            } else if ("P2".equals(vipTp)) {
                // 客户标识为P2,提升客户等级为钛金卡
                return Contants.MEMBER_LEVEL_TJ;
            } else if (isVip(vipTp)) {
                // 客户标识为V1/V2/V3,提升客户等级为VIP等级
                return Contants.MEMBER_LEVEL_VIP;
            } else {
                // 返回金普卡等级
                return Contants.MEMBER_LEVEL_JP;
            }
        }
    }

    private boolean isVip(String vipTp) {
        // 格式化客户标识
        if (vipTp != null && vipTp.length() > 2) {
            vipTp = vipTp.substring(0, 2);
        }
        return "VV".equals(vipTp) || "V1".equals(vipTp) || "V2".equals(vipTp) || "V3".equals(vipTp);
    }
}
