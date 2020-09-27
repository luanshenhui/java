package cn.com.cgbchina.restful.provider.impl.order;

import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.model.order.CCIntergralOrderUpdate;
import cn.com.cgbchina.rest.provider.model.order.CCIntergralOrderUpdateReturn;
import cn.com.cgbchina.rest.provider.service.order.CCIntergralOrderUpdateService;
import cn.com.cgbchina.trade.model.OrderMainModel;
import cn.com.cgbchina.trade.model.TblOrderMainBackupModel;
import cn.com.cgbchina.trade.model.TblOrdermainHistoryModel;
import cn.com.cgbchina.trade.service.TblOrderMainBackupService;
import cn.com.cgbchina.trade.service.TblOrderMainHistoryService;
import cn.com.cgbchina.trade.service.TblOrderMainService;
import com.spirit.common.model.Response;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;


@Service
public class CCIntergralOrderUpdateServiceImpl implements CCIntergralOrderUpdateService {

    @Resource
    TblOrderMainService tblOrderMainService;
    @Resource
    TblOrderMainHistoryService tblOrderMainHistoryService;
    @Resource
    TblOrderMainBackupService tblOrderMainBackupService;

    @Override
    public CCIntergralOrderUpdateReturn update(CCIntergralOrderUpdate cCIntergralOrderUpdate) {
        CCIntergralOrderUpdateReturn res = BeanUtils.randomClass(CCIntergralOrderUpdateReturn.class);

        String orderMainId = cCIntergralOrderUpdate.getOrderMainId();
        String postCode = cCIntergralOrderUpdate.getPostCode();
        String deliveryAddr = cCIntergralOrderUpdate.getDeliveryAddr();
        String deliveryName = cCIntergralOrderUpdate.getDeliveryName();
        String deliveryMobile = cCIntergralOrderUpdate.getDeliveryMobile();
        String deliveryPhone = cCIntergralOrderUpdate.getDeliveryPhone();
        String csgProvince = cCIntergralOrderUpdate.getCsgProvince();
        String csgCity = cCIntergralOrderUpdate.getCsgCity();
        String csgMessage = cCIntergralOrderUpdate.getCsgMessage();

        if (orderMainId == null || "".equals(orderMainId.trim())) {
            res.setSuccessCode("00");
            res.setReturnCode("000008");
            res.setReturnDes("orderMainId参数为空");
            return res;
        }

        OrderMainModel tblOrderMain = null;
        TblOrdermainHistoryModel mainHistory = null;
        TblOrderMainBackupModel orderMainBackup = null;
        if (orderMainId.length() == 16) {
            Response<OrderMainModel> orderMainModelResponse = tblOrderMainService.findByOrderMainId(orderMainId);
            if (orderMainModelResponse.isSuccess() && orderMainModelResponse.getResult() != null) {
                tblOrderMain = orderMainModelResponse.getResult();
            } else {
                Response<TblOrdermainHistoryModel> historyModelResponse = tblOrderMainHistoryService.findByOrderMainId(orderMainId);
                if (historyModelResponse.isSuccess() && historyModelResponse.getResult() != null) {
                    mainHistory = historyModelResponse.getResult();
                }
            }
            if (tblOrderMain == null && mainHistory == null) {
                Response<TblOrderMainBackupModel> backupModelResponse = tblOrderMainBackupService.findByOrderMainId(orderMainId);
                if (backupModelResponse.isSuccess()){
                    orderMainBackup = backupModelResponse.getResult();
                }
            }
        } else {
            tblOrderMain = null;
            mainHistory = null;
        }

        res.setChannelSN("CCAG");
        if (tblOrderMain != null || mainHistory != null) {
            if (tblOrderMain != null) {
                tblOrderMain.setCsgPostcode(postCode);
                tblOrderMain.setCsgAddress(deliveryAddr);
                tblOrderMain.setCsgName(deliveryName);
                tblOrderMain.setCsgPhone1(deliveryMobile);
                tblOrderMain.setCsgPhone2(deliveryPhone);
                tblOrderMain.setCsgProvince(csgProvince);
                tblOrderMain.setCsgCity(csgCity);
                tblOrderMain.setOrdermainDesc(csgMessage);
                tblOrderMainService.updateOrderMainAddr(tblOrderMain);
            } else {
                mainHistory.setCsgPostcode(postCode);
                mainHistory.setCsgAddress(deliveryAddr);
                mainHistory.setCsgName(deliveryName);
                mainHistory.setCsgPhone1(deliveryMobile);
                mainHistory.setCsgPhone2(deliveryPhone);
                mainHistory.setCsgProvince(csgProvince);
                mainHistory.setCsgCity(csgCity);
                mainHistory.setOrdermainDesc(csgMessage);
                tblOrderMainHistoryService.updateOrderMainHistoryAddr(mainHistory);
            }
            res.setSuccessCode("01");
            res.setReturnCode("000000");
            res.setReturnDes("正常");
        } else if (orderMainBackup != null) {
            res.setSuccessCode("00");
            res.setReturnCode("000071");
            res.setReturnDes("存在备份表[" + orderMainId + "]的订单记录");
        } else {
            res.setSuccessCode("00");
            res.setReturnCode("000013");
            res.setReturnDes("找不到订单号为[" + orderMainId + "]的订单记录");
        }
        return res;
    }

}