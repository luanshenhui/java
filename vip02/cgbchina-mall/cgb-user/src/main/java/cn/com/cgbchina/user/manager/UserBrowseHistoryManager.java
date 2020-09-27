package cn.com.cgbchina.user.manager;

import cn.com.cgbchina.user.dao.MemberBrowseHistoryDao;
import cn.com.cgbchina.user.model.MemberBrowseHistoryModel;
import com.google.common.base.Throwables;
import com.spirit.user.User;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.util.List;

/**
 * Created by zhanglin on 2016/7/9.
 */
@Slf4j
@Component
@Transactional
public class UserBrowseHistoryManager {
    @Resource
    private MemberBrowseHistoryDao memberBrowseHistoryDao;

    @Transactional(rollbackFor = { Exception.class })
    public void loinBrowseHistory(String goodsCode, String code, BigDecimal price, String custId,int insta,Long goodsPoint) {
        List<MemberBrowseHistoryModel> memberBrowse = memberBrowseHistoryDao.getUserBrowsHistory(goodsCode, custId);
        try {
            if (memberBrowse != null && memberBrowse.size() > 0) {
                MemberBrowseHistoryModel memberBrowseHistoryModel = memberBrowse.get(0);
                memberBrowseHistoryModel.setPrice(price);
                memberBrowseHistoryModel.setItemCode(code);
                memberBrowseHistoryModel.setBrowseType("1");
                memberBrowseHistoryModel.setSource("1");
                memberBrowseHistoryModel.setInstallmentNumber(Integer.valueOf(insta));
                memberBrowseHistoryModel.setGoodsPoint(goodsPoint);
                memberBrowseHistoryDao.updateBrowse(memberBrowseHistoryModel);
            } else {
                MemberBrowseHistoryModel memberBrowseHistoryModel = new MemberBrowseHistoryModel();
                memberBrowseHistoryModel.setGoodsCode(goodsCode);
                memberBrowseHistoryModel.setItemCode(code);
                memberBrowseHistoryModel.setPrice(price);
                memberBrowseHistoryModel.setCustId(custId);
                memberBrowseHistoryModel.setBrowseType("1");
                memberBrowseHistoryModel.setSource("1");
                memberBrowseHistoryModel.setInstallmentNumber(Integer.valueOf(insta));
                memberBrowseHistoryModel.setDelFlag(0);
                memberBrowseHistoryModel.setGoodsPoint(goodsPoint);
                memberBrowseHistoryDao.insert(memberBrowseHistoryModel);
            }
        }catch (Exception e){
            log.error("UserBrowseHistoryManager.loinBrowseHistory.fail,cause:{}",Throwables.getStackTraceAsString(e));
            throw e;
        }
    }
}
