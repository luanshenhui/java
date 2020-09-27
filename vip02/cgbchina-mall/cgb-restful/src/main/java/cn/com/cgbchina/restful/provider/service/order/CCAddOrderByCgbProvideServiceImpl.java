package cn.com.cgbchina.restful.provider.service.order;

import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import lombok.extern.slf4j.Slf4j;

import org.joda.time.DateTime;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.common.utils.StringUtils;
import cn.com.cgbchina.generator.IdGenarator;
import cn.com.cgbchina.item.dto.MallPromotionResultDto;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.model.PointPoolModel;
import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import cn.com.cgbchina.item.service.GoodsPayWayService;
import cn.com.cgbchina.item.service.GoodsService;
import cn.com.cgbchina.item.service.ItemService;
import cn.com.cgbchina.item.service.MallPromotionService;
import cn.com.cgbchina.item.service.PointsPoolService;
import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.StringUtil;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.vo.order.CCAddOrderByCgbAddDetailReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.CCAddOrderByCgbAddReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.CCAddOrderByCgbAddVO;
import cn.com.cgbchina.rest.visit.model.payment.FinancialInfo;
import cn.com.cgbchina.rest.visit.model.payment.StagingRequest;
import cn.com.cgbchina.rest.visit.model.payment.StagingRequestResult;
import cn.com.cgbchina.rest.visit.model.user.QueryUserInfo;
import cn.com.cgbchina.rest.visit.model.user.UserInfo;
import cn.com.cgbchina.rest.visit.service.payment.StagingRequestService;
import cn.com.cgbchina.rest.visit.service.user.UserService;
import cn.com.cgbchina.trade.dto.OrderMainDto;
import cn.com.cgbchina.trade.model.OrderDoDetailModel;
import cn.com.cgbchina.trade.model.OrderMainModel;
import cn.com.cgbchina.trade.model.OrderSubModel;
import cn.com.cgbchina.trade.model.TblOrderExtend1Model;
import cn.com.cgbchina.trade.service.DealO2OOrderService;
import cn.com.cgbchina.trade.service.OrderQueryService;
import cn.com.cgbchina.trade.service.OrderService;
import cn.com.cgbchina.trade.service.RestOrderService;
import cn.com.cgbchina.user.model.TblVendorRatioModel;
import cn.com.cgbchina.user.model.VendorInfoModel;
import cn.com.cgbchina.user.service.UserInfoService;
import cn.com.cgbchina.user.service.VendorService;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import com.spirit.user.User;

/**
 * MAL115 CC广发下单 从soap对象生成的vo转为 接口调用的bean
 *
 * @author Lizy
 */
@Service
@TradeCode(value = "MAL115")
@Slf4j
public class CCAddOrderByCgbProvideServiceImpl implements SoapProvideService<CCAddOrderByCgbAddVO, CCAddOrderByCgbAddReturnVO> {
    @Resource
    OrderQueryService orderQueryService;
    @Resource
    UserService userService;
    @Resource
    IdGenarator idGenarator;
    @Resource
    GoodsService goodsService;
    @Resource
    GoodsPayWayService goodsPayWayService;
    @Resource
    VendorService vendorService;
    @Resource
    ItemService itemService;
    @Resource
    PointsPoolService pointsPoolService;
    @Resource
    OrderService orderService;
    @Resource
    UserInfoService userInfoService;
    @Resource
    StagingRequestService stagingRequestService;
    @Autowired
    private DealO2OOrderService dealO2OOrderService;
    @Resource
    RestOrderService restOrderService;
    @Resource
    MallPromotionService mallPromotionService;
    @Resource
    OrderChannelService orderChannelService;

    @Value("#{app.merchId}")
    private String merchId;
   

    @Override
    public CCAddOrderByCgbAddReturnVO process(SoapModel<CCAddOrderByCgbAddVO> model, CCAddOrderByCgbAddVO content) {
        log.info("【MAL115】流水：" + model.getSenderSN() + "，进入下单接口");
        CCAddOrderByCgbAddReturnVO ccAddOrderByCgbAddReturnVO = new CCAddOrderByCgbAddReturnVO();
        try {
            Date nowDate = new Date();
			String sorceSenderNo = content.getSorceSenderNo();//源发起方流水
			String operatorId = content.getOperatorId();//操作员代码
            String origin = content.getOrigin(); //01:分期商城   02:积分商城
            String mallType = content.getMallType();
            String ordertype_id = content.getOrdertypeId();
            String totvalueYG = content.getTotvalueYG();
            String totvalueFQ = content.getTotvalueFQ();
            String total_num = content.getTotalNum();
            String cont_id_type = content.getContIdType();
            String cont_idcard = content.getContIdcard();
            String cont_nm = content.getContNm();
            String cont_nm_py = content.getContNmPy();
            String cont_postcode = content.getContPostcode();
            String cont_address = content.getContAddress();
            String cont_mob_phone = content.getContMobPhone();
            String cont_hphone = content.getContHphone();
            String csg_name = content.getCsgName();
            String csg_postcode = content.getCsgPostcode();
            String csg_address = content.getCsgAddress();
            String csg_phone1 = content.getCsgPhone1();
            String csg_phone2 = content.getCsgPhone2();
            String bp_cust_grp = content.getSendTime();
            String acct_add_flag = content.getAcctAddFlag();
            String is_invoice = content.getIsInvoice();
            String invoice = content.getInvoice();
            String invoice_type = content.getInvoiceType();
            String invoice_content = content.getInvoiceContent();
            String ordermain_desc = content.getOrdermainDesc();
            String sendCode = content.getSendCode();
            String cust_sex = content.getCustSex();
            String cust_email = content.getCustEmail();
            String csg_province = content.getCsgProvince();
            String csg_city = content.getCsgCity();
            String csg_borough = content.getCsgBorough();
            String cardno = content.getCardno();
            String creator = content.getCreator();
            String regulator = content.getRegulator();
            String smsnotice = content.getSmsnotice();
            String Smsphone = content.getSmsphone();
            String Ordermemo = content.getOrdermemo();
            String michelleId = content.getMichelleId();
            String channel = content.getChannel();
            String receiveMode = content.getReceiveMode();
            String releaseType = content.getReleaseType();//申请释放类型 2=逐期 1=全额 默认送1
            String urgentLvl = content.getUrgentLvl();
            String prevCaseId = content.getPrevCaseId();
            String incomingTel = content.getIncomingTel();
            String memo = content.getMemo();
            String forceTransfer = content.getForceTransfer();
            String supplierName = content.getSupplierName();
            String oldBankId = content.getOldBankId();
            String supplierDesc = content.getSupplierDesc();
            String presentname = content.getPresentname();
            String recommendCardnbr = content.getRecommendCardnbr();
            String recommendname = content.getRecommendname();
            String recommendid = content.getRecommendid();
            String requestType = content.getRequestType();

            //优惠券需求增加字段
            String validDate = StringUtil.dealNull(content.getValidDate());
            String pointType = StringUtil.dealNull(content.getPointType());
            String privilegeId = StringUtil.dealNull(content.getPrivilegeId());
            String privilegeName = StringUtil.dealNull(content.getPrivilegeName());
            String privilegeMoney = content.getPrivilegeMoney() == null ? "" : content.getPrivilegeMoney().toString();
            String discountPrivilege = StringUtil.dealNull(content.getDiscountPrivilege());//抵扣积分
            String discountPrivMon = StringUtil.dealNull(content.getDiscountPrivMon());//抵扣积分金额
            //为了配合生日价记录 将客户身份证作为创建订单人
            String create_oper = cont_idcard; // 创建操作员ID
            String member_name = cont_nm; // 客户姓名

            String sourceId = "";
            String sourceNm = "";
            if (origin != null && "01".equals(origin.trim())) {
                sourceId = "01";
                sourceNm = "CALL CENTER";
            } else if (origin != null && "02".equals(origin.trim())) {
                sourceId = "02";
                sourceNm = "IVR";
            } else if (origin != null && "03".equals(origin.trim())) {
                sourceId = "03";
                sourceNm = "手机商城";
            }

            String cardType = getCardType(cardno);//获取账号标识
            Date d = DateTime.now().toDate();
            String create_date = DateHelper.getyyyyMMdd(d);
            String create_time = DateHelper.getHHmmss(d);
            List<Map<String, Object>> ordersTemp = Lists.newArrayList();// 临时的一个子订单集合

            OrderMainDto orderMainDto = new OrderMainDto();
            Map<String, Long> stockRestMap = Maps.newHashMap(); // 购买商品的数量
            List<Map<String, String>> promItemMap = null; // 活动信息
            PointPoolModel pointPoolModel = null; //积分池 ok
            
            if ("YG".equals(ordertype_id)) {// 暂时不支持一次性支付
                log.info("【MAL115】流水：" + model.getSenderSN() + "can not YG");
                ccAddOrderByCgbAddReturnVO.setReturnCode("000008");
                ccAddOrderByCgbAddReturnVO.setReturnDes("can not YG");
                return ccAddOrderByCgbAddReturnVO;
            }

            //判断CC工单号是否重复
            Response<List<String>> response = orderQueryService.findOrderMainIdByAcceptedNo(michelleId);
            if (response.isSuccess()) {
                List<String> orderMainIds = response.getResult();
                if (orderMainIds != null && orderMainIds.size() > 0) {//如果系统已经存在受理号
                    log.info("【MAL115】流水：" + model.getSenderSN() + "michelleId is already existence,michelleId:" + michelleId);
                    ccAddOrderByCgbAddReturnVO.setReturnCode("000056");
                    ccAddOrderByCgbAddReturnVO.setReturnDes("系统已经存在受理号" + michelleId);
                    return ccAddOrderByCgbAddReturnVO;
                }
            }

            //调用个人网银接口查出客户号
            User user = new User();
            if (cont_idcard != null && !"".equals(cont_idcard.trim())) {
                try {
                    QueryUserInfo userInfo = new QueryUserInfo();
                    userInfo.setCertNo(cont_idcard);
                    UserInfo cousrtomInfo = userService.getCousrtomInfo(userInfo);
                    user.setId(cousrtomInfo.getCustomerId());
                    if (cousrtomInfo != null && "0000".equals(cousrtomInfo.getRetCode())) {//如果个人网银返回正确
                        create_oper = cousrtomInfo.getCustomerId();
                        member_name = cousrtomInfo.getCustomerName();
                    }
                } catch (Exception e) {//如果连接异常
                    log.info("【MAL115】流水：" + model.getSenderSN() + "调用个人网银接口eBOT04失败");
                    ccAddOrderByCgbAddReturnVO.setReturnCode("000050");
                    ccAddOrderByCgbAddReturnVO.setReturnDes("连接个人网银失败");
                    return ccAddOrderByCgbAddReturnVO;
                }
            }
            
            // 检验商品总数量是否大于99
            int goods_numCount = 0;
            for (int i = 0; i < content.getGoods().size(); i++) {
                String goods_num = content.getGoods().get(i).getGoodsNum();
                int goods_numi = Integer.parseInt(goods_num);
                goods_numCount = goods_numCount + goods_numi;
            }
            if (goods_numCount > 99) {// 如果大于99
                log.info("【MAL115】流水：" + model.getSenderSN() + "goods_numCount:" + goods_numCount);
                ccAddOrderByCgbAddReturnVO.setReturnCode("000047");
                ccAddOrderByCgbAddReturnVO.setReturnDes("goods_numCount greater than 99:" + "goods_numCount:" + goods_numCount);
                return ccAddOrderByCgbAddReturnVO;
            }
            int total_numi = Integer.parseInt(total_num);
            if (total_numi != goods_numCount) {// 如果商品总数不相等
                log.info("【MAL115】流水：" + model.getSenderSN() + "goods_numCount:" + goods_numCount + ",total_num:" + total_num);
                ccAddOrderByCgbAddReturnVO.setReturnCode("000048");
                ccAddOrderByCgbAddReturnVO.setReturnDes(model.getSenderSN() + "goods_numCount:" + goods_numCount + ",total_num:" + total_num);
                return ccAddOrderByCgbAddReturnVO;
            }

            // 如果需要发票，发票抬头不能为空
            if (is_invoice != null && "1".equals(is_invoice.trim())) {
                if (invoice == null || "".equals(invoice.trim())) {
                    ccAddOrderByCgbAddReturnVO.setReturnCode("000046");
                    ccAddOrderByCgbAddReturnVO.setReturnDes("发票抬头不能为空");
                    return ccAddOrderByCgbAddReturnVO;
                }
            }

            if ("YG".equals(ordertype_id)) {// 一期 检验总一期价格
                if (totvalueYG == null || "".equals(totvalueYG.trim())) {
                    log.info("【MAL115】流水：" + model.getSenderSN() + "ordertype_id:" + ordertype_id + " totvalueYG:" + totvalueYG);
                    ccAddOrderByCgbAddReturnVO.setReturnCode("000008");
                    ccAddOrderByCgbAddReturnVO.setReturnDes("ordertype_id:" + ordertype_id + " totvalueYG:" + totvalueYG);
                    return ccAddOrderByCgbAddReturnVO;
                }
            } else {// 分期 检验总分期价格
                if (totvalueFQ == null || "".equals(totvalueFQ.trim())) {
                    log.info("【MAL115】流水：" + model.getSenderSN() + "ordertype_id:" + ordertype_id + " totvalueFQ:" + totvalueFQ);
                    ccAddOrderByCgbAddReturnVO.setReturnCode("000008");
                    ccAddOrderByCgbAddReturnVO.setReturnDes("ordertype_id:" + ordertype_id + " totvalueFQ:" + totvalueFQ);
                    return ccAddOrderByCgbAddReturnVO;
                }
            }

            String orderMainid = idGenarator.orderMainId(origin);// 大订单号 (origin 渠道)
            log.info("【MAL115】流水：" + model.getSenderSN() + "orderMainid:" + orderMainid);
            String totalBonus = "0";//大订单积分总数
            if (!"".equals(discountPrivilege)) {
                totalBonus = String.valueOf(total_numi * Integer.parseInt(discountPrivilege));
            }

            // 组装大订单
            OrderMainModel tblOrderMain = new OrderMainModel();
            tblOrderMain.setOrdermainId(orderMainid);// id
            tblOrderMain.setOrdertypeId(ordertype_id);
            tblOrderMain.setOrdertypeNm("乐购业务");
            tblOrderMain.setSerialNo(idGenarator.orderSerialNo());
            tblOrderMain.setCardno(cardno);
            tblOrderMain.setPermLimit(BigDecimal.ZERO);// 永久额度（默认0）
            tblOrderMain.setCashLimit(BigDecimal.ZERO);// 取现额度（默认0）
            tblOrderMain.setStagesLimit(BigDecimal.ZERO);// 分期额度（默认0）
            tblOrderMain.setSourceId(sourceId);// 订购渠道（下单渠道）
            tblOrderMain.setSourceNm(sourceNm);// 渠道名称
            tblOrderMain.setTotalNum(new Integer(total_num));// 商品总数量
            tblOrderMain.setTotalBonus(new Long(totalBonus));// 商品总积分数量
            tblOrderMain.setTotalIncPrice(BigDecimal.ZERO);// 商品总手续费价格（无用）
            tblOrderMain.setLockedFlag("0");// 订单锁标记（锁住订单，订单成功后解锁，解锁才能退货）
            tblOrderMain.setCreateTime(d);// 创建时间
            tblOrderMain.setCreateOper(create_oper);// 创建操作员ID 需要从网银获取
            tblOrderMain.setContIdType(cont_id_type);// 订货人证件类型
            tblOrderMain.setContIdcard(cont_idcard);// 订货人证件号码
            tblOrderMain.setContNm(cont_nm);// 订货人姓名
            tblOrderMain.setContNmPy(cont_nm_py);// 订货人姓名拼音
            tblOrderMain.setContPostcode(cont_postcode);// 订货人邮政编码
            tblOrderMain.setContAddress(cont_address);// 订货人详细地址
            tblOrderMain.setContMobPhone(cont_mob_phone);// 订货人手机
            tblOrderMain.setContHphone(cont_hphone);// 订货人家里电话
            tblOrderMain.setCsgName(csg_name);// 收货人姓名
            tblOrderMain.setCsgPostcode(csg_postcode);// 收货人邮政编码
            tblOrderMain.setCsgAddress(csg_address);// 收货人详细地址
            tblOrderMain.setCsgPhone1(csg_phone1);// 收货人电话一
            tblOrderMain.setCsgPhone2(csg_phone2);// 收货人电话二
            tblOrderMain.setBpCustGrp(bp_cust_grp);// 送货时间
            tblOrderMain.setInvoice(invoice);// 发票抬头
            tblOrderMain.setReserved1(invoice_type);// 发票类型
            tblOrderMain.setIsInvoice(is_invoice);// 是否需要发票：invoice_sta,0-不需要,1-需要
            tblOrderMain.setInvoiceContent(invoice_content);// 发票内容
            tblOrderMain.setOrdermainDesc(ordermain_desc);// 备注
            tblOrderMain.setCommDate(create_date);// 业务日期
            tblOrderMain.setCommTime(create_time);// 业务时间
            tblOrderMain.setAcctAddFlag(acct_add_flag);// 收货地址是否是帐单地址 0:否 1:是
            tblOrderMain.setCustSex(cust_sex);// 性别
            tblOrderMain.setCustEmail(cust_email);
            tblOrderMain.setCsgProvince(csg_province);// 省
            tblOrderMain.setCsgCity(csg_city);// 市
            tblOrderMain.setCsgBorough(csg_borough);// 区
            tblOrderMain.setAcceptedNo(michelleId);//CC工单号
            tblOrderMain.setMerId(merchId);// 大商户号
            tblOrderMain.setBonusDiscount(new BigDecimal(discountPrivMon));
            tblOrderMain.setVoucherDiscount(new BigDecimal(privilegeMoney));
            tblOrderMain.setEUpdateStatus("0");// 插入订单状态更新接口标志位 0:初始化 1：更新成功 2：更新失败
            if ("YG".equals(ordertype_id)) {// 一期
                tblOrderMain.setTotalPrice(new BigDecimal(totvalueYG));
                tblOrderMain.setCurStatusId("0301");// 状态
                tblOrderMain.setCurStatusNm("待付款");//
            } else {// 分期
                tblOrderMain.setTotalPrice(new BigDecimal(totvalueFQ));
                tblOrderMain.setCurStatusId("0301");// 状态
                tblOrderMain.setCurStatusNm("待付款");//
            }
            tblOrderMain.setPsFlag("");// 空或0:vmi没同步过，1:vmi同步过
            tblOrderMain.setDelFlag(0);

            List<OrderSubModel> tblOrders = Lists.newArrayList();// 子订单
            List<OrderDoDetailModel> orderDodetails = Lists.newArrayList();// 历史信息
            List<TblOrderExtend1Model> tblOrderExtend1List = Lists.newArrayList();// 子订单extend1

            long order_id = new Long(orderMainid + "01").longValue();// 小订单id
            BigDecimal price = new BigDecimal("0");// 用来算总价格的
            long bonus_total = 0;
            for (int i = 0; i < content.getGoods().size(); i++) {
                String goods_id = content.getGoods().get(i).getGoodsId(); //单品id
                String goods_num = content.getGoods().get(i).getGoodsNum();
                String goods_payway_id = content.getGoods().get(i).getGoodsPaywayId();

                // 取得单品对象信息
                Response<ItemModel> itemModelResponse = itemService.findInfoById(goods_id);
                if (!itemModelResponse.isSuccess()) {
                    throw new RuntimeException(itemModelResponse.getError());
                }
                ItemModel itemModel = itemModelResponse.getResult();
                // 取得商品对象
                Response<GoodsModel> goodsModelResponse = goodsService.findById(itemModel.getGoodsCode());
                if (!goodsModelResponse.isSuccess()) {
                    throw new RuntimeException(goodsModelResponse.getError());
                }
                GoodsModel tblGoodsInf = goodsModelResponse.getResult();

                if (tblGoodsInf == null) {// 如果找不到商品
                    log.info("【MAL115】流水：" + model.getSenderSN()
                            + "can not query good,goods_id:" + goods_id);
                    ccAddOrderByCgbAddReturnVO.setReturnCode("000031");
                    ccAddOrderByCgbAddReturnVO.setReturnDes("can not query good,goods_id:" + goods_id);
                    return ccAddOrderByCgbAddReturnVO;
                }

                if (!"02".equals(tblGoodsInf.getChannelCc())) {// 如果商品不是商城上架状态
                    log.info("【MAL115】流水：" + model.getSenderSN() + "," + goods_id + "商品不是CC上架状态");
                    ccAddOrderByCgbAddReturnVO.setReturnCode("000036");
                    ccAddOrderByCgbAddReturnVO.setReturnDes("goods is not onshell CC,goods_id:" + goods_id);
                    return ccAddOrderByCgbAddReturnVO;
                }

                Date beginDate = tblGoodsInf.getOnShelfCcDate();// cc商城商品开始时间
                Date endDate = tblGoodsInf.getAutoOffShelfTime(); // 商品有效期结束时间
                if (beginDate.after(nowDate) || endDate.before(nowDate)) {
                    ccAddOrderByCgbAddReturnVO.setReturnCode("000033");
                    ccAddOrderByCgbAddReturnVO.setReturnDes("nowDate is not in indate,nowDate:"
                            + nowDate.toString() + "  beginDate:" + beginDate.toString() + "  endDate:" + endDate.toString());
                    return ccAddOrderByCgbAddReturnVO;
                }

                // 取得支付方式对象
                Response<TblGoodsPaywayModel> goodsPayWayInfo = goodsPayWayService.findGoodsPayWayInfo(goods_payway_id);
                if (!goodsPayWayInfo.isSuccess()) {
                    throw new RuntimeException(goodsPayWayInfo.getError());
                }
                TblGoodsPaywayModel tblGoodsPayway = goodsPayWayInfo.getResult();

                if (tblGoodsPayway == null) {// 如果找不到支付方式
                    log.info("【MAL115】流水：" + model.getSenderSN() + "can not query tblGoodsPayway,goods_payway_id:" + goods_payway_id);
                    ccAddOrderByCgbAddReturnVO.setReturnCode("000016");
                    ccAddOrderByCgbAddReturnVO.setReturnDes("can not query tblGoodsPayway,goods_payway_id:" + goods_payway_id);
                    return ccAddOrderByCgbAddReturnVO;
                }

                if ("d".equals(tblGoodsPayway.getIscheck()) || "D".equals(tblGoodsPayway.getIscheck())) {// 如果支付方式已被删除
                    log.info("【MAL115】流水：" + model.getSenderSN() + "goods_payway_id is d, goods_payway_id:" + goods_payway_id);
                    ccAddOrderByCgbAddReturnVO.setReturnCode("000016");
                    ccAddOrderByCgbAddReturnVO.setReturnDes("goods_payway_id is d, goods_payway_id:" + goods_payway_id);
                    return ccAddOrderByCgbAddReturnVO;
                }
                // 单品id
                if (!tblGoodsPayway.getGoodsId().equals(itemModel.getCode())) {// 如果支付方式跟商品不对应
                    log.info("【MAL115】流水：" + model.getSenderSN() + "goods_id and goods_payway_id is not match, goods_id:"
                            + goods_id + "   goods_payway_id:" + goods_payway_id);
                    ccAddOrderByCgbAddReturnVO.setReturnCode("000032");
                    ccAddOrderByCgbAddReturnVO.setReturnDes("goods_id and goods_payway_id is not match, goods_id:" + goods_id
                            + "   goods_payway_id:" + goods_payway_id);
                    return ccAddOrderByCgbAddReturnVO;
                }

                if (tblGoodsPayway.getStagesCode() != null && tblGoodsPayway.getStagesCode() > 1 && "YG".equals(ordertype_id.trim())) {// 如果是一期报文但支付方式是分期价格时
                    log.info("【MAL115】流水：" + model.getSenderSN() + "envolope is YG, goodsPaywayId:"
                            + tblGoodsPayway.getGoodsPaywayId() + "   StagesCode:"
                            + tblGoodsPayway.getStagesCode());
                    ccAddOrderByCgbAddReturnVO.setReturnCode("000040");
                    ccAddOrderByCgbAddReturnVO.setReturnDes("envolope is YG, goodsPaywayId:" + tblGoodsPayway.getGoodsPaywayId()
                            + "   StagesCode:" + tblGoodsPayway.getStagesCode());
                    return ccAddOrderByCgbAddReturnVO;
                }
                // 查询供应商信息
                Response<VendorInfoModel> modelResponse = vendorService.findVendorInfosByVendorId(tblGoodsInf.getVendorId());
                VendorInfoModel tblVendorInf = modelResponse.getResult();
                if (tblVendorInf == null) {// 如果不存在相应的合作商
                    log.info("【MAL115】流水：" + model.getSenderSN() + "tblVendorInf  is not exist, vendorId:" + tblGoodsInf.getVendorId());
                    ccAddOrderByCgbAddReturnVO.setReturnCode("000034");
                    ccAddOrderByCgbAddReturnVO.setReturnDes("tblVendorInf  is not exist, vendorId:" + tblGoodsInf.getVendorId());
                    return ccAddOrderByCgbAddReturnVO;
                }

                // 获取活动信息
                Response<MallPromotionResultDto> promotionResponse =  mallPromotionService.findPromByItemCodes("0", goods_id, sourceId);
                MallPromotionResultDto mallPromotionResultDto = null;
                List<TblGoodsPaywayModel> tblGoodsPaywayModels = null;
                if (promotionResponse.isSuccess() && promotionResponse.getResult()!=null) {
                	if (promItemMap == null) {
                		promItemMap = Lists.newArrayList();
					}
                	mallPromotionResultDto = promotionResponse.getResult();
                	tblGoodsPaywayModels = (List<TblGoodsPaywayModel>) mallPromotionResultDto.getTblGoodsPaywayModelList();
                	Map<String, String> promItem = Maps.newHashMap();
                	promItem.put("promId",mallPromotionResultDto.getId().toString());
                	promItem.put("periodId",mallPromotionResultDto.getPeriodId());
                	promItem.put("itemCode",goods_id);
                	promItem.put("itemCount",goods_num);
                	promItemMap.add(promItem);
				}
                
                int goods_num_i = Integer.parseInt(goods_num);// 购买的商品数量

                // 检测商品数量
                Integer goods_backlog = itemModel.getStock() != null ? itemModel.getStock().intValue() : 0;// 实际库存
                Integer alert_num = itemModel.getStockWarning() != null ? itemModel.getStockWarning().intValue():0;// 库存警戒值
                int goods_backlogI = goods_backlog - goods_num_i;// 扣减后的商品数量
                if (goods_backlogI < 0) {// 如果扣除商品数量后库存不足
                    log.info("【MAL115】流水：" + model.getSenderSN() + "," + goods_id + "商品库存不足");
                    ccAddOrderByCgbAddReturnVO.setReturnCode("000035");
                    ccAddOrderByCgbAddReturnVO.setReturnDes("goods_backlog is below alert_num,  goods_backlog:"
                            + goods_backlog + " alert_num:" + alert_num + " goods_backlogI:" + goods_backlogI);
                    return ccAddOrderByCgbAddReturnVO;
                }

                //判断积分池是否满足
                if (!"".equals(discountPrivilege)) {
                    Response<PointPoolModel> curMonthInfo = pointsPoolService.getCurMonthInfo();
                    if (curMonthInfo.isSuccess()) {
                        pointPoolModel = curMonthInfo.getResult();
                        if (pointPoolModel != null) {
                            Long usedPoint = pointPoolModel.getUsedPoint();
                            Long maxPoint = pointPoolModel.getMaxPoint();
                            if (maxPoint - usedPoint <= 0) {
                                ccAddOrderByCgbAddReturnVO.setReturnCode("000070");
                                ccAddOrderByCgbAddReturnVO.setReturnDes("积分池不足");
                                return ccAddOrderByCgbAddReturnVO;
                            }
                        }
                    }
                }

                String actType = "0";
                

                // 组装小订单
                for (int j = 0; j < goods_num_i; j++) {
                    /*********处理优惠券积分抵扣金额*******/
                    String newPerStage = String.valueOf(tblGoodsPayway.getPerStage());
                    String newGoodsPrice = String.valueOf(tblGoodsPayway.getGoodsPrice());
                    log.info("扣减前的商品价格：" + newGoodsPrice);
                    if (!"".equals(discountPrivMon)) {
                        newGoodsPrice = dataSubtract(newGoodsPrice, discountPrivMon);
                    }
                    if (!"".equals(privilegeMoney) && j == 0) {
                        newGoodsPrice = dataSubtract(newGoodsPrice, privilegeMoney);
                    }
                    String stagesCode = tblGoodsPayway.getStagesCode() == null ? "1" : tblGoodsPayway.getStagesCode().toString();
                    newPerStage = calGoodsPriceForDiv(newGoodsPrice, stagesCode);
                    log.info("扣减后的商品价格：" + newGoodsPrice + "每期价格：" + newPerStage);
                    // 增加判断优惠券积分抵扣后如果价格小于0则返回给前端：订单金额有误
                    BigDecimal bdNewGoodsPrice = new BigDecimal(newGoodsPrice);
                    if (bdNewGoodsPrice.compareTo(BigDecimal.ZERO) == -1) {
                        log.info("【MAL115】流水：" + model.getSenderSN() + "," + "newGoodsPrice:" + newGoodsPrice);
                        ccAddOrderByCgbAddReturnVO.setReturnCode("000088");
                        ccAddOrderByCgbAddReturnVO.setReturnDes("订单金额有误");
                        return ccAddOrderByCgbAddReturnVO;
                    }
                    //Map<String, Object> map = Maps.newHashMap();
                    OrderSubModel tblOrder = new OrderSubModel();
                    tblOrder.setOrdermainId(tblOrderMain.getOrdermainId());
                    tblOrder.setOrderId(String.valueOf(order_id));
                    tblOrder.setOrderIdHost(idGenarator.orderSerialNo());
                    tblOrder.setOperSeq(new Integer(0));
                    tblOrder.setOrdertypeId(ordertype_id);
                    tblOrder.setOrdertypeNm(tblOrderMain.getOrdertypeNm());
                    tblOrder.setPaywayCode("0001");// 支付方式代码
                    // 0001：现金
                    // 0002：积分
                    // 0003：积分+现金
                    tblOrder.setPaywayNm("");// 支付方式名称 未完成
                    tblOrder.setCardno(cardno);// 卡号
                    tblOrder.setVerifyFlag("");// 下单验证标记
                    tblOrder.setVendorId(tblGoodsInf.getVendorId());// 供应商代码
                    tblOrder.setVendorSnm(tblVendorInf.getFullName());// 供应商名称全称
                    tblOrder.setSourceId(tblOrderMain.getSourceId());// 渠道代码
                    tblOrder.setSourceNm(tblOrderMain.getSourceNm());// 渠道名称
                    tblOrder.setGoodsId(goods_id);// 商品代码
                    tblOrder.setGoodsCode(tblGoodsInf.getCode());
                    tblOrder.setGoodsPaywayId(goods_payway_id);// 商品支付编码
                    tblOrder.setGoodsNum(1);// 商品数量
                    tblOrder.setGoodsNm(tblGoodsInf.getName());// 商品名称
                    tblOrder.setCurrType("156");// 商品币种
                    tblOrder.setExchangeRate(new BigDecimal(100));// 对人民币的汇率值
                    tblOrder.setGoodssendFlag("0");// 发货标记
                    tblOrder.setGoodsaskforFlag("0");// 请款标记
                    tblOrder.setSpecShopnoType("");// 特店类型
                    tblOrder.setPayTypeNm("");// 佣金代码名称
                    tblOrder.setIncCode("");// 手续费率代码
                    tblOrder.setIncCodeNm("");// 手续费名称
                    tblOrder.setStagesNum(tblGoodsPayway.getStagesCode());// 现金[或积分]分期数
                    tblOrder.setCommissionType("");// 佣金计算类别
                    tblOrder.setCommissionRate(BigDecimal.ZERO);// 佣金区间佣金率(不包含%)
                    tblOrder.setCommission(BigDecimal.ZERO);// 佣金金额【与币种一致】
                    tblOrder.setCalMoney(tblGoodsPayway.getCalMoney());// 清算总金额
                    tblOrder.setOrigMoney(BigDecimal.ZERO);// 原始现金总金额
                    tblOrder.setTotalMoney(new BigDecimal(newGoodsPrice));// 现金总金额
                    tblOrder.setIncWay("00");// 手续费获取方式
                    tblOrder.setIncRate(BigDecimal.ZERO);// 手续费率(不包含%)
                    tblOrder.setIncMoney(BigDecimal.ZERO);// 手续费总金额
                    tblOrder.setInstallmentPrice(new BigDecimal(newGoodsPrice));
                    tblOrder.setUitfeeflg(0);// 手续费减免期数
                    tblOrder.setUitfeedam(BigDecimal.ZERO);// 手续费减免金额
                    tblOrder.setUitdrtuit(0);// 本金减免期数
                    BigDecimal uitdrtamt = new BigDecimal(0);
                    tblOrder.setIncBackPrice(BigDecimal.ZERO);// 手续费退回指定金额
//                    tblOrder.setOrder_succ_time(tblOrderMain.getCreateTime());//xiewl 20161021
                    //*************************优惠券、积分改造begin**************************
                    //原来字段无用，优惠券需求中积分抵扣扣金额
                    if (!"".equals(discountPrivilege)) {
                        long pointValue = Long.valueOf(discountPrivilege);
                        if (pointValue == 0) {
                            discountPrivMon = "0";
                        }
                        uitdrtamt = new BigDecimal(discountPrivMon);
                    }
                    tblOrder.setUitdrtamt(uitdrtamt);// 本金减免金额
                    //优惠券需求中抵扣积分 存入订单表的单个小订单对应的积分字段（在积分商城下单中的定义）
                    if ("".equals(discountPrivilege)) {
                        discountPrivilege = "0";
                    }
                    bonus_total = bonus_total + Long.valueOf(discountPrivilege).longValue();
                    tblOrder.setSingleBonus(Long.valueOf(discountPrivilege));//单个商品对应的积分数
                    tblOrder.setBonusTotalvalue(Long.valueOf(discountPrivilege));// 积分总数
                    tblOrder.setIntegraltypeId(pointType);
                    //优惠券需求改动
                    if (j == 0) {//因CC每次交易优惠券只有一张，因此放在第一个小订单中
                        tblOrder.setVoucherNo(privilegeId);//优惠券编号
                        tblOrder.setVoucherNm(privilegeName);//优惠券名称
                        if (!"".equals(privilegeMoney)) {
                            tblOrder.setVoucherPrice(new BigDecimal(privilegeMoney));// 优惠金额
                        } else {
                            tblOrder.setVoucherPrice(BigDecimal.ZERO);// 由于此字段非空，因此必须传默认值
                        }
                    } else {
                        tblOrder.setVoucherPrice(BigDecimal.ZERO);// 由于此字段非空，因此必须传默认值
                        tblOrder.setVoucherNo("");//由于在电子支付做校验，因此此字段需默认传空
                    }
                    //*************************优惠券、积分改造end**************************

                    tblOrder.setCreditFlag("");// 授权额度不足处理方式
                    tblOrder.setCalWay("");// 退货方式
                    tblOrder.setLockedFlag("0");// 订单锁标记
                    tblOrder.setVendorOperFlag("0");// 供应商操作标记
                    tblOrder.setCurStatusId(tblOrderMain.getCurStatusId());// 当前状态代码
                    tblOrder.setCurStatusNm(tblOrderMain.getCurStatusNm());// 当前状态名称
                    tblOrder.setCreateOper(create_oper);// 创建操作员ID
                    tblOrder.setCreateTime(tblOrderMain.getCreateTime());// 创建时间
                    tblOrder.setVersionNum(new Integer(0));// 记录更新控制版本号
                    tblOrder.setGoodsType(tblGoodsInf.getGoodsType());// 商品类别ID
                    tblOrder.setMemberName(member_name); // 会员姓名
                    tblOrder.setMiaoshaActionFlag(0);
                    // 数据库非必输字段
                    tblOrder.setMerId(tblVendorInf.getMerId());// 小商户号
                    tblOrder.setTypeId(tblGoodsInf.getGoodsType());// 商品类别ID
                    tblOrder.setLevelNm("");// 商品类别名称
                    tblOrder.setGoodsBrand(tblGoodsInf.getGoodsBrandName());// 品牌
                    tblOrder.setGoodsModel("");// 型号
                    tblOrder.setGoodsColor("");// 商品颜色
                    tblOrder.setActType(actType);// 活动类型
                    tblOrder.setGoodsPresent(tblGoodsInf.getGiftDesc());// 赠品
                    tblOrder.setBonusTrnDate(create_date);// 支付日期
                    tblOrder.setBonusTrnTime(create_time);// 支付时间
                    tblOrder.setModifyTime(nowDate);// 修改时间
                    tblOrder.setTmpStatusId("0000");// 临时状态代码
                    tblOrder.setCommDate(create_date);// 业务日期
                    tblOrder.setCommTime(create_time);// 业务时间
                    tblOrder.setGoodssendFlag("0");// 发货标记 0－未发货[默认] 1－已发货 2－已签收
                    tblOrder.setIncTakePrice(tblGoodsPayway.getPerStage());// 分期价格
                    tblOrder.setIncTakePrice(new BigDecimal(newPerStage));// 分期价格
                    // 退单时收取指定金额手续费
                    tblOrder.setEUpdateStatus("0");// 插入订单状态更新接口标志位 0:初始化 1：更新成功
                    // 2：更新失败
                    tblOrder.setCardtype(cardType);// 借记卡信用卡标识 未明

                    tblOrder.setSinglePrice(new BigDecimal(newGoodsPrice));// 单价
                    tblOrder.setCurStatusId(tblOrderMain.getCurStatusId());
                    tblOrder.setCurStatusNm(tblOrderMain.getCurStatusNm());

                    // 保存邮购分期类别码
                    tblOrder.setSpecShopno(tblGoodsPayway.getCategoryNo());
                    // 保存银联商户号
                    tblOrder.setReserved1(tblVendorInf.getUnionPayNo());

                    // 新增信用卡移动门户专属客户端需求（二期）start,增加商品属性一、属性二
                    tblOrder.setGoodsAttr1(itemModel.getWxProp1());//商品属性一
                    tblOrder.setGoodsAttr2(itemModel.getWxProp2());//商品属性二
                    // 新增信用卡移动门户专属客户端需求（二期） end
                    tblOrder.setDelFlag("0");
                    tblOrder.setRemindeFlag(0);
                    tblOrder.setO2oExpireFlag(0);
                    tblOrder.setFenefit(BigDecimal.ZERO);
                    
                    tblOrders.add(tblOrder);
                    // 插入历史表
                    OrderDoDetailModel tblOrderDodetail = new OrderDoDetailModel();
                    tblOrderDodetail.setOrderId(tblOrder.getOrderId());
                   
                    tblOrderDodetail.setDoTime(tblOrder.getCreateTime());
                    tblOrderDodetail.setDoUserid(tblOrder.getCreateOper());
                    tblOrderDodetail.setUserType("3");
                    tblOrderDodetail.setStatusId(tblOrder.getCurStatusId());
                    tblOrderDodetail.setStatusNm(tblOrder.getCurStatusNm());
                    tblOrderDodetail.setMsgContent("");
                    tblOrderDodetail.setDoDesc("乐购下单");
                    // 必填字段
                    tblOrderDodetail.setCreateOper("");
                    tblOrderDodetail.setCreateTime(tblOrder.getCreateTime());
                    tblOrderDodetail.setDelFlag(0);
                    orderDodetails.add(tblOrderDodetail);
                    order_id++;
                    price = price.add(new BigDecimal(newGoodsPrice.toString()));
                    //插入tblOrderExtend1表
                    TblOrderExtend1Model tblOrderExtend1 = new TblOrderExtend1Model();
                    tblOrderExtend1.setOrderId(tblOrder.getOrderId());
                    tblOrderExtend1.setCreator(creator);
                    tblOrderExtend1.setMichelleid(michelleId);
                    tblOrderExtend1.setIncomingtel(incomingTel);
                    tblOrderExtend1.setRegulator(regulator);
                    tblOrderExtend1List.add(tblOrderExtend1);
                }
                stockRestMap.put(goods_id, new Long(goods_num));
                tblOrderMain.setTotalBonus(bonus_total);
                // 检测总价
                if ("YG".equals(ordertype_id)) {// 一期 检验总一期价格
                    if (price.compareTo(new BigDecimal(totvalueYG)) != 0) {// 如果总价格不相等
                        log.info("【MAL115】流水：" + model.getSenderSN()
                                + "," + "price:" + price + " totvalueYG:" + totvalueYG);
                        ccAddOrderByCgbAddReturnVO.setReturnCode("000041");
                        ccAddOrderByCgbAddReturnVO.setReturnDes("price:" + price + " totvalueYG:" + totvalueYG);
                        return ccAddOrderByCgbAddReturnVO;
                    }
                } else {// 分期 检验总分期价格
                    if (price.compareTo(new BigDecimal(totvalueFQ)) != 0) {// 如果总价格不相等
                        log.info("【MAL115】流水：" + model.getSenderSN() + "," + "price:" + price + " totvalueFQ:" + totvalueFQ);
                        ccAddOrderByCgbAddReturnVO.setReturnCode("000041");
                        ccAddOrderByCgbAddReturnVO.setReturnDes("price:" + price + " totvalueFQ:" + totvalueFQ);
                        return ccAddOrderByCgbAddReturnVO;
                    }
                }

                try {
                	orderMainDto.setPointPoolModel(pointPoolModel);
                	orderMainDto.setStockRestMap(stockRestMap);
                	orderMainDto.setPromItemMap(promItemMap);
                	Response<Boolean> saveOrderResponse =  restOrderService.saveYGOrder(tblOrderMain, tblOrders, orderDodetails, orderMainDto, user);
                	if (!saveOrderResponse.isSuccess()) {
                		ccAddOrderByCgbAddReturnVO.setReturnCode("000027");
                        ccAddOrderByCgbAddReturnVO.setReturnDes("数据库操作异常");
                        return ccAddOrderByCgbAddReturnVO;
					}
                } catch (Exception e) {
                    log.error("【MAL115】流水：" + model.getSenderSN() + ","
                            + "exception", e);
                    ccAddOrderByCgbAddReturnVO.setReturnCode("000027");
                    ccAddOrderByCgbAddReturnVO.setReturnDes("数据库操作异常");
                    return ccAddOrderByCgbAddReturnVO;
                }


                //分期调用bps分期
                if (!"".equals(privilegeId) || (!"0".equals(discountPrivilege) && !"".equals(discountPrivilege))) {
                	tblOrders = orderChannelService.payFQOrder(tblOrderMain, tblOrders, validDate);
                }
                List<String> orderSubIds = Lists.newArrayList();
                try {// 发起ops分期订单申请
                    if ("FQ".equals(ordertype_id)) {// 分期
                        for (OrderSubModel tblOrder : tblOrders) {
                        	Map<String, Object> map = Maps.newHashMap();
                            /**如果现金部分为0，并且是走新流程,则不调用BPS的接口，直接处理为支付成功*/
                            BigDecimal comResult = tblOrder.getTotalMoney() == null ? new BigDecimal("0") : tblOrder.getTotalMoney();
                            if (BigDecimal.ZERO.compareTo(comResult) == 0) {//如果现金部分为0
                                try {
                                    //更新扩展表中发去给bps的状态和时间
                                    TblOrderExtend1Model tblOrderExtend1 = new TblOrderExtend1Model();
                                    tblOrderExtend1.setOrderId(tblOrder.getOrderId());
                                    tblOrderExtend1.setExtend1("1");
                                    tblOrderExtend1.setExtend2(DateHelper.getCurrentDate());
                                    orderService.updateTblOrderExtend1(tblOrderExtend1);
                                } catch (Exception e) {
                                    log.error("【MAL115】流水：" + model.getSenderSN() + ","
                                            + "exception", e);
                                    ccAddOrderByCgbAddReturnVO.setReturnCode("000027");
                                    ccAddOrderByCgbAddReturnVO.setReturnDes("数据库操作异常");
                                    return ccAddOrderByCgbAddReturnVO;
                                }
                                StagingRequestResult returnGateWayEnvolopeVo = new StagingRequestResult();
                                returnGateWayEnvolopeVo.setErrorCode("0000");// Bps返回的错误码
                                returnGateWayEnvolopeVo.setApproveResult("0010");// Bps返回的返回码0000-全额 0010-逐期 0100-拒绝 0200-转人工 0210-异常转人工
                                returnGateWayEnvolopeVo.setFollowDir(content.getForceTransfer());//后续流转方向0-不流转 1-流转
                                returnGateWayEnvolopeVo.setCaseId("");// BPS工单号
                                returnGateWayEnvolopeVo.setSpecialCust("");//是否黑灰名单 0-黑名单 1-灰名单 2-其他
                                returnGateWayEnvolopeVo.setReleaseType("");//释放类型
                                returnGateWayEnvolopeVo.setRejectcode("");//拒绝代码
                                returnGateWayEnvolopeVo.setAprtcode("");//逐期代码
                                returnGateWayEnvolopeVo.setOrdernbr("00000000000");//核心订单号、银行订单号:  默认11个0
                                /**如果现金部分为0，并且是走新流程，则不调用BPS的接口，直接处理为支付成功 --大机补充需求 mod by dengbing end */
                                map.put("tblOrder", tblOrder);
                                map.put("returnGateWayEnvolopeVo", returnGateWayEnvolopeVo);
                                ordersTemp.add(map);
                            } else {//如果现金部分不为0或者走旧流程 ，调用BPS的接口
                                log.info("【MAL115】流水：" + model.getSenderSN() + "orderId:" + tblOrder.getOrderId());
                                StagingRequest sendGateWayEnvolopeVo = new StagingRequest();
                                sendGateWayEnvolopeVo.setSrcCaseId(tblOrder.getOrderId());
                                sendGateWayEnvolopeVo.setInterfaceType("0");
                                sendGateWayEnvolopeVo.setCardnbr(cardno);
                                sendGateWayEnvolopeVo.setIdNbr(tblOrderMain.getContIdcard());
                                sendGateWayEnvolopeVo.setChannel(channel);//CC
                                sendGateWayEnvolopeVo.setProject("");
                                sendGateWayEnvolopeVo.setRequestType(requestType);
                                sendGateWayEnvolopeVo.setCaseType("0500");
                                sendGateWayEnvolopeVo.setSubCaseType("0501");
                                sendGateWayEnvolopeVo.setCreator(creator);//CC操作员员工号
                                sendGateWayEnvolopeVo.setBookDesc(tblOrderMain.getCsgPhone1());
                                sendGateWayEnvolopeVo.setReceiveMode(receiveMode);
                                sendGateWayEnvolopeVo.setAddr(tblOrderMain.getCsgProvince() + tblOrderMain.getCsgCity() + tblOrderMain.getCsgBorough() + tblOrderMain.getCsgAddress());//省+市+区+详细地址
                                sendGateWayEnvolopeVo.setPostcode(tblOrderMain.getCsgPostcode());
                                sendGateWayEnvolopeVo.setDrawer(tblOrderMain.getInvoice());
                                sendGateWayEnvolopeVo.setSendCode(sendCode);
                                sendGateWayEnvolopeVo.setRegulator(regulator);
                                sendGateWayEnvolopeVo.setSmsnotice(smsnotice);
                                sendGateWayEnvolopeVo.setSmsPhone(Smsphone);
                                sendGateWayEnvolopeVo.setContactNbr1(csg_phone1);
                                sendGateWayEnvolopeVo.setContactNbr2(csg_phone2);
                                sendGateWayEnvolopeVo.setSbookid(tblOrderMain.getOrdermainId());
                                sendGateWayEnvolopeVo.setBbookid("");
                                sendGateWayEnvolopeVo.setReservation("0");
                                sendGateWayEnvolopeVo.setReserveTime("");
                                sendGateWayEnvolopeVo.setCerttype("");// CC为空
                                sendGateWayEnvolopeVo.setUrgentLvl(urgentLvl);
                                sendGateWayEnvolopeVo.setMichelleId(michelleId);
                                sendGateWayEnvolopeVo.setOldBankId("");
                                sendGateWayEnvolopeVo.setProductCode(itemModel.getMid());
                                sendGateWayEnvolopeVo.setProductName(tblOrder.getGoodsNm());
                                sendGateWayEnvolopeVo.setPrice(tblGoodsPayway.getGoodsPrice());//商品总价
                                sendGateWayEnvolopeVo.setColor(tblOrder.getGoodsColor());
                                sendGateWayEnvolopeVo.setAmount("1");
                                sendGateWayEnvolopeVo.setSumAmt(tblOrder.getTotalMoney());
                                sendGateWayEnvolopeVo.setSuborderid(tblOrder.getOrderId());
                                sendGateWayEnvolopeVo.setFirstPayment(BigDecimal.ZERO);
                                sendGateWayEnvolopeVo.setBills(String.valueOf(tblOrder.getStagesNum()));
                                sendGateWayEnvolopeVo.setPerPeriodAmt(tblOrder.getIncTakePrice());
                                sendGateWayEnvolopeVo.setSupplierCode(tblOrder.getVendorId());
                                
                                Response<TblVendorRatioModel> response1 = vendorService.findRatioByVendorId(tblOrder.getVendorId(), tblOrder.getStagesNum());
                                TblVendorRatioModel vendorRatio = response1.getResult();
                                Response<VendorInfoModel> response2 = vendorService.findVendorInfosByVendorId(tblOrder.getVendorId());
                                VendorInfoModel vendor = response2.getResult();
                                vendorRatioMessage(sendGateWayEnvolopeVo, vendorRatio, vendor, String.valueOf(tblOrder.getTotalMoney()));

                                sendGateWayEnvolopeVo.setRecommendCardnbr("");
                                sendGateWayEnvolopeVo.setRecommendname("");
                                sendGateWayEnvolopeVo.setRecommendCerttype("");
                                sendGateWayEnvolopeVo.setRecommendid("");
                                sendGateWayEnvolopeVo.setPrevCaseId(prevCaseId);
                                sendGateWayEnvolopeVo.setCustName(tblOrderMain.getContNm());//订货人姓名
                                sendGateWayEnvolopeVo.setIncomingTel(incomingTel);//来电号码
                                sendGateWayEnvolopeVo.setPresentName(tblGoodsInf.getGiftDesc());
                                sendGateWayEnvolopeVo.setOrdermemo(Ordermemo);
                                sendGateWayEnvolopeVo.setMemo(memo);
                                sendGateWayEnvolopeVo.setForceTransfer(forceTransfer);
                                sendGateWayEnvolopeVo.setSupplierName(supplierName);
                                sendGateWayEnvolopeVo.setOldBankId(oldBankId);
                                sendGateWayEnvolopeVo.setSupplierDesc(supplierDesc);
                                sendGateWayEnvolopeVo.setPresentName(presentname);
                                sendGateWayEnvolopeVo.setRecommendCardnbr(recommendCardnbr);
                                sendGateWayEnvolopeVo.setRecommendname(recommendname);
                                sendGateWayEnvolopeVo.setRecommendid(recommendid);
                                sendGateWayEnvolopeVo.setReceiveName(tblOrderMain.getCsgName());
                                sendGateWayEnvolopeVo.setMerchantCode("");//特店号暂时约定传空

                                sendGateWayEnvolopeVo.setAcceptAmt(tblOrder.getTotalMoney()); //申请分期金额
                                String FAVORABLETYPE = "";//优惠类型
                                BigDecimal DEDUCTAMT = BigDecimal.ZERO;//抵扣金额
                                if (tblOrder.getVoucherNo() != null && !"".equals(tblOrder.getVoucherNo())) {
                                    FAVORABLETYPE = "01";
                                    DEDUCTAMT = tblOrder.getVoucherPrice();
                                }
                                if (tblOrder.getBonusTotalvalue() != null && tblOrder.getBonusTotalvalue().longValue() != 0) {
                                    FAVORABLETYPE = "02";
                                    DEDUCTAMT = tblOrder.getUitdrtamt();
                                }
                                if ((tblOrder.getVoucherNo() != null && !"".equals(tblOrder.getVoucherNo())) && (tblOrder.getBonusTotalvalue() != null && tblOrder.getBonusTotalvalue().longValue() != 0)) {
                                    FAVORABLETYPE = "03";
                                    //金额的计算需要转化成BigDecimal计算
                                    DEDUCTAMT = tblOrder.getVoucherPrice().add(tblOrder.getUitdrtamt());
                                }
                                if ((tblOrder.getVoucherNo() == null || "".equals(tblOrder.getVoucherNo())) && (tblOrder.getBonusTotalvalue() == null || tblOrder.getBonusTotalvalue().longValue() == 0)) {
                                    FAVORABLETYPE = "00";
                                }
                                sendGateWayEnvolopeVo.setFavorableType(FAVORABLETYPE);//优惠类型
                                sendGateWayEnvolopeVo.setDeductAmt(DEDUCTAMT);//抵扣金额

                                List<FinancialInfo> financialInfos = new ArrayList<>();
                                for (int j = 0; j < content.getProps().size(); j++) {
                                    FinancialInfo financialInfo = new FinancialInfo();
                                    financialInfo.setPropType(content.getProps().get(j).getPropType());
                                    financialInfo.setPropSubType(content.getProps().get(j).getPropSubtype());
                                    financialInfo.setPropValue(content.getProps().get(j).getPropValue());
                                    financialInfo.setPropOwner(content.getProps().get(j).getPropOwner());
                                    financialInfo.setPropMemo(content.getProps().get(j).getPropMemo());
                                    financialInfos.add(financialInfo);
                                }
                                sendGateWayEnvolopeVo.setFinancialInfos(financialInfos);

                                StagingRequestResult returnGateWayEnvolopeVo = stagingRequestService.getStagingRequest(sendGateWayEnvolopeVo);
                                log.info("收到结果:{}", returnGateWayEnvolopeVo.toString());
                                log.info("支付返回值状态码retCode ---------{}",returnGateWayEnvolopeVo.getRetCode());

                                try {
                                    //更新扩展表中发去给bps的状态和时间
                                    TblOrderExtend1Model tblOrderExtend1Model = new TblOrderExtend1Model();
                                    tblOrderExtend1Model.setExtend1("1");
                                    tblOrderExtend1Model.setExtend2(DateHelper.getCurrentTime());
                                    tblOrderExtend1Model.setOrderId(tblOrder.getOrderId());
                                    tblOrderExtend1Model.setOrdernbr(returnGateWayEnvolopeVo.getOrdernbr());
                                    orderService.updateTblOrderExtend1(tblOrderExtend1Model);
                                } catch (Exception e) {
                                    log.error("【MAL115】流水：" + model.getSenderSN() + "," + "exception", e);
                                    ccAddOrderByCgbAddReturnVO.setReturnCode("000027");
                                    ccAddOrderByCgbAddReturnVO.setReturnDes("数据库操作异常");
                                    return ccAddOrderByCgbAddReturnVO;
                                }

                                map.put("tblOrder", tblOrder);
                                map.put("returnGateWayEnvolopeVo", returnGateWayEnvolopeVo);
                                ordersTemp.add(map);
                            }
                            orderSubIds.add(tblOrder.getOrderId());
                        }
                    }
                } catch (Exception e) {// 如果连bps报异常，订单状态不做修改，等待状态回查
                    log.info("【MAL115】流水：" + model.getSenderSN() + "调用ops分期申请接口失败!");
                    log.error("exception", e);
                }

                if ("FQ".equals(ordertype_id)) {// 分期
                    log.info("【MAL115】流水：" + model.getSenderSN() + "分期");
                    try {
                        orderChannelService.dealFQorderBpswithTX(tblOrderMain, ordersTemp, tblOrderExtend1List);//处理bps分期支付信息
                        //020业务与商城供应商平台对接 ,当更新订单信息后，进行O2O推送处理
                        for (String orderSubId : orderSubIds) {							
                        	dealO2OOrderService.dealO2OOrdersAfterPaySucc(StringUtil.dealNull(orderSubId));
						}
                    } catch (Exception e) {
                        log.info("【MAL115】流水：" + model.getSenderSN() + "操作数据库异常");
                        log.error("exception", e);
                        ccAddOrderByCgbAddReturnVO.setReturnCode("000027");
                        ccAddOrderByCgbAddReturnVO.setReturnDes("数据库操作异常");
                        return ccAddOrderByCgbAddReturnVO;
                    }
                }

                // 返回报文
                ccAddOrderByCgbAddReturnVO.setReturnCode("000000");
                ccAddOrderByCgbAddReturnVO.setReturnDes("");
                ccAddOrderByCgbAddReturnVO.setOrderMainId(tblOrderMain.getOrdermainId());
                log.info("【MAL115】流水：" + model.getSenderSN() + "ordersTemp size:" + ordersTemp.size());
                List<CCAddOrderByCgbAddDetailReturnVO> orders = new ArrayList<CCAddOrderByCgbAddDetailReturnVO>();
                for (int ix = 0; ix < ordersTemp.size(); ix++) {
                    CCAddOrderByCgbAddDetailReturnVO returnVO = new CCAddOrderByCgbAddDetailReturnVO();
                    Map<String, Object> map = (Map<String, Object>) ordersTemp.get(ix);
                    OrderSubModel tblOrder = (OrderSubModel) map.get("tblOrder");
                    StagingRequestResult returnGateWayEnvolopeVo = (StagingRequestResult) map.get("returnGateWayEnvolopeVo");
                    returnVO.setOrderId(tblOrder.getOrderId());
                    if (returnGateWayEnvolopeVo != null) {
                        returnVO.setErrCode(returnGateWayEnvolopeVo.getErrorCode());
                    }
                    String curStatusId = tblOrder.getCurStatusId();// 商城当前订单状态
                    if ("0308".equals(curStatusId) || "0305".equals(curStatusId)) {// 如果当前状态是支付成功或处理中,返回成功
                        returnVO.setOrderReturnCode("000000");
                    } else {// 否则返回超时
                        log.info("【MAL115】流水：" + model.getSenderSN() + "," + tblOrder.getOrderId() + ":交易超时");
                        returnVO.setOrderReturnCode("000006");
                    }
                    returnVO.setCurStatusId(curStatusId);
                    if (returnGateWayEnvolopeVo != null) {
                        returnVO.setApproveResult(returnGateWayEnvolopeVo.getApproveResult());
                        returnVO.setFollowDir(returnGateWayEnvolopeVo.getFollowDir());
                        returnVO.setApproveSumLimit(String.valueOf(returnGateWayEnvolopeVo.getApproveSumLimit()));
                        returnVO.setApproveAprtLimit(String.valueOf(returnGateWayEnvolopeVo.getApproveAprtLimit()));
                        returnVO.setAprtunPayamt(String.valueOf(returnGateWayEnvolopeVo.getAprtUnPayAmt()));
                        returnVO.setCurRusefulamt(String.valueOf(returnGateWayEnvolopeVo.getCurrUsefulAmt()));
                        returnVO.setSaveAmt(returnGateWayEnvolopeVo.getSaveAmt());
                        returnVO.setCaseId(returnGateWayEnvolopeVo.getCaseId());
                        returnVO.setSpecialCust(returnGateWayEnvolopeVo.getSpecialCust());
                        returnVO.setSysIndicateMsg(returnGateWayEnvolopeVo.getSysIndicateMsg());
                        returnVO.setSpareMsg1(returnGateWayEnvolopeVo.getSpareMsg());
                        returnVO.setRejuctReason(returnGateWayEnvolopeVo.getRejuctReason());
                        returnVO.setDecisionCode(returnGateWayEnvolopeVo.getDecisionCode());
                        returnVO.setNodeCode(returnGateWayEnvolopeVo.getNodeCode());
                        returnVO.setReleaseType(returnGateWayEnvolopeVo.getReleaseType());
                        returnVO.setRejectCode(returnGateWayEnvolopeVo.getRejectcode());
                        returnVO.setAprtCode(returnGateWayEnvolopeVo.getAprtcode());
                        DecimalFormat df=new DecimalFormat("0.00");
                        returnVO.setPerpayAmt(returnGateWayEnvolopeVo.getPerpayamt()==null?"":df.format(returnGateWayEnvolopeVo.getPerpayamt()));
                        returnVO.setOrderNbr(returnGateWayEnvolopeVo.getOrdernbr());
                    }
                    orders.add(returnVO);
                }
                ccAddOrderByCgbAddReturnVO.setOrders(orders);
            }
        } catch (Exception e) {
            log.error("exception", e);
            ccAddOrderByCgbAddReturnVO.setReturnCode("000009");
            ccAddOrderByCgbAddReturnVO.setReturnDes("系统异常");
            return ccAddOrderByCgbAddReturnVO;

        }
        return ccAddOrderByCgbAddReturnVO;
    }

    /**
     * 获取帐号类型 C：信用卡  Y：借记卡
     *
     * @param account
     * @return
     */
    public static String getCardType(String account) {
        if (account == null || "".equals(account.trim())) {
            return "";
        } else if (account.trim().length() == 16) {// 信用卡
            return "C";
        } else {//借记卡
            return "Y";
        }
    }

    /**
     * 计算两个值相减的结果
     *
     * @param value1
     * @param value2
     * @return
     * @throws Exception
     */
    public static String dataSubtract(String value1, String value2) throws Exception {
        String returnVal = "";
        try {
            returnVal = new BigDecimal(value1).subtract(new BigDecimal(value2)).toString();
            return returnVal;
        } catch (Exception e) {
            throw new Exception("金额转换错误");
        }
    }

    /**
     * 两数据相除,保留两位小数
     * 除数 value1
     * 被除数 value2
     *
     * @return
     * @throws Exception
     */
    public static String calGoodsPriceForDiv(String dataStr1, String dataStr2) throws Exception {
        BigDecimal value1 = new BigDecimal(dataStr1);
        BigDecimal value2 = new BigDecimal(dataStr2);
        BigDecimal resuleVal = new BigDecimal(0);
        try {
            if (value2.compareTo(new BigDecimal(0)) != 0) {
                resuleVal = value1.divide(value2, 2, BigDecimal.ROUND_HALF_UP);
            }
        } catch (Exception e) {
            throw new Exception("数字转换错误");
        }
        return resuleVal.toString();
    }

    /**
     * 将电子支付优惠券支付结果以List返回
     *
     * @param orders
     * @return
     * @throws Exception
     */
    private List<Map<String, Object>> paraOrders(String orders) throws Exception {
        if ("".equals(orders)) {
            throw new Exception("orders is null");
        }
        if (orders.endsWith("|")) {//如果最后一个域为空，则加上结束符#以方便处理
            orders = orders + "#";
        }
        log.info("需要解析的orders:" + orders);
        String[] ordersArray = orders.split("\\|");
        log.info("ordersArray:" + ordersArray.length);
        List<Map<String, Object>> rList = Lists.newArrayList();
        if (ordersArray.length % 6 == 0) {
            for (int i = 0; i < ordersArray.length; i = i + 6) {
                log.info("ordersArray[" + i + "]:" + ordersArray[i]);
                Map<String, Object> map = Maps.newHashMap();
                map.put("tradeSeqNo", ordersArray[i]);
                map.put("merId", ordersArray[i + 1]);
                map.put("orderId", ordersArray[i + 2]);
                map.put("result", ordersArray[i + 3]);
                map.put("errcode", ordersArray[i + 4]);
                String errdesc = ordersArray[i + 5];
                if ("#".equals(ordersArray[i + 5])) {
                    errdesc = "";
                }
                map.put("errdesc", errdesc);
                // 增加goodsId，为了后面回滚库存
                OrderSubModel orderSubModel = orderService.findOrderId(String.valueOf(map.get("orderId")));
                map.put("goodsId", orderSubModel.getGoodsId());
                rList.add(map);
            }
        }
        return rList;
    }

    /**
     * 配合信用卡大机改造BP0005接口新增字段-接口工程公共方法
     *
     * @param sendGateWayEnvolopeVo
     * @param vendorRatio
     * @param vendor
     * @param totalMoney
     */
    public static void vendorRatioMessage(StagingRequest sendGateWayEnvolopeVo, TblVendorRatioModel vendorRatio, VendorInfoModel vendor, String totalMoney) {
        if (vendorRatio != null) {
            sendGateWayEnvolopeVo.setFixedFeeHTFlag(vendorRatio.getFixedfeehtFlag());
            sendGateWayEnvolopeVo.setFixedAmtFee(vendorRatio.getFixedamtFee() == null ? new BigDecimal(0) : vendorRatio.getFixedamtFee().setScale(2, BigDecimal.ROUND_DOWN));
            sendGateWayEnvolopeVo.setFeeRatio1(vendorRatio.getFeeratio1() == null ? new BigDecimal(0) : vendorRatio.getFeeratio1().setScale(5, BigDecimal.ROUND_DOWN));
            sendGateWayEnvolopeVo.setRatio1Precent(vendorRatio.getRatio1Precent() == null ? new BigDecimal(0) : vendorRatio.getRatio1Precent().setScale(2, BigDecimal.ROUND_DOWN));
            sendGateWayEnvolopeVo.setFeeRatio2(vendorRatio.getFeeratio2() == null ? new BigDecimal(0) : vendorRatio.getFeeratio2().setScale(5, BigDecimal.ROUND_DOWN));
            sendGateWayEnvolopeVo.setRatio2Precent(vendorRatio.getRatio2Precent() == null ? new BigDecimal(0) : vendorRatio.getRatio2Precent().setScale(2, BigDecimal.ROUND_DOWN));
            sendGateWayEnvolopeVo.setFeeRatio2Bill(vendorRatio.getFeeratio2Bill());
            sendGateWayEnvolopeVo.setFeeRatio3(vendorRatio.getFeeratio3() == null ? new BigDecimal(0) : vendorRatio.getFeeratio3().setScale(5, BigDecimal.ROUND_DOWN));
            sendGateWayEnvolopeVo.setRatio3Precent(vendorRatio.getRatio3Precent() == null ? new BigDecimal(0) : vendorRatio.getRatio3Precent().setScale(2, BigDecimal.ROUND_DOWN));
            sendGateWayEnvolopeVo.setFeeRatio3Bill(vendorRatio.getFeeratio3Bill());
            sendGateWayEnvolopeVo.setReducerateFrom(vendorRatio.getReducerateFrom());
            sendGateWayEnvolopeVo.setReducerateTo(vendorRatio.getReducerateTo());
            sendGateWayEnvolopeVo.setReduceHandingFee(vendorRatio.getReducerate());
            sendGateWayEnvolopeVo.setHtFlag(vendorRatio.getHtflag());
            //如果“首尾付本金”(HTCAPITAL)大于现金金额(tblOrder.getTotalMoney())，默认送现金金额，如果小于等于现金金额,就送首尾付本金值--大机补充需求 mod by dengbing start
            String htcapital = "";
            BigDecimal TotalMoneyDe = null;
            if (!StringUtils.isEmpty(totalMoney)) {
                TotalMoneyDe = new BigDecimal(totalMoney);
            }
            if (vendorRatio.getHtant() == null || TotalMoneyDe == null) {
                htcapital = vendorRatio.getHtant() == null ? "" : String.valueOf(vendorRatio.getHtant().setScale(2, BigDecimal.ROUND_DOWN));
            } else {
                int compareResult = vendorRatio.getHtant().compareTo(TotalMoneyDe);
                if (compareResult > 0) {//“首尾付本金”(HTCAPITAL)大于现金金额(tblOrder.getTotalMoney())，送现金金额
                    htcapital = String.valueOf(TotalMoneyDe.setScale(2, BigDecimal.ROUND_DOWN));
                } else {//如果小于等于现金金额,就送首尾付本金值
                    htcapital = String.valueOf(vendorRatio.getHtant().setScale(2, BigDecimal.ROUND_DOWN));
                }
            }
            sendGateWayEnvolopeVo.setHtCapital(new BigDecimal(htcapital));
        }
        if (vendor != null) {
            //虚拟特店号
            sendGateWayEnvolopeVo.setVirtualStore(vendor.getVirtualVendorId());
        }
    }


}
