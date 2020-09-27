package cn.com.cgbchina.restful.provider.service.order;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.generator.IdGenarator;
import cn.com.cgbchina.item.model.GoodsModel;
import cn.com.cgbchina.item.model.ItemModel;
import cn.com.cgbchina.item.model.TblGoodsPaywayModel;
import cn.com.cgbchina.item.service.GoodsPayWayService;
import cn.com.cgbchina.item.service.GoodsService;
import cn.com.cgbchina.item.service.ItemService;
import cn.com.cgbchina.item.dto.MallPromotionResultDto;
import cn.com.cgbchina.item.model.PromotionRangeModel;
import cn.com.cgbchina.item.service.MallPromotionService;
import cn.com.cgbchina.related.model.TblCfgProCodeModel;
import cn.com.cgbchina.related.service.CfgProCodeService;
import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.vo.order.WXYX020FreeOrderQueryVO;
import cn.com.cgbchina.rest.provider.vo.order.WXYX020FreeOrderReturnVO;
import cn.com.cgbchina.trade.model.OrderDoDetailModel;
import cn.com.cgbchina.trade.model.OrderMainModel;
import cn.com.cgbchina.trade.model.OrderOutSystemModel;
import cn.com.cgbchina.trade.model.OrderSubModel;
import cn.com.cgbchina.trade.service.PayService;
import cn.com.cgbchina.user.model.VendorInfoModel;
import cn.com.cgbchina.user.service.VendorService;
import com.google.common.base.Throwables;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import com.spirit.exception.ResponseException;
import com.spirit.user.User;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * MAL423 微信易信O2O合作商0元秒杀下单 从soap对象生成的vo转为 接口调用的bean
 *
 * @author Lizy
 */
@Service
@TradeCode(value = "MAL423")
@Slf4j
public class WXYX020FreeOrderAddProvideServiceImpl implements SoapProvideService<WXYX020FreeOrderQueryVO, WXYX020FreeOrderReturnVO> {

    @Resource
    ItemService itemService;

    @Resource
    GoodsService goodsService;

    @Resource
    private IdGenarator idGenarator;

    @Resource
    MallPromotionService mallPromotionService;

    @Resource
    VendorService vendorService;

    @Resource
    GoodsPayWayService goodsPayWayService;

    @Resource
    CfgProCodeService cfgProCodeService;

    @Resource
    PayService payService;

    @Value("#{app.merchId}")
    private String orderMerchentId;

    /**
     * 微信易信O2O合作商0元秒杀下单
     * @param model
     * @param content 购买参数
     * @return 请求结果
     *
     * geshuo 20160818
     */
    @Override
    public WXYX020FreeOrderReturnVO process(SoapModel<WXYX020FreeOrderQueryVO> model, WXYX020FreeOrderQueryVO content) {
        WXYX020FreeOrderReturnVO result = new WXYX020FreeOrderReturnVO();//定义返回结果

        //取得参数
//		Date nowDate = new Date();
        String origin = content.getOrigin();//发起方
        String ordertype_id = content.getOrdertypeId();//订单类型 YG:一期支付   FQ：分期支付(默认YG)
//		String totvalueYG = content.getTotvalueYG();//一次性的商品总价
        int total_num = Integer.parseInt(content.getTotalNum());//商品总数量
        String create_oper = content.getCreateOper();//登录客户号
        String cont_id_type = content.getContIdType();//订货人证件类型
        String cont_idcard = content.getContIdcard();//订货人证件号码
        String cont_nm = content.getContNm();//订货人姓名
        String cont_mob_phone = content.getContMobPhone();//订货人手机
        String csg_name = content.getCsgName();//收货人姓名
        String csg_phone1 = content.getCsgPhone1();//收货人手机
        String cardno = content.getCardno();//卡号
        String goods_id = content.getGoodsId();//商品编码
        int goods_num = Integer.parseInt(content.getGoodsNum());//商品数量
        String goods_payway_id = content.getGoodsPaywayId();//支付方式id

        log.debug("【MAL423】流水： start...");
        try {
            if (goods_num != 1) {// 如果商品数量不为1，拒绝
                log.debug("【MAL423】流水：商品数量 goods_num = {}", goods_num);
                result.setReturnCode("000073");
                result.setReturnDes("一次只能买一件商品");
                return result;
            }
            if (total_num != 1) {// 如果商品数量不为1，拒绝
                log.debug("【MAL423】流水：商品总数量 total_num = {}", total_num);
                result.setReturnCode("000073");
                result.setReturnDes("一次只能买一件商品");
                return result;
            }

            log.debug("【MAL423】流水： 执行find goods sql start...");


            //查询单品表，查单品信息
            ItemModel itemModel = itemService.findById(goods_id);
            if (itemModel == null) {// 如果找不到商品
                log.debug("【MAL423】流水：未找到商品{}", goods_id);
                result.setReturnCode("000031");
                result.setReturnDes("找不到商品");
                return result;
            }

            Response<GoodsModel> goodsResponse = goodsService.findById(itemModel.getGoodsCode());
            if (!goodsResponse.isSuccess()) {
                result.setReturnCode("000009");
                result.setReturnDes("系统异常");
                return result;
            }
            GoodsModel goodsModel = goodsResponse.getResult();
            if (goodsModel == null) {// 如果找不到商品
                log.debug("【MAL423】流水：未找到商品{}", goods_id);
                result.setReturnCode("000031");
                result.setReturnDes("找不到商品");
                return result;
            }

            //根据goods_payway_id，goods_id查询商品支付方式表
            Map<String,Object> payWayParamMap = Maps.newHashMap();
            payWayParamMap.put("goodsPaywayId",goods_payway_id);//支付方式id
            payWayParamMap.put("goodsId",goods_id);//单品编码
            Response<List<TblGoodsPaywayModel>> payWayResponse = goodsPayWayService.findGoodsPayWayByParams(payWayParamMap);
            if (!payWayResponse.isSuccess()) {
                result.setReturnCode("000009");
                result.setReturnDes("系统异常");
                return result;
            }
            List<TblGoodsPaywayModel> payWayList = payWayResponse.getResult();
            if(payWayList == null || payWayList.size() == 0){
                log.debug("【MAL423】流水：单品没有支付方式：goods_id{}", goods_id);
                result.setReturnCode("000031");
                result.setReturnDes("找不到商品");
                return result;
            }
            TblGoodsPaywayModel goodsPaywayModel = payWayList.get(0);//正常情况下只能取到一个

            //查询商品活动信息 type传1，代表只取得正在进行的活动
            Response<MallPromotionResultDto> promResponse = mallPromotionService.findPromByItemCodes("1", itemModel.getCode(), origin);
            if (!promResponse.isSuccess()) {
                result.setReturnCode("000075");
                result.setReturnDes("找不到对应活动信息");
                return result;
            }

            MallPromotionResultDto promotionResultDto = promResponse.getResult();
            if (promotionResultDto == null || promotionResultDto.getPromItemResultList() == null || promotionResultDto.getPromItemResultList().size() == 0) {
                log.debug("【MAL423】流水：单品没有参加活动：goods_id{}", goods_id);
                result.setReturnCode("000031");
                result.setReturnDes("找不到商品");
                return result;
            }
            PromotionRangeModel rangeModel = promotionResultDto.getPromItemResultList().get(0);
            Integer promotionId = promotionResultDto.getId();
            String periodId = promotionResultDto.getPeriodId();

            //查询供应商表，查供应商信息
            Response<VendorInfoModel> vendorResponse = vendorService.findVendorById(goodsModel.getVendorId());
            if (!vendorResponse.isSuccess()) {
                result.setReturnCode("000009");
                result.setReturnDes("系统异常");
                return result;
            }
            VendorInfoModel vendorInfoModel = vendorResponse.getResult();

            //原来需要查询商品类别表，前台类目表,现在不需要了
            log.debug("【MAL423】流水 执行find goods sql end.");

            String mallWXStatus = goodsModel.getChannelMallWx();//(String) goodsMap.get("WECHAT_STATUS");// 广发商城-微信状态
            String creditWxStatus = goodsModel.getChannelCreditWx(); //(String) goodsMap.get("WECHAT_A_STATUS");// 信用卡中心-微信状态
            String yixin_status = "0203";//(String) goodsMap.get("YIXIN_STATUS");// 易信状态
            String yixin_a_status = "0203";//(String) goodsMap.get("YIXIN_A_STATUS");// 易信状态

            //微信广发银行:05 微信广发信用卡:06 易信广发银行:07 易信广发信用卡:08
            if ("05".equals(origin)) {// 如果是微信广发银行
                if (!"02".equals(mallWXStatus)) {// 如果商品不是微信上架状态，返回错误
                    log.debug("【MAL423】流水：wechat_status:{}", mallWXStatus);
                    result.setReturnCode("000036");
                    result.setReturnDes("商品不是上架状态");
                    return result;
                }
            }
            if ("06".equals(origin)) {// 如果是微信广发信用卡
                if (!"02".equals(creditWxStatus)) {// 如果商品不是微信广发信用卡上架状态，返回错误
                    log.debug("【MAL423】流水：wechat_a_status:{}", creditWxStatus);
                    result.setReturnCode("000036");
                    result.setReturnDes("商品不是上架状态");
                    return result;
                }
            }
            if ("07".equals(origin)) {// 如果是易信渠道
                if (!"0203".equals(yixin_status)) {// 如果商品不是易信上架状态，返回错误
                    log.debug("【MAL423】流水：yixin_status:{}", yixin_status);
                    result.setReturnCode("000036");
                    result.setReturnDes("商品不是上架状态");
                    return result;
                }
            }
            if ("08".equals(origin)) {// 如果是易信渠道
                if (!"0203".equals(yixin_a_status)) {// 如果商品不是易信上架状态，返回错误
                    log.debug("【MAL423】流水：yixin_a_status:{}", yixin_a_status);
                    result.setReturnCode("000036");
                    result.setReturnDes("商品不是上架状态");
                    return result;
                }
            }

            Date nowDate = new Date();
            //判断是否在商品有效期间内
            Date beginDate = goodsModel.getOnShelfTime(); //(String) goodsMap.get("BEGIN_DATE");// 商品有效期开始时间
            Date endDate = goodsModel.getAutoOffShelfTime(); //(String) goodsMap.get("END_DATE");// 商品有效期结束时间
            if (!isBetween(nowDate, beginDate, endDate)) {// 如果不在有效期之内
                log.debug("【MAL423】流水：nowDate is not in indate,nowDate:{} ; beginDate:{}; endDate:{}", nowDate.toString(), beginDate, endDate);

                result.setReturnCode("000033");
                result.setReturnDes("该商品不在有效期内");
                return result;
            }

            if ("d".equals(goodsPaywayModel.getIscheck())
                    || "D".equals(goodsPaywayModel.getIscheck())) {// 如果支付方式已被删除
                log.debug("【MAL423】流水：goods_payway_id is delete, goods_payway_id:{}", goods_payway_id);
                result.setReturnCode("000016");
                result.setReturnDes("该支付方式已经删除");
                return result;
            }

            String vendorId = vendorInfoModel.getVendorId();// 合作商id

            //校验库存（通过活动提供的接口校验即可）
//			int goodsBacklog = (Integer) goodsMap.get("GOODS_BACKLOG");// 商品库存
//			// 检测商品数量
//			if (goodsBacklog < 1) {// 如果扣除商品数量后实际库存小于0
//				log.debug("【MAL423】流水：商品数量不足,goodsId:{}", goods_id);
//				result.setReturnCode("000074");
//				result.setReturnDes("商品数量不足");
//				return result;
//			}

            //判断活动类型
            Integer actType = promotionResultDto.getPromType();//活动类型
            if (actType == null || actType != 30 || rangeModel.getPrice().compareTo(new BigDecimal(0)) != 0) {
                // 如果不是O2O 0元秒杀活动
                //活动类型为空||活动类型不是秒杀||活动价格不是0
                log.debug("【MAL423】流水：goods_payway_id:{}", goods_payway_id);
                result.setReturnCode("000077");
                result.setReturnDes("此活动不是0元秒杀活动");
                return result;
            }

            String status = rangeModel.getCheckStatus();// 活动状态
            if (!"1".equals(status.trim())) {// 如果不是审核通过状态
                log.debug("【MAL423】流水：goods_payway_id:{}", goods_payway_id);
                result.setReturnCode("000078");
                result.setReturnDes("活动已停止或未审核通过");
                return result;
            }
            Integer isValid = rangeModel.getIsValid();// 删除状态
            if (0 == isValid) {// 如果活动已删除
                log.debug("【MAL423】流水：goods_payway_id:{}", goods_payway_id);
                result.setReturnCode("000079");
                result.setReturnDes("活动已删除");
                return result;
            }

            //判断是否处在活动期间，新代码取活动数据时已经做了判断，不需要再判断了
//			String weekDay = String.valueOf(DateUtil.dayForWeek(nowDate));// 获取当前是星期几
//			String actFrequency = (String) goodsMap.get("ACT_FREQUENCY");// 活动频率
//			if (!jugWeek(weekDay, actFrequency)) {// 如果活动频率判断不正确
//				log.debug("【MAL423】流水：weekDay:{};actFrequency:{}", weekDay,actFrequency);
//				result.setReturnCode("000076");
//				result.setReturnDes("活动不在活动期内");
//				return result;
//			}
//
//			String actBeginDate = (String) goodsMap.get("A_BEGIN_DATE");
//			String actEndDate = (String) goodsMap.get("A_END_DATE");
//			if (!isBetween(nowDate, actBeginDate + "000000", actEndDate + "235959")) {// 如果处在非活动日期
//				log.debug("【MAL423】流水：goods_payway_id:{} 活动未开始或者已过期",goods_payway_id);
//				result.setReturnCode("000037");
//				result.setReturnDes("该活动未开始或者已过期");
//				return result;
//			}

            // 通过活动提供的接口校验库存 ,每次只能买一个
            Response<Boolean> stockResponse = mallPromotionService.checkPromItemStock(String.valueOf(promotionId), periodId, goods_id, "1");
            if (!stockResponse.isSuccess()) {
                log.debug("【MAL423】流水：校验库存异常 promotionid:{},periodId:{},itemCode:{}", promotionId, periodId, goods_id);
                result.setReturnCode("000009");
                result.setReturnDes("系统异常");
                return result;
            }

            if (!stockResponse.getResult()) {
                log.debug("【MAL423】流水：活动商品数量不足 promotionid:{},periodId:{},itemCode:{}", promotionId, periodId, goods_id);
                result.setReturnCode("000038");
                result.setReturnDes("参加活动人数已满");
                return result;
            }

            // 判断限制次数
            // 购买限制,0：全活动时间段，1：每活动日
//            Integer buying_restrictions = (null == promotionResultDto.getRuleLimitBuyType()) ? 0 : promotionResultDto.getRuleLimitBuyType();
//            int limited_number = promotionResultDto.getRuleLimitBuyCount();// 限制次数
            log.debug("【MAL423】流水： 校验购买次数 start...");

            User user = new User();
            user.setId(create_oper);//用户id
            user.setCustId(create_oper);//客户号

            //通过活动提供的接口，校验该用户是否已经超过购买次数
            Response<Boolean> buyCountResponse = mallPromotionService.checkPromBuyCount(String.valueOf(promotionId), periodId, "1", user, itemModel.getCode());
            if (!buyCountResponse.isSuccess()) {
                log.debug("【MAL423】流水：校验用户购买次数失败 promotionId：{},periodId:{},cont_idcard:{}", promotionId, periodId, cont_idcard);
                result.setReturnCode("000009");
                result.setReturnDes("系统异常");
                return result;
            }

            if (!buyCountResponse.getResult()) {//该用户购买次数已经达到上限
                log.debug("【MAL423】流水：该用户购买次数已满promotionId：{},periodId:{},cont_idcard:{}", promotionId, periodId, cont_idcard);
                result.setReturnCode("000080");
                result.setReturnDes("购买次数已满");
                return result;
            }

            //原系统更新TBL_CUST_ACTION_TEMP，新系统不用这个表了，直接通过活动接口更新redis数据


            //同一个客户秒杀同一件商品在插入客户秒杀记录表（TBL_CUST_ACTION）之前，只能提交一次订单
            String typeId = goodsModel.getGoodsType();

            String orderMainid = idGenarator.orderMainId(origin); // 大订单号
            log.debug("【MAL423】流水：orderMainid:{}", orderMainid);
            // 组装大订单
            OrderMainModel tblOrderMain = new OrderMainModel();
            tblOrderMain.setOrdermainId(orderMainid);// id
            tblOrderMain.setOrdertypeId("YG");
            tblOrderMain.setOrdertypeNm("乐购业务");
            tblOrderMain.setCardno(cardno);
            tblOrderMain.setPermLimit(new BigDecimal(0));// 永久额度（默认0）
            tblOrderMain.setCashLimit(new BigDecimal(0));// 取现额度（默认0）
            tblOrderMain.setStagesLimit(new BigDecimal(0));// 分期额度（默认0）
            tblOrderMain.setSourceId(origin);// 订购渠道（下单渠道）
            tblOrderMain.setDelFlag(0);

            Map<String,Object> sourceQueryMap = Maps.newHashMap();//查询参数
            sourceQueryMap.put("ordertype_id","YG");//业务类型
            sourceQueryMap.put("proType","QD");//参数类型
            sourceQueryMap.put("proCode",origin);

            //查询订单渠道
            Response<List<TblCfgProCodeModel>> sourceResponse = cfgProCodeService.findProCodeByParams(sourceQueryMap);
            if(!sourceResponse.isSuccess()){
                log.debug("【MAL423】流水：查询订单渠道异常 origin:{}",origin);
                result.setReturnCode("000009");
                result.setReturnDes("系统异常");
                return result;
            }
            String sourceName = "";
            List<TblCfgProCodeModel> sourceList = sourceResponse.getResult();
            if(sourceList != null && sourceList.size() != 0){
                sourceName = sourceList.get(0).getProNm();//取得渠道名称
            }

//            conn = SpringUtil.getConnect();
//            if (SourceUtil.sourceYG == null) {
//                SourceUtil.InitYGSourceName(conn);
//            }
//            String sourceName = SourceUtil.GetSourceName(origin, "YG");
            tblOrderMain.setSourceNm(sourceName);
            tblOrderMain.setTotalNum(1);// 商品总数量
            tblOrderMain.setTotalBonus(0l);// 商品总积分数量
            tblOrderMain.setTotalIncPrice(new BigDecimal(0));// 商品总手续费价格（无用）
            tblOrderMain.setLockedFlag("0");// 订单锁标记（锁住订单，订单成功后解锁，解锁才能退货）
            Date d = new Date();
            tblOrderMain.setCreateTime(d);// 创建时间
            tblOrderMain.setModifyTime(d);
            tblOrderMain.setCreateOper(create_oper);// 创建操作员ID
            tblOrderMain.setContIdType(cont_id_type);// 订货人证件类型
            tblOrderMain.setContIdcard(cont_idcard);// 订货人证件号码
            tblOrderMain.setContNm(cont_nm);// 订货人姓名
            tblOrderMain.setContNmPy("");// 订货人姓名拼音
            tblOrderMain.setContPostcode("");// 订货人邮政编码
            tblOrderMain.setContAddress("");// 订货人详细地址
            tblOrderMain.setContMobPhone(cont_mob_phone);// 订货人手机
            tblOrderMain.setContHphone("");// 订货人家里电话
            tblOrderMain.setCsgName(csg_name);// 收货人姓名
            tblOrderMain.setCsgPostcode("");// 收货人邮政编码
            tblOrderMain.setCsgAddress("");// 收货人详细地址
            tblOrderMain.setCsgPhone1(csg_phone1);// 收货人电话一
            tblOrderMain.setCsgPhone2("");// 收货人电话二
            tblOrderMain.setBpCustGrp("");// 送货时间
            tblOrderMain.setInvoice("");// 发票抬头
            tblOrderMain.setReserved1("");// 发票类型
            tblOrderMain.setIsInvoice("");// 是否需要发票：invoice_sta,0-不需要,1-需要
            tblOrderMain.setInvoiceContent("");// 发票内容
            tblOrderMain.setOrdermainDesc("");// 备注
            tblOrderMain.setCommDate("");// 业务日期
            tblOrderMain.setCommTime("");// 业务时间
            tblOrderMain.setAcctAddFlag("");// 收货地址是否是帐单地址
            tblOrderMain.setCustSex("");// 性别
            tblOrderMain.setCustEmail("");
            tblOrderMain.setCsgProvince("");// 省
            tblOrderMain.setCsgCity("");// 市
            tblOrderMain.setCsgBorough("");// 区
            tblOrderMain.setMerId(orderMerchentId);// 大商户号
            tblOrderMain.setEUpdateStatus("0");// 插入订单状态更新接口标志位 0:初始化 1：更新成功 2：更新失败
            tblOrderMain.setTotalPrice(new BigDecimal(0));
            tblOrderMain.setCurStatusId("0308");// 状态
            tblOrderMain.setCurStatusNm("支付成功");//
            tblOrderMain.setPsFlag("");// 空或0:vmi没同步过，1:vmi同步过

            long order_id = Long.parseLong(orderMainid + "01");// 小订单id

            OrderSubModel tblOrder = new OrderSubModel();
            tblOrder.setOrdermainId(tblOrderMain.getOrdermainId());
            tblOrder.setOrderId(String.valueOf(order_id));
            tblOrder.setOperSeq(0);
            tblOrder.setOrdertypeId(ordertype_id);
            tblOrder.setOrdertypeNm(tblOrderMain.getOrdertypeNm());
            tblOrder.setPaywayCode("0001");// 支付方式代码
            // 0001：现金
            // 0002：积分
            // 0003：积分+现金
            tblOrder.setPaywayNm("");// 支付方式名称
            tblOrder.setCardno(cardno);// 卡号
            tblOrder.setVerifyFlag("");// 下单验证标记
            tblOrder.setVendorId(vendorId);// 供应商代码
            tblOrder.setVendorSnm(vendorInfoModel.getFullName());// 供应商名称简写(需求改为全称)
            tblOrder.setSourceId(tblOrderMain.getSourceId());// 渠道代码
            tblOrder.setSourceNm(tblOrderMain.getSourceNm());// 渠道名称
            tblOrder.setGoodsId(goods_id);// 商品代码
            tblOrder.setGoodsPaywayId(goods_payway_id);// 商品支付编码
            tblOrder.setGoodsNum(1);// 商品数量
            tblOrder.setGoodsNm(goodsModel.getName());// 商品名称
            tblOrder.setCurrType("156");// 商品币种
            tblOrder.setExchangeRate(new BigDecimal(100));// 对人民币的汇率值
            tblOrder.setGoodssendFlag("0");// 发货标记
            tblOrder.setGoodsaskforFlag("0");// 请款标记
            tblOrder.setSpecShopnoType("");// 特店类型
//			tblOrder.setPayType("");// 佣金代码
            tblOrder.setPayTypeNm("");// 佣金代码名称
            tblOrder.setIncCode("");// 手续费率代码
            tblOrder.setIncCodeNm("");// 手续费名称
            tblOrder.setStagesNum(goodsPaywayModel.getStagesCode());// 现金[或积分]分期数
            tblOrder.setCommissionType("");// 佣金计算类别
            tblOrder.setCommissionRate(new BigDecimal(0));// 佣金区间佣金率(不包含%)
            tblOrder.setCommission(new BigDecimal(0));// 佣金金额【与币种一致】
            tblOrder.setBonusTotalvalue(0l);// 积分总数
            tblOrder.setCalMoney(goodsPaywayModel.getCalMoney());// 清算总金额
            tblOrder.setOrigMoney(new BigDecimal(0));// 原始现金总金额
            tblOrder.setTotalMoney(goodsPaywayModel.getGoodsPrice());// 现金总金额
            tblOrder.setIncWay("00");// 手续费获取方式
            tblOrder.setIncRate(new BigDecimal(0));// 手续费率(不包含%)
            tblOrder.setIncMoney(new BigDecimal(0));// 手续费总金额
            tblOrder.setUitfeeflg(0);// 手续费减免期数
            tblOrder.setUitfeedam(new BigDecimal(0));// 手续费减免金额
            tblOrder.setUitdrtuit(0);// 本金减免期数
            tblOrder.setUitdrtamt(new BigDecimal(0));// 本金减免金额
            tblOrder.setIncBackPrice(new BigDecimal(0));// 手续费退回指定金额
            tblOrder.setVoucherPrice(new BigDecimal(0));// 优惠金额
            tblOrder.setCreditFlag("");// 授权额度不足处理方式
            tblOrder.setCalWay("");// 退货方式
            tblOrder.setLockedFlag("0");// 订单锁标记
            tblOrder.setVendorOperFlag("0");// 供应商操作标记
            tblOrder.setCurStatusId(tblOrderMain.getCurStatusId());// 当前状态代码
            tblOrder.setCurStatusNm(tblOrderMain.getCurStatusNm());// 当前状态名称
            tblOrder.setCreateOper(create_oper);// 创建操作员ID
            tblOrder.setCreateTime(tblOrderMain.getCreateTime());// 创建时间
            tblOrder.setModifyTime(tblOrderMain.getCreateTime());
            tblOrder.setVersionNum(0);// 记录更新控制版本号
            // 数据库非必输字段
            tblOrder.setMerId(vendorInfoModel.getVendorId());// 小商户号
            tblOrder.setTypeId(typeId);// 商品类别ID 商品类型（00实物01虚拟02O2O）
            if (Contants.SUB_ORDER_TYPE_00.equals(typeId)) {
                tblOrder.setLevelNm(Contants.GOODS_TYPE_NM_00);// 商品类别名称
            }
            if (Contants.SUB_ORDER_TYPE_01.equals(typeId)) {
                tblOrder.setLevelNm(Contants.GOODS_TYPE_NM_01);
            }
            if (Contants.SUB_ORDER_TYPE_02.equals(typeId)) {
                tblOrder.setLevelNm(Contants.GOODS_TYPE_NM_02);
            }
            tblOrder.setGoodsBrand(goodsModel.getGoodsBrandName());// 品牌
            tblOrder.setGoodsModel("");// 型号
            tblOrder.setGoodsColor("");// 商品颜色
            tblOrder.setActType(String.valueOf(actType));// 活动类型
            tblOrder.setGoodsPresent("");// 赠品
            tblOrder.setDelFlag("0");

            Date orderCreateDate = tblOrderMain.getCreateTime();
            String orderDateStr = DateHelper.getyyyyMMdd(orderCreateDate);
            String orderTimeStr = DateHelper.getHHmmss(orderCreateDate);
            tblOrder.setBonusTrnDate(orderDateStr);// 支付日期
            tblOrder.setBonusTrnTime(orderTimeStr);// 支付时间
            tblOrder.setModifyTime(tblOrderMain.getCreateTime());// 修改时间
            tblOrder.setTmpStatusId("0000");// 临时状态代码
            tblOrder.setCommDate(orderDateStr);// 业务日期
            tblOrder.setCommTime(orderTimeStr);// 业务时间
            tblOrder.setGoodssendFlag("0");// 发货标记 0－未发货[默认] 1－已发货 2－已签收
            tblOrder.setIncTakePrice(goodsPaywayModel.getPerStage());// 分期价格
            // 退单时收取指定金额手续费
            tblOrder.setEUpdateStatus("0");// 插入订单状态更新接口标志位 0:初始化 1：更新成功
            // 2：更新失败
            tblOrder.setCardtype("W");// 借记卡信用卡标识 未明
            tblOrder.setSinglePrice(goodsPaywayModel.getGoodsPrice());// 单价
            tblOrder.setCustCartId("0");// 购物车id
            tblOrder.setCurStatusId(tblOrderMain.getCurStatusId());
            tblOrder.setCurStatusNm(tblOrderMain.getCurStatusNm());
            tblOrder.setMiaoshaActionFlag(1);

            // 邮购分期类别码
            tblOrder.setSpecShopno(goodsPaywayModel.getCategoryNo());
            // 保存银联商户号
            tblOrder.setReserved1(vendorInfoModel.getUnionPayNo());
            tblOrder.setRemindeFlag(0);// 提醒发货标识（0 未提醒，1 已提醒，9 已发货）
            tblOrder.setO2oExpireFlag(0);// o2o已过期操作标志（0 未操作过，1 已操作过）

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
            tblOrderDodetail.setRuleId("");
            tblOrderDodetail.setRuleNm("");
            tblOrderDodetail.setDelFlag(0);
            tblOrderDodetail.setCreateOper(create_oper);
            // 更新客户秒杀记录表（TBL_CUST_ACTION）新系统没有这个表，直接更新redis数据
//			TblCustAction tblCustAction = new TblCustAction();
//			tblCustAction.setActionFlag((Integer) goodsMap
//					.get("MIAOSHA_ACTION"));
//			tblCustAction.setContIdcard(cont_idcard);// 客户证件号码
//			tblCustAction.setGoodsId(goods_id);
//			tblCustAction.setCreateDate(tblOrderMain.getCreateDate());
//			tblCustAction.setCreateTime(tblOrderMain.getCreateTime());

            OrderOutSystemModel tblOrderOutsystem = new OrderOutSystemModel();
            tblOrderOutsystem.setOrderId(tblOrder.getOrderId());
            tblOrderOutsystem.setOrderMainId(tblOrderMain.getOrdermainId());
            tblOrderOutsystem.setTimes(0);
            tblOrderOutsystem.setTuisongFlag("0");
            tblOrderOutsystem.setCreateTime(orderCreateDate);
            tblOrderOutsystem.setSystemRole("00");// O2O
            tblOrderOutsystem.setCreateOper("来自第三方0元秒杀");

            Map<String,String> orderParamMap = Maps.newHashMap();
            orderParamMap.put("promotionId",String.valueOf(promotionId));//活动id
            orderParamMap.put("periodId",periodId);//活动场次id
            orderParamMap.put("itemCode",goods_id);//单品id
            orderParamMap.put("buyCount","1");//购买数量
            try {
                payService.paywithTX(tblOrderMain, tblOrder, tblOrderDodetail,tblOrderOutsystem, user, orderParamMap);
            } catch (ResponseException e) {
                log.error("exception", Throwables.getStackTraceAsString(e));
                String code = e.getMessage();
                if ("000074".equals(code)) {// 商品数量不足
                    result.setReturnCode("000074");
                    result.setReturnDes("商品数量不足");
                    return result;
                } else if ("000009".equals(code)) {
                    result.setReturnCode("000009");
                    result.setReturnDes("系统异常");
                    return result;
                }
            }

            result.setReturnCode("000000");
            result.setReturnDes("下单成功");
            result.setOrdermainId(tblOrderMain.getOrdermainId());//大订单号
            result.setAmount("0");//订单金额
            result.setOrderId(tblOrder.getOrderId());//小订单号
            result.setCurStatusId(tblOrder.getCurStatusId());//订单状态
            log.debug("【MAL423】流水： end.");
        } catch (Exception e) {
            log.error("WXYX020FreeOrderAddProvideServiceImpl.process.error Exception:{}", Throwables.getStackTraceAsString(e));
            result.setReturnCode("000009");
            result.setReturnDes("系统异常");
        }
        return result;
    }


    /**
     * 判断date是否处在beginDate和endDate之间
     *
     * @param date      比较对象
     * @param beginDate 开始时间
     * @param endDate   结束时间
     * @return 比较结果
     */
    public static boolean isBetween(Date date, Date beginDate, Date endDate) {
//		Date theBeginDate = DateHelper.string2Date(beginDate, "yyyyMMdd");
//		Date theEndDate = DateHelper.string2Date(endDate, "yyyyMMdd");
        if (date.compareTo(beginDate) < 0) {//如果在beginDate之前
            return false;
        }
        //如果在theEndDate之后,返回false
        return date.compareTo(endDate) <= 0;
    }

}
