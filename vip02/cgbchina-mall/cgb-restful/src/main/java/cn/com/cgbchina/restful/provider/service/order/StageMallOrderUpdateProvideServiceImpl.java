package cn.com.cgbchina.restful.provider.service.order;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.vo.order.StageMallOrderUpdateReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.StageMallOrderUpdateVO;
import cn.com.cgbchina.trade.model.OrderMainModel;
import cn.com.cgbchina.trade.model.TblOrderMainBackupModel;
import cn.com.cgbchina.trade.model.TblOrderMainHisModel;
import cn.com.cgbchina.trade.model.TblOrdermainHistoryModel;
import cn.com.cgbchina.trade.service.OrderQueryService;
import cn.com.cgbchina.trade.service.OrderService;
import cn.com.cgbchina.trade.service.TblOrderMainBackupService;
import cn.com.cgbchina.trade.service.TblOrderMainHistoryService;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.Date;

/**
 * MAL109 订单修改(分期商城) 从soap对象生成的vo转为 接口调用的bean
 *
 * @author Lizy
 */
@Service
@TradeCode(value = "MAL109")
@Slf4j
public class StageMallOrderUpdateProvideServiceImpl implements SoapProvideService<StageMallOrderUpdateVO, StageMallOrderUpdateReturnVO> {
    @Resource
    private OrderService orderService;
    @Resource
    private TblOrderMainHistoryService orderMainHistoryService;
    @Resource
    private TblOrderMainBackupService orderMainBackupService;
    @Resource
    private OrderQueryService orderQueryService;

    @Override
    public StageMallOrderUpdateReturnVO process(SoapModel<StageMallOrderUpdateVO> model, StageMallOrderUpdateVO content) {
        StageMallOrderUpdateReturnVO envolopeVo = new StageMallOrderUpdateReturnVO();

        log.info("【MAL109】流水：" + model.getSenderSN() + "，进入投递方式修改接口");
        String orderMainId = content.getOrderMainId();
        String postCode = content.getPostCode();
        String deliveryAddr = content.getDeliveryAddr();
        String csg_province = content.getCsgProvince();
        String csg_city = content.getCsgCity();
        String csg_borough = content.getCsgBorough();
        String deliveryName = content.getDeliveryName();
        String deliveryMobile = content.getDeliveryMobile();
        String deliveryPhone = content.getDeliveryPhone();
        String promotors = content.getPromotors();
        String modifyOrdertypeId = content.getOrigin();    //发起方标识

        OrderMainModel orderMain = null;
        TblOrdermainHistoryModel mainHistory = null;
        String cur_status_id = "";
        String setAcceptedNo = "";
        String setCardno = "";
        String setContAddress = "";
        String setContHphone = "";
        String setContIdType = "";
        String setContIdcard = "";
        String setContMobPhone = "";
        String setContNm = "";
        String setContNmPy = "";
        String setContPostcode = "";
        String setCsgAddress = "";
        String setCsgIdType = "";
        String setCsgIdcard = "";
        String setCsgName = "";
        String setCsgPhone1 = "";
        String setCsgPhone2 = "";
        String setCsgPostcode = "";
        String setCsgProvince = "";
        String setCsgCity = "";
        String setCsgBorough = "";
        String setCurStatusId = "";
        String setCurStatusNm = "";
        String setOrdertypeId = "";
        String setOrdertypeNm = "";
        String setModifyOper = "";

        Response<OrderMainModel> response = orderService.findOrderMainById(orderMainId);
        if (response.isSuccess()){
            orderMain = response.getResult();
        }
        if (orderMain == null) { // 大订单表为空时，查大订单历史表
            Response<TblOrdermainHistoryModel> historyResponse = orderMainHistoryService.findByOrderMainId(orderMainId);
            if (historyResponse.isSuccess()){
                mainHistory = historyResponse.getResult();
                if (mainHistory != null){
                    cur_status_id = mainHistory.getCurStatusId();
                    setAcceptedNo = mainHistory.getAcceptedNo();
                    setCardno = mainHistory.getCardno();
                    setContAddress = mainHistory.getContAddress();
                    setContHphone = mainHistory.getContHphone();
                    setContIdType = mainHistory.getContIdType();
                    setContIdcard = mainHistory.getContIdcard();
                    setContMobPhone = mainHistory.getContMobPhone();
                    setContNm = mainHistory.getContNm();
                    setContNmPy = mainHistory.getContNmPy();
                    setContPostcode = mainHistory.getContPostcode();
                    setCsgAddress = mainHistory.getCsgAddress();
                    setCsgIdType = mainHistory.getCsgIdType();
                    setCsgIdcard = mainHistory.getCsgIdcard();
                    setCsgName = mainHistory.getCsgName();
                    setCsgPhone1 = mainHistory.getCsgPhone1();
                    setCsgPhone2 = mainHistory.getCsgPhone2();
                    setCsgPostcode = mainHistory.getCsgPostcode();
                    setCsgProvince = mainHistory.getCsgProvince();
                    setCsgCity = mainHistory.getCsgCity();
                    setCsgBorough = mainHistory.getCsgBorough();
                    setCurStatusId = mainHistory.getCurStatusId();
                    setCurStatusNm = mainHistory.getCurStatusNm();
                    setOrdertypeId = mainHistory.getOrdertypeId();
                    setOrdertypeNm = mainHistory.getOrdertypeNm();
                    setModifyOper = mainHistory.getModifyOper();
                }
            }
        } else {
            cur_status_id = orderMain.getCurStatusId();
            setAcceptedNo = orderMain.getAcceptedNo();
            setCardno = orderMain.getCardno();
            setContAddress = orderMain.getContAddress();
            setContHphone = orderMain.getContHphone();
            setContIdType = orderMain.getContIdType();
            setContIdcard = orderMain.getContIdcard();
            setContMobPhone = orderMain.getContMobPhone();
            setContNm = orderMain.getContNm();
            setContNmPy = orderMain.getContNmPy();
            setContPostcode = orderMain.getContPostcode();
            setCsgAddress = orderMain.getCsgAddress();
            setCsgIdType = orderMain.getCsgIdType();
            setCsgIdcard = orderMain.getCsgIdcard();
            setCsgName = orderMain.getCsgName();
            setCsgPhone1 = orderMain.getCsgPhone1();
            setCsgPhone2 = orderMain.getCsgPhone2();
            setCsgPostcode = orderMain.getCsgPostcode();
            setCsgProvince = orderMain.getCsgProvince();
            setCsgCity = orderMain.getCsgCity();
            setCsgBorough = orderMain.getCsgBorough();
            setCurStatusId = orderMain.getCurStatusId();
            setCurStatusNm = orderMain.getCurStatusNm();
            setOrdertypeId = orderMain.getOrdertypeId();
            setOrdertypeNm = orderMain.getOrdertypeNm();
            setModifyOper = orderMain.getModifyOper();
        }
        // 如果大订单表和历史表都为空，查两年前订单表
        if (orderMain == null && mainHistory == null){
            Response<TblOrderMainBackupModel> backupModelResponse = orderMainBackupService.findByOrderMainId(orderMainId);
            if (backupModelResponse.isSuccess()){
                if (backupModelResponse.getResult() != null){
                    //如果从备份表中取出数据，则提示用户数据超过两年不能操作
                    envolopeVo.setReturnCode("000071");
                    envolopeVo.setReturnDes("数据超过两年，不可操作！");
                    return envolopeVo;
                }
            }
        }

        if(!"".equals(cur_status_id)){
            if(Contants.SUB_ORDER_STATUS_0309.equals(cur_status_id)
                    || Contants.SUB_ORDER_STATUS_0310.equals(cur_status_id)
                    || Contants.SUB_ORDER_STATUS_0380.equals(cur_status_id)
                    || Contants.SUB_ORDER_STATUS_0381.equals(cur_status_id)
                    || Contants.SUB_ORDER_STATUS_0334.equals(cur_status_id)
                    || Contants.SUB_ORDER_STATUS_0306.equals(cur_status_id)){
                envolopeVo.setReturnCode("000051");
                envolopeVo.setReturnDes("该订单已发货不能修改投递方式");
                return envolopeVo;
            }
        }else{
            envolopeVo.setReturnCode("000013");
            envolopeVo.setReturnDes("找不到该订单信息");
            return envolopeVo;
        }

        //记录当前订单地址信息
        TblOrderMainHisModel orderMainHis = new TblOrderMainHisModel();
        orderMainHis.setOrdermainId(orderMainId);
        orderMainHis.setAcceptedNo(setAcceptedNo);
        orderMainHis.setCardno(setCardno);
        orderMainHis.setContAddress(setContAddress);
        orderMainHis.setContHphone(setContHphone);
        orderMainHis.setContIdType(setContIdType);
        orderMainHis.setContIdcard(setContIdcard);
        orderMainHis.setContMobPhone(setContMobPhone);
        orderMainHis.setContNm(setContNm);
        orderMainHis.setContNmPy(setContNmPy);
        orderMainHis.setContPostcode(setContPostcode);
        orderMainHis.setCsgAddress(setCsgAddress);
        orderMainHis.setCsgIdType(setCsgIdType);
        orderMainHis.setCsgIdcard(setCsgIdcard);
        orderMainHis.setCsgName(setCsgName);
        orderMainHis.setCsgPhone1(setCsgPhone1);
        orderMainHis.setCsgPhone2(setCsgPhone2);
        orderMainHis.setCsgPostcode(setCsgPostcode);
        orderMainHis.setCsgProvince(setCsgProvince);
        orderMainHis.setCsgCity(setCsgCity);
        orderMainHis.setCsgBorough(setCsgBorough);
        orderMainHis.setCurStatusId(setCurStatusId);
        orderMainHis.setCurStatusNm(setCurStatusNm);
        orderMainHis.setModifyTime(new Date());
        orderMainHis.setSerialNo(model.getSenderSN());
        orderMainHis.setOrdertypeId(setOrdertypeId);
        orderMainHis.setOrdertypeNm(setOrdertypeNm);
        orderMainHis.setModifyOper(setModifyOper);//增加发起人，增加修改渠道两个字段
        orderMainHis.setPromotors(promotors);	//发起人
        orderMainHis.setModifyOrdertypeId(modifyOrdertypeId);	//修改渠道

        OrderMainModel orderMainModel = new OrderMainModel();
        orderMainModel.setOrdermainId(orderMainId);
        if(postCode != null && !"".equals(postCode)){
            orderMainModel.setCsgPostcode(postCode);
        }
        if(deliveryAddr != null && !"".equals(deliveryAddr)){
            orderMainModel.setCsgAddress(deliveryAddr);
        }
        if(deliveryName != null && !"".equals(deliveryName)){
            orderMainModel.setCsgName(deliveryName);
        }
        if(deliveryMobile != null && !"".equals(deliveryMobile)){
            orderMainModel.setCsgPhone1(deliveryMobile);
        }
        if(deliveryPhone != null && !"".equals(deliveryPhone)){
            orderMainModel.setCsgPhone2(deliveryPhone);
        }
        if(csg_province != null && !"".equals(csg_province)){
            orderMainModel.setCsgProvince(csg_province);
        }
        if(csg_city != null && !"".equals(csg_city)){
            orderMainModel.setCsgCity(csg_city);
        }
        if(csg_borough != null && !"".equals(csg_borough)){
            orderMainModel.setCsgBorough(csg_borough);
        }

        try{
            log.info("开始更新投递方式信息");
            log.info("【MAL109】流水："+model.getSenderSN() + ", 主订单号:" + orderMainId);
            orderQueryService.orderPostChangewithTX(orderMainModel, orderMainHis);
            log.info("更新投递方式信息成功");
            envolopeVo.setReturnCode("000000");
            envolopeVo.setReturnDes("投递信息修改成功");
            return envolopeVo;
        }catch(Exception e){
            log.error("数据库操作异常【000027】,异常信息:", e);
            envolopeVo.setReturnCode("000027");
            envolopeVo.setReturnDes("数据库更新异常");
            return envolopeVo;
        }
    }
}
