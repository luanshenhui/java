package cn.com.cgbchina.restful.provider.service.order;

import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import cn.com.cgbchina.item.service.GoodsPayWayService;
import cn.com.cgbchina.item.service.ItemService;
import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.vo.order.StageMallOrderDetailReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.StageMallOrderDetailVO;
import cn.com.cgbchina.trade.model.OrderBackupModel;
import cn.com.cgbchina.trade.model.OrderDoDetailModel;
import cn.com.cgbchina.trade.model.OrderMainModel;
import cn.com.cgbchina.trade.model.OrderSubModel;
import cn.com.cgbchina.trade.model.OrderTransModel;
import cn.com.cgbchina.trade.model.TblOrderHistoryModel;
import cn.com.cgbchina.trade.model.TblOrderMainBackupModel;
import cn.com.cgbchina.trade.model.TblOrdermainHistoryModel;
import cn.com.cgbchina.trade.service.OrderService;
import cn.com.cgbchina.trade.service.TblOrderMainBackupService;
import cn.com.cgbchina.trade.service.TblOrderMainHistoryService;
import cn.com.cgbchina.trade.service.TblOrderMainService;
import com.spirit.common.model.Response;
import com.spirit.util.JsonMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.io.IOException;
import java.util.List;

/**
 * MAL111 订单详细信息查询(分期商城) 从soap对象生成的vo转为 接口调用的bean
 *
 * @author Lizy
 */
@Service
@TradeCode(value = "MAL111")
@Slf4j
public class StageMallOrderDetailProvideServiceImpl implements SoapProvideService<StageMallOrderDetailVO, StageMallOrderDetailReturnVO> {

    private static JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();

    @Resource
    OrderService orderService;
    @Resource
    TblOrderMainService tblOrderMainService;
    @Resource
    ItemService itemService;
    @Resource
    GoodsPayWayService goodsPayWayService;
    @Resource
    TblOrderMainHistoryService tblOrderMainHistoryService;
    @Resource
    TblOrderMainBackupService tblOrderMainBackupService;

    @Override
    public StageMallOrderDetailReturnVO process(SoapModel<StageMallOrderDetailVO> model, StageMallOrderDetailVO content) {
        StageMallOrderDetailReturnVO stageMallOrderDetailReturnVO = new StageMallOrderDetailReturnVO();

        try {
            log.info("【MAL111】流水：" + model.getSenderSN() + "，进入订单查询接口");
            String order_id = content.getOrderId();
            if (order_id == null || "".equals(order_id.trim())) {
                log.info("参数异常【000008】,订单号为空");
                stageMallOrderDetailReturnVO.setReturnCode("000008");
                stageMallOrderDetailReturnVO.setReturnDes("参数异常, 小订单号为空");
                return stageMallOrderDetailReturnVO;
            }

            log.info("【MAL111】流水：" + model.getSenderSN() + ",查询订单信息");
            try {
                Response<OrderSubModel> orderSubModelResponse = orderService.findOrderSubById(order_id);
                Response<TblOrderHistoryModel> tblOrderHistoryModelResponse = orderService.findTblOrderHistoryById(order_id);
                Response<OrderBackupModel> orderBackupModelResponse = orderService.findOrderBackupById(order_id);
                Response<List<OrderDoDetailModel>> doDetailResponse = orderService.findOrderDoDetailByOrderStatusId(order_id);
                List<OrderDoDetailModel> goodsSendTimeList = doDetailResponse.getResult();
                String goodssend_date = "";
                if (goodsSendTimeList != null && goodsSendTimeList.size() != 0) {
                    OrderDoDetailModel orderDoDetailModel = goodsSendTimeList.get(0);
                    if (orderDoDetailModel.getDoTime() != null) {
                        goodssend_date = DateHelper.date2string(orderDoDetailModel.getDoTime(), DateHelper.YYYYMMDD);//发货日期
                    }
                }
                if (orderSubModelResponse.getResult() != null) {
                    OrderSubModel orderSubModel = orderSubModelResponse.getResult();
                    OrderMainModel orderMainModel = new OrderMainModel();
                    ItemModel itemModel = new ItemModel();
                    TblGoodsPaywayModel tblGoodsPaywayModel = new TblGoodsPaywayModel();
                    OrderTransModel orderTransModel = new OrderTransModel();
                    Response<OrderMainModel> mainResponse = tblOrderMainService.findByOrderMainId(orderSubModel.getOrdermainId());
                    if (mainResponse.getResult() != null) {
                        orderMainModel = mainResponse.getResult();
                    } else {
                        log.info("【查询该订单信息不存在..】订单号：" + order_id);
                        stageMallOrderDetailReturnVO.setReturnCode("000013");
                        stageMallOrderDetailReturnVO.setReturnDes("查询订单信息不存在");
                        return stageMallOrderDetailReturnVO;
                    }
                    Response<ItemModel> itemModelResponse = itemService.findInfoById(orderSubModel.getGoodsId());
                    if (itemModelResponse.getResult() != null) {
                        itemModel = itemModelResponse.getResult();
                    } else {
                        log.info("【查询该订单信息不存在..】订单号：" + order_id);
                        stageMallOrderDetailReturnVO.setReturnCode("000013");
                        stageMallOrderDetailReturnVO.setReturnDes("查询订单信息不存在");
                        return stageMallOrderDetailReturnVO;
                    }
                    Response<TblGoodsPaywayModel> paywayResponse = goodsPayWayService.findGoodsPayWayInfo(orderSubModel.getGoodsPaywayId());
                    if (paywayResponse.getResult() != null) {
                        tblGoodsPaywayModel = paywayResponse.getResult();
                    } else {
                        log.info("【查询该订单信息不存在..】订单号：" + order_id);
                        stageMallOrderDetailReturnVO.setReturnCode("000013");
                        stageMallOrderDetailReturnVO.setReturnDes("查询订单信息不存在");
                        return stageMallOrderDetailReturnVO;
                    }
                    Response<OrderTransModel> orderTransModelResponse = orderService.findOrderTrans(orderSubModel.getOrderId());
                    if (orderTransModelResponse.getResult() != null) {
                        orderTransModel = orderTransModelResponse.getResult();
                    }

                    log.info("【MAL111】流水：" + model.getSenderSN() + ",组装订单返回信息..");
                    stageMallOrderDetailReturnVO.setReturnCode("000000");
                    stageMallOrderDetailReturnVO.setReturnDes("订单查询成功");

                    stageMallOrderDetailReturnVO.setOrderId(orderSubModel.getOrderId());
                    stageMallOrderDetailReturnVO.setCurStatusId(orderSubModel.getCurStatusId());
                    stageMallOrderDetailReturnVO.setGoodssendFlag(orderSubModel.getGoodssendFlag());
                    String createDate = DateHelper.date2string(orderMainModel.getCreateTime(), DateHelper.YYYYMMDD);
                    stageMallOrderDetailReturnVO.setCreateDate(createDate);//xiewl 20161012
                    stageMallOrderDetailReturnVO.setGoodssendDate(goodssend_date);
                    stageMallOrderDetailReturnVO.setIsInvoice(orderMainModel.getIsInvoice());
                    stageMallOrderDetailReturnVO.setInvoiceType("");
                    stageMallOrderDetailReturnVO.setInvoice(orderMainModel.getInvoice());
                    stageMallOrderDetailReturnVO.setInvoiceContent(orderMainModel.getInvoiceContent());
                    stageMallOrderDetailReturnVO.setOrdermainDesc(orderMainModel.getOrdermainDesc());
                    stageMallOrderDetailReturnVO.setCsgProvince(orderMainModel.getCsgProvince());
                    stageMallOrderDetailReturnVO.setCsgCity(orderMainModel.getCsgCity());
                    stageMallOrderDetailReturnVO.setCsgBorough(orderMainModel.getCsgBorough());
                    stageMallOrderDetailReturnVO.setCsgAddress(orderMainModel.getCsgAddress());
                    stageMallOrderDetailReturnVO.setCsgName(orderMainModel.getCsgName());
                    stageMallOrderDetailReturnVO.setCsgPostcode(orderMainModel.getCsgPostcode());
                    stageMallOrderDetailReturnVO.setCsgPhone1(orderMainModel.getCsgPhone1());
                    stageMallOrderDetailReturnVO.setCsgPhone2(orderMainModel.getCsgPhone2());
                    stageMallOrderDetailReturnVO.setGoodsOid(itemModel.getOid());
                    stageMallOrderDetailReturnVO.setGoodsMid(itemModel.getMid());
                    stageMallOrderDetailReturnVO.setGoodsNm(orderSubModel.getGoodsNm());
                    stageMallOrderDetailReturnVO.setGoodsNum(orderSubModel.getGoodsNum() != null ? orderSubModel.getGoodsNum().toString() : "");
                    stageMallOrderDetailReturnVO.setSinglePrice(orderSubModel.getSinglePrice() != null ? orderSubModel.getSinglePrice().toString() : "");
                    stageMallOrderDetailReturnVO.setStagesNum(tblGoodsPaywayModel.getStagesCode() != null ? tblGoodsPaywayModel.getStagesCode().toString() : "");
                    stageMallOrderDetailReturnVO.setPerStage(tblGoodsPaywayModel.getPerStage() != null ? tblGoodsPaywayModel.getPerStage().toString() : "");
                    stageMallOrderDetailReturnVO.setGoodsSize(orderSubModel.getGoodsModel());
                    stageMallOrderDetailReturnVO.setGoodsColor(orderSubModel.getGoodsColor());
                    stageMallOrderDetailReturnVO.setMailingNum(orderTransModel.getMailingNum());
                    stageMallOrderDetailReturnVO.setServiceUrl(orderTransModel.getServiceUrl());
                    stageMallOrderDetailReturnVO.setPhone(orderTransModel.getServicePhone());
                    stageMallOrderDetailReturnVO.setGoodsPresent(orderSubModel.getGoodsPresent());
                    stageMallOrderDetailReturnVO.setDiscountPrivMon(orderSubModel.getUitdrtamt() != null ? orderSubModel.getUitdrtamt().toString() : "");
                    stageMallOrderDetailReturnVO.setDiscountPrivilege(orderSubModel.getSingleBonus() != null ? orderSubModel.getSingleBonus().toString() : "");
                    stageMallOrderDetailReturnVO.setPrivilegeId(orderSubModel.getVoucherNo());
                    stageMallOrderDetailReturnVO.setPrivilegeName(orderSubModel.getVoucherNm());
                    stageMallOrderDetailReturnVO.setPrivilegeMoney(orderSubModel.getVoucherPrice() != null ? orderSubModel.getVoucherPrice().doubleValue() : 0);
                    stageMallOrderDetailReturnVO.setPrePrice(tblGoodsPaywayModel.getGoodsPrice() != null ? tblGoodsPaywayModel.getGoodsPrice().toString() : "");
                    stageMallOrderDetailReturnVO.setVendorId(orderSubModel.getVendorId());
                    stageMallOrderDetailReturnVO.setVendorFnm(orderSubModel.getVendorSnm());

                } else if (tblOrderHistoryModelResponse.getResult() != null) {
                    TblOrderHistoryModel tblOrderHistoryModel = tblOrderHistoryModelResponse.getResult();
                    TblOrdermainHistoryModel orderMainHistoryModel = new TblOrdermainHistoryModel();
                    ItemModel itemModel = new ItemModel();
                    TblGoodsPaywayModel tblGoodsPaywayModel = new TblGoodsPaywayModel();
                    OrderTransModel orderTransModel = new OrderTransModel();
                    Response<TblOrdermainHistoryModel> mainResponse = tblOrderMainHistoryService.findByOrderMainId(tblOrderHistoryModel.getOrdermainId());
                    if (mainResponse.getResult() != null) {
                        orderMainHistoryModel = mainResponse.getResult();
                    } else {
                        log.info("【查询该订单信息不存在..】订单号：" + order_id);
                        stageMallOrderDetailReturnVO.setReturnCode("000013");
                        stageMallOrderDetailReturnVO.setReturnDes("查询订单信息不存在");
                        return stageMallOrderDetailReturnVO;
                    }
                    Response<ItemModel> itemModelResponse = itemService.findInfoById(tblOrderHistoryModel.getGoodsId());
                    if (itemModelResponse.getResult() != null) {
                        itemModel = itemModelResponse.getResult();
                    } else {
                        log.info("【查询该订单信息不存在..】订单号：" + order_id);
                        stageMallOrderDetailReturnVO.setReturnCode("000013");
                        stageMallOrderDetailReturnVO.setReturnDes("查询订单信息不存在");
                        return stageMallOrderDetailReturnVO;
                    }
                    Response<TblGoodsPaywayModel> paywayResponse = goodsPayWayService.findGoodsPayWayInfo(tblOrderHistoryModel.getGoodsPaywayId());
                    if (paywayResponse.getResult() != null) {
                        tblGoodsPaywayModel = paywayResponse.getResult();
                    } else {
                        log.info("【查询该订单信息不存在..】订单号：" + order_id);
                        stageMallOrderDetailReturnVO.setReturnCode("000013");
                        stageMallOrderDetailReturnVO.setReturnDes("查询订单信息不存在");
                        return stageMallOrderDetailReturnVO;
                    }
                    Response<OrderTransModel> orderTransModelResponse = orderService.findOrderTrans(tblOrderHistoryModel.getOrderId());
                    if (orderTransModelResponse.getResult() != null) {
                        orderTransModel = orderTransModelResponse.getResult();
                    }

                    log.info("【MAL111】流水：" + model.getSenderSN() + ",组装订单返回信息..");
                    stageMallOrderDetailReturnVO.setReturnCode("000000");
                    stageMallOrderDetailReturnVO.setReturnDes("订单查询成功");

                    stageMallOrderDetailReturnVO.setOrderId(tblOrderHistoryModel.getOrderId());
                    stageMallOrderDetailReturnVO.setCurStatusId(tblOrderHistoryModel.getCurStatusId());
                    stageMallOrderDetailReturnVO.setGoodssendFlag(tblOrderHistoryModel.getGoodssendFlag());
                    String createDate = DateHelper.date2string(orderMainHistoryModel.getCreateTime(), DateHelper.YYYY_MM_DD_HH_MM_SS);
                    stageMallOrderDetailReturnVO.setCreateDate(createDate.substring(0, 10));
                    stageMallOrderDetailReturnVO.setGoodssendDate(goodssend_date);
                    stageMallOrderDetailReturnVO.setIsInvoice(orderMainHistoryModel.getIsInvoice());
                    stageMallOrderDetailReturnVO.setInvoiceType("");
                    stageMallOrderDetailReturnVO.setInvoice(orderMainHistoryModel.getInvoice());
                    stageMallOrderDetailReturnVO.setInvoiceContent(orderMainHistoryModel.getInvoiceContent());
                    stageMallOrderDetailReturnVO.setOrdermainDesc(orderMainHistoryModel.getOrdermainDesc());
                    stageMallOrderDetailReturnVO.setCsgProvince(orderMainHistoryModel.getCsgProvince());
                    stageMallOrderDetailReturnVO.setCsgCity(orderMainHistoryModel.getCsgCity());
                    stageMallOrderDetailReturnVO.setCsgBorough(orderMainHistoryModel.getCsgBorough());
                    stageMallOrderDetailReturnVO.setCsgAddress(orderMainHistoryModel.getCsgAddress());
                    stageMallOrderDetailReturnVO.setCsgName(orderMainHistoryModel.getCsgName());
                    stageMallOrderDetailReturnVO.setCsgPostcode(orderMainHistoryModel.getCsgPostcode());
                    stageMallOrderDetailReturnVO.setCsgPhone1(orderMainHistoryModel.getCsgPhone1());
                    stageMallOrderDetailReturnVO.setCsgPhone2(orderMainHistoryModel.getCsgPhone2());
                    stageMallOrderDetailReturnVO.setGoodsOid(itemModel.getOid());
                    stageMallOrderDetailReturnVO.setGoodsMid(itemModel.getMid());
                    stageMallOrderDetailReturnVO.setGoodsNm(tblOrderHistoryModel.getGoodsNm());
                    stageMallOrderDetailReturnVO.setGoodsNum(tblOrderHistoryModel.getGoodsNum() != null ? tblOrderHistoryModel.getGoodsNum().toString() : "");
                    stageMallOrderDetailReturnVO.setSinglePrice(tblOrderHistoryModel.getSinglePrice() != null ? tblOrderHistoryModel.getSinglePrice().toString() : "");
                    stageMallOrderDetailReturnVO.setStagesNum(tblGoodsPaywayModel.getStagesCode() != null ? tblGoodsPaywayModel.getStagesCode().toString() : "");
                    stageMallOrderDetailReturnVO.setPerStage(tblGoodsPaywayModel.getPerStage() != null ? tblGoodsPaywayModel.getPerStage().toString() : "");
                    stageMallOrderDetailReturnVO.setGoodsSize(tblOrderHistoryModel.getGoodsModel());
                    stageMallOrderDetailReturnVO.setGoodsColor(tblOrderHistoryModel.getGoodsColor());
                    stageMallOrderDetailReturnVO.setMailingNum(orderTransModel.getMailingNum());
                    stageMallOrderDetailReturnVO.setServiceUrl(orderTransModel.getServiceUrl());
                    stageMallOrderDetailReturnVO.setPhone(orderTransModel.getServicePhone());
                    stageMallOrderDetailReturnVO.setGoodsPresent(tblOrderHistoryModel.getGoodsPresent());
                    stageMallOrderDetailReturnVO.setDiscountPrivMon(tblOrderHistoryModel.getUitdrtamt() != null ? tblOrderHistoryModel.getUitdrtamt().toString() : "");
                    stageMallOrderDetailReturnVO.setDiscountPrivilege(tblOrderHistoryModel.getSingleBonus() != null ? tblOrderHistoryModel.getSingleBonus().toString() : "");
                    stageMallOrderDetailReturnVO.setPrivilegeId(tblOrderHistoryModel.getVoucherNo());
                    stageMallOrderDetailReturnVO.setPrivilegeName(tblOrderHistoryModel.getVoucherNm());
                    stageMallOrderDetailReturnVO.setPrivilegeMoney(tblOrderHistoryModel.getVoucherPrice() != null ? tblOrderHistoryModel.getVoucherPrice().doubleValue() : 0);
                    stageMallOrderDetailReturnVO.setPrePrice(tblGoodsPaywayModel.getGoodsPrice() != null ? tblGoodsPaywayModel.getGoodsPrice().toString() : "");
                    stageMallOrderDetailReturnVO.setVendorId(tblOrderHistoryModel.getVendorId());
                    stageMallOrderDetailReturnVO.setVendorFnm(tblOrderHistoryModel.getVendorSnm());

                } else if (orderBackupModelResponse.getResult() != null) {
                    OrderBackupModel orderSubBackupModel = orderBackupModelResponse.getResult();
                    TblOrderMainBackupModel orderMainBackupModel = new TblOrderMainBackupModel();
                    ItemModel itemModel = new ItemModel();
                    TblGoodsPaywayModel tblGoodsPaywayModel = new TblGoodsPaywayModel();
                    OrderTransModel orderTransModel = new OrderTransModel();
                    Response<TblOrderMainBackupModel> mainResponse = tblOrderMainBackupService.findByOrderMainId(orderSubBackupModel.getOrdermainId());
                    if (mainResponse.getResult() != null) {
                        orderMainBackupModel = mainResponse.getResult();
                    } else {
                        log.info("【查询该订单信息不存在..】订单号：" + order_id);
                        stageMallOrderDetailReturnVO.setReturnCode("000013");
                        stageMallOrderDetailReturnVO.setReturnDes("查询订单信息不存在");
                        return stageMallOrderDetailReturnVO;
                    }
                    Response<ItemModel> itemModelResponse = itemService.findInfoById(orderSubBackupModel.getGoodsId());
                    if (itemModelResponse.getResult() != null) {
                        itemModel = itemModelResponse.getResult();
                    } else {
                        log.info("【查询该订单信息不存在..】订单号：" + order_id);
                        stageMallOrderDetailReturnVO.setReturnCode("000013");
                        stageMallOrderDetailReturnVO.setReturnDes("查询订单信息不存在");
                        return stageMallOrderDetailReturnVO;
                    }
                    Response<TblGoodsPaywayModel> paywayResponse = goodsPayWayService.findGoodsPayWayInfo(orderSubBackupModel.getGoodsPaywayId());
                    if (paywayResponse.getResult() != null) {
                        tblGoodsPaywayModel = paywayResponse.getResult();
                    } else {
                        log.info("【查询该订单信息不存在..】订单号：" + order_id);
                        stageMallOrderDetailReturnVO.setReturnCode("000013");
                        stageMallOrderDetailReturnVO.setReturnDes("查询订单信息不存在");
                        return stageMallOrderDetailReturnVO;
                    }
                    Response<OrderTransModel> orderTransModelResponse = orderService.findOrderTrans(orderSubBackupModel.getOrderId());
                    if (orderTransModelResponse.getResult() != null) {
                        orderTransModel = orderTransModelResponse.getResult();
                    }

                    log.info("【MAL111】流水：" + model.getSenderSN() + ",组装订单返回信息..");
                    stageMallOrderDetailReturnVO.setReturnCode("000000");
                    stageMallOrderDetailReturnVO.setReturnDes("订单查询成功");

                    stageMallOrderDetailReturnVO.setOrderId(orderSubBackupModel.getOrderId());
                    stageMallOrderDetailReturnVO.setCurStatusId(orderSubBackupModel.getCurStatusId());
                    stageMallOrderDetailReturnVO.setGoodssendFlag(orderSubBackupModel.getGoodssendFlag());
                    String createDate = DateHelper.date2string(orderMainBackupModel.getCreateTime(), DateHelper.YYYY_MM_DD_HH_MM_SS);
                    stageMallOrderDetailReturnVO.setCreateDate(createDate.substring(0, 10));
                    stageMallOrderDetailReturnVO.setGoodssendDate(goodssend_date);
                    stageMallOrderDetailReturnVO.setIsInvoice(orderMainBackupModel.getIsInvoice());
                    stageMallOrderDetailReturnVO.setInvoiceType("");
                    stageMallOrderDetailReturnVO.setInvoice(orderMainBackupModel.getInvoice());
                    stageMallOrderDetailReturnVO.setInvoiceContent(orderMainBackupModel.getInvoiceContent());
                    stageMallOrderDetailReturnVO.setOrdermainDesc(orderMainBackupModel.getOrdermainDesc());
                    stageMallOrderDetailReturnVO.setCsgProvince(orderMainBackupModel.getCsgProvince());
                    stageMallOrderDetailReturnVO.setCsgCity(orderMainBackupModel.getCsgCity());
                    stageMallOrderDetailReturnVO.setCsgBorough(orderMainBackupModel.getCsgBorough());
                    stageMallOrderDetailReturnVO.setCsgAddress(orderMainBackupModel.getCsgAddress());
                    stageMallOrderDetailReturnVO.setCsgName(orderMainBackupModel.getCsgName());
                    stageMallOrderDetailReturnVO.setCsgPostcode(orderMainBackupModel.getCsgPostcode());
                    stageMallOrderDetailReturnVO.setCsgPhone1(orderMainBackupModel.getCsgPhone1());
                    stageMallOrderDetailReturnVO.setCsgPhone2(orderMainBackupModel.getCsgPhone2());
                    stageMallOrderDetailReturnVO.setGoodsOid(itemModel.getOid());
                    stageMallOrderDetailReturnVO.setGoodsMid(itemModel.getMid());
                    stageMallOrderDetailReturnVO.setGoodsNm(orderSubBackupModel.getGoodsNm());
                    stageMallOrderDetailReturnVO.setGoodsNum(orderSubBackupModel.getGoodsNum() != null ? orderSubBackupModel.getGoodsNum().toString() : "");
                    stageMallOrderDetailReturnVO.setSinglePrice(orderSubBackupModel.getSinglePrice() != null ? orderSubBackupModel.getSinglePrice().toString() : "");
                    stageMallOrderDetailReturnVO.setStagesNum(tblGoodsPaywayModel.getStagesCode() != null ? tblGoodsPaywayModel.getStagesCode().toString() : "");
                    stageMallOrderDetailReturnVO.setPerStage(tblGoodsPaywayModel.getPerStage() != null ? tblGoodsPaywayModel.getPerStage().toString() : "");
                    stageMallOrderDetailReturnVO.setGoodsSize(orderSubBackupModel.getGoodsModel());
                    stageMallOrderDetailReturnVO.setGoodsColor(orderSubBackupModel.getGoodsColor());
                    stageMallOrderDetailReturnVO.setMailingNum(orderTransModel.getMailingNum());
                    stageMallOrderDetailReturnVO.setServiceUrl(orderTransModel.getServiceUrl());
                    stageMallOrderDetailReturnVO.setPhone(orderTransModel.getServicePhone());
                    stageMallOrderDetailReturnVO.setGoodsPresent(orderSubBackupModel.getGoodsPresent());
                    stageMallOrderDetailReturnVO.setDiscountPrivMon(orderSubBackupModel.getUitdrtamt() != null ? orderSubBackupModel.getUitdrtamt().toString() : "");
                    stageMallOrderDetailReturnVO.setDiscountPrivilege(orderSubBackupModel.getSingleBonus() != null ? orderSubBackupModel.getSingleBonus().toString() : "");
                    stageMallOrderDetailReturnVO.setPrivilegeId(orderSubBackupModel.getVoucherNo());
                    stageMallOrderDetailReturnVO.setPrivilegeName(orderSubBackupModel.getVoucherNm());
                    stageMallOrderDetailReturnVO.setPrivilegeMoney(orderSubBackupModel.getVoucherPrice() != null ? orderSubBackupModel.getVoucherPrice().doubleValue() : 0);
                    stageMallOrderDetailReturnVO.setPrePrice(tblGoodsPaywayModel.getGoodsPrice() != null ? tblGoodsPaywayModel.getGoodsPrice().toString() : "");
                    stageMallOrderDetailReturnVO.setVendorId(orderSubBackupModel.getVendorId());
                    stageMallOrderDetailReturnVO.setVendorFnm(orderSubBackupModel.getVendorSnm());

                } else {
                    log.info("【查询该订单信息不存在..】订单号：" + order_id);
                    stageMallOrderDetailReturnVO.setReturnCode("000013");
                    stageMallOrderDetailReturnVO.setReturnDes("查询订单信息不存在");
                    return stageMallOrderDetailReturnVO;
                }
            } catch (Exception e) {
                log.error("【数据库异常，查询失败..】", e);
                stageMallOrderDetailReturnVO.setReturnCode("000027");
                stageMallOrderDetailReturnVO.setReturnDes("数据库异常,查询失败");
                return stageMallOrderDetailReturnVO;
            }

        } catch (Exception e) {
            log.info("系统异常");
            log.error("exception", e);
            stageMallOrderDetailReturnVO.setReturnCode("000009");
            stageMallOrderDetailReturnVO.setReturnDes("系统异常");
        }
        return stageMallOrderDetailReturnVO;
    }

}
