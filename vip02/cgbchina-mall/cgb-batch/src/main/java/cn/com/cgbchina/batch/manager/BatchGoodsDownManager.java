package cn.com.cgbchina.batch.manager;

import cn.com.cgbchina.batch.dao.BatchGoodsDownDao;
import cn.com.cgbchina.batch.exception.BatchException;
import cn.com.cgbchina.batch.model.GoodsModel;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.Date;
import java.util.List;

/**
 * 积分礼品自动下架
 * Created by dhc on 2016/8/16.
 */
@Component
@Slf4j
public class BatchGoodsDownManager {
    @Resource
    private BatchGoodsDownDao batchGoodsDownDao;

    @Transactional
    public void goodsDown(List<GoodsModel> goodsDownList) throws BatchException {
        Date nowDate = new Date(); // 当前时间
        if (goodsDownList != null && goodsDownList.size() > 0){
            for (GoodsModel goodsModel : goodsDownList) {
                // 广发商城状态
                if ("02".equals(goodsModel.getChannelMall())){
                    goodsModel.setChannelMall("01");
                    goodsModel.setOffShelfMallDate(nowDate);
                }
                // CC状态
                if ("02".equals(goodsModel.getChannelCc())){
                    goodsModel.setChannelCc("01");
                    goodsModel.setOffShelfCcDate(nowDate);
                }
                // 广发商城-微信状态
                if ("02".equals(goodsModel.getChannelMallWx())){
                    goodsModel.setChannelMallWx("01");
                    goodsModel.setOffShelfMallWxDate(nowDate);
                }
                // 信用卡中心-微信状态
                if ("02".equals(goodsModel.getChannelCreditWx())){
                    goodsModel.setChannelCreditWx("01");
                    goodsModel.setOffShelfCreditWxDate(nowDate);
                }
                // 手机商城状态
                if ("02".equals(goodsModel.getChannelPhone())){
                    goodsModel.setChannelPhone("01");
                    goodsModel.setOffShelfPhoneDate(nowDate);
                }
                // APP状态
                if ("02".equals(goodsModel.getChannelApp())){
                    goodsModel.setChannelApp("01");
                    goodsModel.setOffShelfAppDate(nowDate);
                }
                // 短信状态
                if ("02".equals(goodsModel.getChannelSms())){
                    goodsModel.setChannelSms("01");
                    goodsModel.setOffShelfSmsDate(nowDate);
                }
                // 积分商城状态
                if ("02".equals(goodsModel.getChannelPoints())){
                    goodsModel.setChannelPoints("01");
                }
                // ivr状态
                if ("02".equals(goodsModel.getChannelIvr())){
                    goodsModel.setChannelIvr("01");
                }
                // 更改审核状态为 06审核通过
                goodsModel.setApproveStatus("06");
                // 更新积分礼品信息，将状态置为已下架, 更改审核状态
                batchGoodsDownDao.updateGoodsDown(goodsModel);
            }
        }
    }
}
