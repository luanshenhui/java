package cn.com.cgbchina.trade.service;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.item.model.*;
import cn.com.cgbchina.item.service.EspAreaInfService;
import cn.com.cgbchina.item.service.GoodsService;
import cn.com.cgbchina.item.service.ItemService;
import cn.com.cgbchina.item.service.XnlpService;
import cn.com.cgbchina.trade.dao.OrderSubDao;
import cn.com.cgbchina.trade.dao.OrderVirtualDao;
import cn.com.cgbchina.trade.model.OrderSubModel;
import cn.com.cgbchina.trade.model.OrderVirtualModel;
import com.google.common.base.Throwables;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.elasticsearch.common.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.*;

/**
 * Created by shangqinbin on 2016/8/10.
 */
@Service
@Slf4j
public class PriorJudgeServiceImpl implements PriorJudgeService {

	@Autowired
	private ItemService itemService;
	@Autowired
	private GoodsService goodsService;
	@Autowired
	private EspAreaInfService espAreaInfService;
	@Autowired
	private OrderVirtualDao orderVirtualDao;
	@Autowired
	private OrderSubDao orderSubDao;
	@Autowired
	private XnlpService xnlpService;
	// 留学生旅行意外险
	@Value("${lxsyxGoods}")
	private String lxsyxGoods;
	// 真情卡保险
	@Value("${zqbxGoods}")
	private String zqbxGoods;
	// 标准卡保险
	@Value("${bzbxGoods}")
	private String bzbxGoods;
	// 车主卡保险
	@Value("${czbxGoods}")
	private String czbxGoods;
	// 道路救援
	@Value("${dljyGoods}")
	private String dljyGoods;
	// 附属卡礼品
	@Value("${attachedGoods}")
	private String attachedGoods;
	// 红利卡兑换免签帐额调整
	@Value("${hongliCardChange}")
	private String hongliCardChange;
	// 年费调整
	@Value("${nianfeiChange}")
	private String nianfeiChange;
	// 移动充值卡
	@Value("${prepaidGoods}")
	private String prepaidGoods;
	// 粤通卡
	@Value("${yuTongKaGoods}")
	private String yuTongKaGoods;
	// DIY卡
	@Value("${diyCardGoods}")
	private String diyCardGoods;
	@Value("${sevenDayGoods}")
	private String sevenDayGoods;
	@Value("${allFlyGoods}")
	private String allFlyGoods;
	@Value("${southernFlyGoods}")
	private String southernFlyGoods;

	public String preJudge(String certNo, String cardNo, String formatId, String goodsId, String force_buy) {
		return preJudge(certNo, cardNo, formatId, goodsId, force_buy, 0l);
	}

	@Override
	public String preJudge(String certNo, String cardNo, String formatId, String goodsId, String force_buy, long limitCnt) {
		log.info("进入预判接口，卡号：" + cardNo + "证件号：" + certNo + "卡板代码：" + formatId + "单品编码：" + goodsId + "是否强制购买："
				+ force_buy);
		ItemModel itemModel = itemService.findById(goodsId);//xiewl 20161013
		if (itemModel == null) {// 商品不正常
			return "-1";
		}
		/*if (!itemModelResponse.isSuccess() || itemModelResponse.getResult() == null) {// 商品不正常
			return "-1";
		}*/
		Response<GoodsModel> goodsModelResponse = goodsService.findById(itemModel.getGoodsCode());
		GoodsModel goodsModel = null;
		if (goodsModelResponse.isSuccess()) {
			goodsModel = goodsModelResponse.getResult();
		}

		if (goodsModel == null) {// 商品不正常
			return "-1";
		}

		Map<String, Object> paramaMap = new HashMap<String, Object>();
		paramaMap.put("ordertypeId", "JF");
		paramaMap.put("areaId", goodsModel.getRegionType());
		Response<EspAreaInfModel> areaInfModelResponse = espAreaInfService.findByAreaId(paramaMap);
		EspAreaInfModel espAreaInfModel = null;
		if (areaInfModelResponse.isSuccess()) {
			espAreaInfModel = areaInfModelResponse.getResult();
		} else {
			log.error("PriorJudgeServiceImpl.preJudge.findByAreaId.error,{}", goodsModel.getRegionType());
			return "-1";
		}
		String dbFormatId = goodsModel.getCards();
		String dbAreaFormatId = espAreaInfModel.getFormatId();
		int buyCount = 0;// 规定时间内购买次数
		// 如果商品的卡板代码设置了WWWW，则不进行校验。
		if (!Contants.GOODS_CARDBORD_NO_LIMIT.equals(dbFormatId)) {
			if (formatId == null || "".equals(formatId.trim())) {
				log.debug("传入的卡号对应卡板为空");
				return "1";
			} else if (dbFormatId != null && !"".equals(dbFormatId) && dbFormatId.indexOf(formatId) < 0) {// 卡板不符合
				log.debug("传入的卡板：" + formatId + "商品的卡板：" + dbFormatId);
				return "1";
			} else if ((dbFormatId == null || "".equals(dbFormatId)) && dbAreaFormatId.indexOf(formatId) < 0) {
				log.debug("传入的卡板：" + formatId + "分区的卡板：" + dbFormatId);
				return "1";
			}
		} else {
			log.debug("商品卡板WWWW，无卡板限制。");
		}
		if (!"1".equals(force_buy)) {// 非强制兑换
			int vmonthLimit = goodsModel.getLimitCount() == null ? 0 : goodsModel.getLimitCount(); // 当月限购次数
			int vlimit = itemModel.getVirtualLimit() == null ? 0 : itemModel.getVirtualLimit();// 限购次数
			int vlimitDays = itemModel.getVirtualLimitDays() == null ? 0 : itemModel.getVirtualLimitDays();// 限购天数
			long vIntegrallimit = itemModel.getVirtualIntegralLimit() == null ? 0 : itemModel.getVirtualIntegralLimit();// 积分上限值

			List<OrderSubModel> orderList = new ArrayList();
			if (lxsyxGoods.indexOf(itemModel.getXid()) != -1) {// 留学生旅行意外险
				// 对于留学生虚拟礼品，用证件号码查询是否购买过该礼品
				Map<String, Object> orderVirtualMap = new HashMap<String, Object>();
				orderVirtualMap.put("attachIdentityCard", certNo);
				List<OrderVirtualModel> orderVirtualModelList = orderVirtualDao.findByCertNo(orderVirtualMap);
				for (OrderVirtualModel orderVirtualModel : orderVirtualModelList) {
					Map<String, Object> orderMap = new HashMap<String, Object>();
					orderMap.put("order_id", orderVirtualModel.getOrderId());
					orderMap.put("goods_id", goodsId);
					List<OrderSubModel> orderSubModelList = orderSubDao.findXnlpOrder(orderMap);
					orderList.addAll(orderSubModelList);
				}
			} else {
				// 商城本地数据库中购买记录的查询
				Map<String, Object> orderMap = new HashMap<String, Object>();
				orderMap.put("cardno", cardNo);
				orderMap.put("goods_id", goodsId);
				List<OrderSubModel> orderSubModelList = orderSubDao.findXnlpOrder(orderMap);
				orderList.addAll(orderSubModelList);
			}

			log.debug("限购次数：" + vlimit + "限购天数：" + vlimitDays);
			// 当月限购次数
			if (vmonthLimit > 0) {
				if (!doCountLimitMonth(orderList, vmonthLimit)) {
					return "5";
				}
			}
			// ALL常旅客消费 里程积分上限校验
			if (vIntegrallimit > 0l) {
//			if (vIntegrallimit > 0l && southernFlyGoods.indexOf(itemModel.getXid()) != -1) {
				if (!doCountLimitIngetal(orderList, vIntegrallimit, limitCnt)) {
					return "4";
				}
			}
			if (vlimit > 0 && vlimitDays > 0) { // 如果是限购礼品
				try {
					String lxsyx = lxsyxGoods;// 留学生意外险礼品编码
					if (lxsyxGoods.indexOf(itemModel.getXid()) != -1) {// 留学生旅行意外险
						// 对于留学生虚拟礼品，用证件号码查询是否购买过该礼品
						buyCount = doLxsyCount(orderList, buyCount, vlimitDays);
					} else {
						buyCount = doCount(orderList, buyCount, vlimitDays);// 对buyCount进行计算
					}
					log.debug("商城本地数据库计算的购买次数：" + buyCount);
					// ods导入的数据判断
					String zqbx = zqbxGoods;// 配置中真情卡保险礼品编码
					String bzbx = bzbxGoods;// 配置中标准卡保险礼品编码
					String czbx = czbxGoods;// 配置中车主卡保险礼品编码
					String dljy = dljyGoods;// 配置中道路救援礼品编码
					if (certNo != null && cardNo != null) {// 为查询ods部分数据，对证件号以及卡号做处理
						certNo = chgCer(certNo);
						cardNo = chgCard(cardNo);
						log.debug("截取卡号的后四位：" + cardNo + "处理后的证件号：" + certNo);
					} else {
						log.debug("证件号或者卡号为null。certNo:" + certNo + "cardNo:" + cardNo);
					}
					if (zqbx.indexOf(itemModel.getXid()) != -1) {// 真情类保险
						// 查询数据库
						log.debug("此礼品为真情类保险");
						Map<String, Object> zqbxMap = new HashMap<String, Object>();
						zqbxMap.put("certNbr", certNo);
						zqbxMap.put("card4", cardNo);
						Response<List<XnlpZQBXModel>> xnlpZqbxModelListResponse = xnlpService.selectXnlpZQBX(zqbxMap);
						List<XnlpZQBXModel> xnlpZqbxModelList = null;
						if (xnlpZqbxModelListResponse.isSuccess()) {
							xnlpZqbxModelList = xnlpZqbxModelListResponse.getResult();
						}
						buyCount = dozqCount(xnlpZqbxModelList, buyCount, vlimitDays);// 对buyCount进行计算
					} else if (bzbx.indexOf(itemModel.getXid()) != -1) {// 标准类保险
						// 查询数据库
						log.debug("此礼品为标准类保险");
						Map<String, Object> bzbxMap = new HashMap<String, Object>();
						bzbxMap.put("certNbr", certNo);
						bzbxMap.put("card4", cardNo);
						Response<List<XnlpBZBXModel>> xnlpBzbxModelListResponse = xnlpService.selectXnlpBZBX(bzbxMap);
						List<XnlpBZBXModel> xnlpBzbxModelList = null;
						if (xnlpBzbxModelListResponse.isSuccess()) {
							xnlpBzbxModelList = xnlpBzbxModelListResponse.getResult();
						}
						buyCount = dobzCount(xnlpBzbxModelList, buyCount, vlimitDays);// 对buyCount进行计算
					} else if (czbx.indexOf(itemModel.getXid()) != -1) {// 车主卡类保险
						// 查询数据库
						log.debug("此礼品为车主卡类保险");
						Map<String, Object> czkbxMap = new HashMap<String, Object>();
						czkbxMap.put("certNbr", certNo);
						czkbxMap.put("card4", cardNo);
						Response<List<XnlpCZBXModel>> xnlpCzbxModelListResponse = xnlpService.selectXnlpCZBX(czkbxMap);
						List<XnlpCZBXModel> xnlpCzbxModelList = null;
						if (xnlpCzbxModelListResponse.isSuccess()) {
							xnlpCzbxModelList = xnlpCzbxModelListResponse.getResult();
						}
						buyCount = doczCount(xnlpCzbxModelList, buyCount, vlimitDays);// 对buyCount进行计算
					} else if (dljy.indexOf(itemModel.getXid()) != -1) {// 道路救援类保险
						// 查询数据库
						log.debug("此礼品为道路救援类保险");
						Map<String, Object> dljybxMap = new HashMap<String, Object>();
						dljybxMap.put("certNbr", certNo);
						dljybxMap.put("card4", cardNo);
						Response<List<XnlpCZDLModel>> xnlpCzdlModelListResponse = xnlpService.selectXnlpCZDL(dljybxMap);
						List<XnlpCZDLModel> xnlpCzdlModelList = null;
						if (xnlpCzdlModelListResponse.isSuccess()) {
							xnlpCzdlModelList = xnlpCzdlModelListResponse.getResult();
						}
						buyCount = dodlCount(xnlpCzdlModelList, buyCount, vlimitDays);// 对buyCount进行计算
					} else if (lxsyx.indexOf(itemModel.getXid()) != -1) {// 留学生旅行意外险
						log.debug("留学生旅行意外险");
						Map<String, Object> lxsywxMap = new HashMap<String, Object>();
						lxsywxMap.put("certNbr", certNo);
						lxsywxMap.put("card4", cardNo);
						Response<List<XnlpLXSYModel>> xnlpCzdlModelListResponse = xnlpService.selectXnlpLXSY(lxsywxMap);
						List<XnlpLXSYModel> xnlpCzdlModelList = null;
						if (xnlpCzdlModelListResponse.isSuccess()) {
							xnlpCzdlModelList = xnlpCzdlModelListResponse.getResult();
						}
						buyCount = doxsCount(xnlpCzdlModelList, buyCount, vlimitDays);// 对buyCount进行计算
					}
					log.debug("ODS数据判断后的购买次数：" + buyCount);
					if (buyCount >= vlimit) {// 购买次数大于限购
						return "2";
					}
				} catch (Exception e) {
					log.error("exception:" + e);
					return "3";
				}
			}
		}
		return "0";
	}

	/**
     * 判断是否是附属卡
     *
     * @param itemModel   商品
     * @param entry_card 附属卡
     * @return
     */
    public String judgeEntryCard_new(ItemModel itemModel, String entry_card) {
        String entryCardGoods = attachedGoods;
        if (entryCardGoods.indexOf(itemModel.getXid()) < 0) {//如果不是附属卡产品
            return "-1";
        }
        if (entry_card.length() == 16 && (entry_card.startsWith("6225582") || entry_card.startsWith("5289312") || entry_card.startsWith("4870132"))) {//是否附属卡的判断
            return "0";
        } else {
            return "-2";
        }
    }

	/**
	 * 判断该用户是否还在限购期内
	 *
	 * @param orderDays 下单日期
	 * @param vlimitDays 限购天数
	 * @return
	 */
	private boolean judgeDays(String orderDays, int vlimitDays) {
		int orderDaysInt = Integer.parseInt(orderDays);// 下单日期
		Date nowDate = new Date();
		long dtV = nowDate.getTime() - ((long) vlimitDays * 24 * 60 * 60 * 1000);
		Date dtDate = new Date(dtV);
		String checkDate = DateHelper.getyyyyMMdd(dtDate);
		int ckDate = Integer.parseInt(checkDate);// 减去限购天数的得到的日期
		log.debug("减去限购天数的得到的日期:" + checkDate);
		if (orderDaysInt > ckDate) {// 还在限购期内
			return true;
		}
		return false;
	}

	public boolean isNianFee(String goods_xid) {
		String nianfei = nianfeiChange;
		if (nianfei.indexOf(goods_xid) != -1) {
			return true;
		}
		return false;
	}

	public boolean isQianzhane(String goods_xid) {
		String qianzhene = hongliCardChange;
		String yuTongKa = yuTongKaGoods;// 粤通卡也通过签帐额入帐
		String diyCard = diyCardGoods;// DIY卡需要通过签账额入账
		if (qianzhene.indexOf(goods_xid) != -1) {
			return true;
		}
		if (yuTongKa.indexOf(goods_xid) != -1) {
			return true;
		}
		if (diyCard.indexOf(goods_xid) != -1) {
			return true;
		}
		return false;
	}

	/**
	 * 加密证件号后四位
	 *
	 * @param certNo
	 */
	private String chgCer(String certNo) {
		int len = certNo.length();
		certNo = certNo.substring(0, len - 4) + "****";
		return certNo;
	}

	/**
	 * 截取卡号后四位
	 *
	 * @param cardNo
	 */
	private String chgCard(String cardNo) {
		int len = cardNo.length();
		cardNo = cardNo.substring(len - 4, len);
		return cardNo;
	}

	/**
	 * 根据商城购购买记录、限制天数计算购买次数
	 *
	 * @param list
	 * @param buyCount
	 * @param limitDays
	 */
	private int doCount(List list, int buyCount, int limitDays) {
		if (list != null && list.size() > 0) {// 存在该卡号对应该商品的订单
			for (int i = 0; i < list.size(); i++) {
				// list对象类型是TblOrderView
				OrderSubModel orderSubModel = (OrderSubModel) list.get(i);
				String create_date = DateHelper.getyyyyMMdd(orderSubModel.getCreateTime());// 订单下单时间
				if (judgeDays(create_date, limitDays)) {// 时间控制
					buyCount++;
				}
			}
			return buyCount;
		}
		return buyCount;
	}

	/**
	 * 当月限购数校验
	 *
	 * @param list
	 * @param limits
	 */
	private boolean doCountLimitMonth(List list, int limits) {
		int limitCnt = 0;
		if (list != null && list.size() > 0) {// 存在该卡号对应该商品的订单
			for (int i = 0; i < list.size(); i++) {
				OrderSubModel orderSubModel = (OrderSubModel) list.get(i);
				if (judgeDays(orderSubModel.getCreateTime())) {// 时间控制
					limitCnt++;
				}
			}
			return limitCnt < limits;
		}
		return true;
	}

	/**
	 * 里程积分兑换上限
	 *
	 * @param list
	 * @param limits
	 * @param singleCnt
	 */
	private boolean doCountLimitIngetal(List list, long limits, long singleCnt) {
		long limitCnt = singleCnt;
		if (list != null && list.size() > 0) {// 存在该卡号对应该商品的订单
			for (int i = 0; i < list.size(); i++) {
				OrderSubModel orderSubModel = (OrderSubModel) list.get(i);
				if (judgeDays(orderSubModel.getCreateTime())) {// 时间控制
					limitCnt = limitCnt + orderSubModel.getBonusTotalvalue();
				}
			}
			return limitCnt <= limits;
		}
		return true;
	}
	/**
	 * 判断该用户是否还在限购期内
	 *
	 * @param date 下单日期
	 * @return
	 */
	private static boolean judgeDays(Date date) {
		int dend = Integer.parseInt(DateHelper.getyyyyMMdd(date));
		long dstart = DateTime.now().dayOfMonth().withMinimumValue().getMillis();
		Date dtDate = new Date(dstart);
		String checkDate = DateHelper.getyyyyMMdd(dtDate);
		int ckDate = Integer.parseInt(checkDate);// 减去限购天数的得到的日期
		System.out.println(dend + "  " + ckDate);
		if (dend >= ckDate) {// 还在限购期内
			return true;
		}
		return false;
	}

	/**
	 * 根据商城购购买记录、限制天数计算留学生意外险的购买次数
	 *
	 * @param list
	 * @param buyCount
	 * @param limitDays
	 */
	private int doLxsyCount(List<OrderSubModel> list, int buyCount, int limitDays) {
		if (list != null && list.size() > 0) {// 存在该卡号对应该商品的订单
			for (int i = 0; i < list.size(); i++) {
				OrderSubModel orderSubModel = list.get(i);
				String create_date = DateHelper.getyyyyMMdd(orderSubModel.getCreateTime());// 订单下单时间
				if (judgeDays(create_date, limitDays)) {// 时间控制
					buyCount++;
				}
			}
			return buyCount;
		}
		return buyCount;
	}

	/**
	 * 根据真情保险购买记录、限制天数计算购买次数
	 *
	 * @param list
	 * @param buyCount
	 * @param limitDays
	 */
	private int dozqCount(List list, int buyCount, int limitDays) {
		if (list != null && list.size() > 0) {// 存在该卡号对应该商品的订单
			for (int i = 0; i < list.size(); i++) {
				XnlpZQBXModel zq = (XnlpZQBXModel) list.get(i);
				String create_date = formatString(zq.getServerStart());// 订单下单时间
				log.debug("服务开始时间：" + create_date);
				if (judgeDays(create_date, limitDays)) {// 时间控制
					buyCount++;
				}
			}
			return buyCount;
		}
		return buyCount;
	}

	/**
	 * 根据标准保险购买记录、限制天数计算购买次数
	 *
	 * @param list
	 * @param buyCount
	 * @param limitDays
	 */
	private int dobzCount(List list, int buyCount, int limitDays) {
		if (list != null && list.size() > 0) {// 存在该卡号对应该商品的订单
			for (int i = 0; i < list.size(); i++) {
				log.debug("存在的记录数：" + list.size());
				XnlpBZBXModel bz = (XnlpBZBXModel) list.get(i);
				String create_date = formatString(bz.getServerStart());// 订单下单时间
				log.debug("服务开始时间：" + create_date);
				if (judgeDays(create_date, limitDays)) {// 时间控制
					buyCount++;
				}
			}
			return buyCount;
		}
		return buyCount;
	}


	/**
	 * 根据车主卡保险购买记录、限制天数计算购买次数
	 *
	 * @param list
	 * @param buyCount
	 * @param limitDays
	 */
	private int doczCount(List list, int buyCount, int limitDays) {
		if (list != null && list.size() > 0) {//存在该卡号对应该商品的订单
			for (int i = 0; i < list.size(); i++) {
				XnlpCZBXModel cz = (XnlpCZBXModel) list.get(i);
				String create_date = formatString(cz.getServerStart());//订单下单时间
				log.debug("服务开始时间：" + create_date);
				if (judgeDays(create_date, limitDays)) {//时间控制
					buyCount++;
				}
			}
			return buyCount;
		}
		return buyCount;
	}

	/**
	 * 根据道路救援购买记录、限制天数计算购买次数
	 *
	 * @param list
	 * @param buyCount
	 * @param limitDays
	 */
	private int dodlCount(List list, int buyCount, int limitDays) {
		if (list != null && list.size() > 0) {// 存在该卡号对应该商品的订单
			for (int i = 0; i < list.size(); i++) {
				XnlpCZDLModel dl = (XnlpCZDLModel) list.get(i);
				String create_date = formatString(dl.getServerStart());// 订单下单时间
				log.debug("服务开始时间：" + create_date);
				if (judgeDays(create_date, limitDays)) {// 时间控制
					buyCount++;
				}
			}
			return buyCount;
		}
		return buyCount;
	}

	/**
	 * 根据留学生意外险购买记录、限制天数计算购买次数
	 *
	 * @param list
	 * @param buyCount
	 * @param limitDays
	 */
	private int doxsCount(List list, int buyCount, int limitDays) {
		if (list != null && list.size() > 0) {// 存在该卡号对应该商品的订单
			for (int i = 0; i < list.size(); i++) {
				XnlpLXSYModel dl = (XnlpLXSYModel) list.get(i);
				String create_date = formatString(dl.getServerStart());// 订单下单时间
				log.debug("服务开始时间：" + create_date);
				if (judgeDays(create_date, limitDays)) {// 时间控制
					buyCount++;
				}
			}
			return buyCount;
		}
		return buyCount;
	}

	private String formatString(String str) {
		log.debug("处理前的时间：" + str);
		int lastIndex = str.lastIndexOf("-");
		if (str != null) {
			str = str.replaceAll("-", "");
			if (str.length() == 7 && lastIndex == 6) {// 如果时间格式不规范YYYY-M-DD
				str = str.substring(0, 4) + "0" + str.substring(4, 7);
			} else if (str.length() == 7 && lastIndex == 7) {// 如果时间格式不规范YYYY-MM-D
				str = str.substring(0, 6) + "0" + str.substring(6, 7);
			} else if (str.length() == 6) {// 如果时间格式如YYYY-M-D
				str = str.substring(0, 4) + "0" + str.substring(4, 5) + "0" + str.substring(5, 6);
			}
		}
		log.debug("规范后的时间：" + str);
		return str;
	}

	/**
	 * 判断是否为充值虚拟礼品
	 *
	 * @param goods_xid
	 * @return
	 */
	public boolean isPrepaid(String goods_xid) {
		String prepaid = prepaidGoods;
		if (prepaid.indexOf(goods_xid) != -1) {
			return true;
		}
		return false;
	}

	/**
	 * 判断是否为留学生意外险
	 *
	 * @param goods_xid
	 * @return
	 */
	public boolean isLxsyx(String goods_xid) {
		String lxsyx = lxsyxGoods;
		if (lxsyx.indexOf(goods_xid) != -1) {
			return true;
		}
		return false;
	}

	/**
	 * 判断是否为白金卡附属卡年费产品
	 *
	 * @param goods_xid
	 * @return
	 */
	public boolean isBjfsk(String goods_xid) {
		String bjfsk = attachedGoods;
		if (bjfsk.indexOf(goods_xid) != -1) {
			return true;
		}
		return false;
	}

	/**
	 * 判断是否为ALL常旅客消费
	 *
	 * @param goods_xid
	 * @return
	 */
	public boolean isClkxf(String goods_xid) {
		String clkxf = allFlyGoods;
		if (clkxf.indexOf(goods_xid) != -1) {
			return true;
		}
		return false;
	}

	/**
	 * 南航里程
	 * @param goods_xid
	 * @return
	 */
	public boolean isSouthern(String goods_xid) {
		String clkxf = southernFlyGoods;
		if (clkxf.indexOf(goods_xid) != -1) {
			return true;
		}
		return false;
	}
	/**
	 * 判断是否为七天联名卡住宿券
	 *
	 * @param goods_xid
	 * @return
	 */
	public boolean isQtlmk(String goods_xid) {
		String Qtlmk = sevenDayGoods;
		if (Qtlmk.indexOf(goods_xid) != -1) {
			return true;
		}
		return false;
	}
	/**
	 * 判断是否为广发人保粤通卡
	 * @param goods_xid
	 * @return
	 */
	public boolean isYueTong(String goods_xid){
		String Qtlmk = yuTongKaGoods;
		if (Qtlmk.indexOf(goods_xid) != -1) {
			return true;
		}
		return false;
	}

	// 备选方案
	public String preJudge(String certNo, String goodsId) {
		log.info("进入预判接口" + "证件号：" + certNo + "单品编码：" + goodsId);
		Response<ItemModel> itemModelResponse = itemService.findByItemcode(goodsId);
		ItemModel itemModel = null;
		if (itemModelResponse.isSuccess()) {
			itemModel = itemModelResponse.getResult();
		}

		if (itemModel == null) {// 商品不正常
			return "-1";
		}

		Response<GoodsModel> goodsModelResponse = goodsService.findById(itemModel.getGoodsCode());
		GoodsModel goodsModel = null;
		if (goodsModelResponse.isSuccess()) {
			goodsModel = goodsModelResponse.getResult();
		}

		if (goodsModel == null) {// 商品不正常
			return "-1";
		}

		Map<String, Object> paramaMap = new HashMap<String, Object>();
		paramaMap.put("ordertypeId", "JF");
		paramaMap.put("areaId", goodsModel.getRegionType());
		Response<EspAreaInfModel> areaInfModelResponse = espAreaInfService.findByAreaId(paramaMap);
		int buyCount = 0;// 规定时间内购买次数
		int vlimit = itemModel.getVirtualMileage() == null ? 0 : itemModel.getVirtualMileage();// 限购次数
		int vlimitDays = itemModel.getVirtualLimitDays() == null ? 0 : itemModel.getVirtualLimitDays();// 限购天数
		log.debug("限购次数：" + vlimit + "限购天数：" + vlimitDays);
		if (vlimit > 0 && vlimitDays > 0) {// 如果是限购礼品
			try {
				List<OrderSubModel> orderList = new ArrayList();
				String lxsyx = lxsyxGoods;// 留学生意外险礼品编码
				if (lxsyx.indexOf(itemModel.getXid()) != -1) {// 留学生旅行意外险
					// 对于留学生虚拟礼品，用证件号码查询是否购买过该礼品
					Map<String, Object> orderVirtualMap = new HashMap<String, Object>();
					orderVirtualMap.put("attachIdentityCard", certNo);
					List<OrderVirtualModel> orderVirtualModelList = orderVirtualDao.findByCertNo(orderVirtualMap);
					for (OrderVirtualModel orderVirtualModel : orderVirtualModelList) {
						paramaMap.put("order_id", orderVirtualModel.getOrderId());
						paramaMap.put("goods_id", goodsId);
						List<OrderSubModel> orderSubModelList = orderSubDao.findXnlpOrder(paramaMap);
						orderList.addAll(orderSubModelList);
					}
					buyCount = doLxsyCount(orderList, buyCount, vlimitDays);
				} else {
					// 商城本地数据库中购买记录的查询
					paramaMap.put("goods_id", goodsId);
					List<OrderSubModel> orderSubModelList = orderSubDao.findXnlpOrder(paramaMap);
					orderList.addAll(orderSubModelList);
					buyCount = doCount(orderList, buyCount, vlimitDays);// 对buyCount进行计算
				}
				log.debug("商城本地数据库计算的购买次数：" + buyCount);
				// ods导入的数据判断
				String zqbx = zqbxGoods;// 配置中真情卡保险礼品编码
				String bzbx = bzbxGoods;// 配置中标准卡保险礼品编码
				String czbx = czbxGoods;// 配置中车主卡保险礼品编码
				String dljy = dljyGoods;// 配置中道路救援礼品编码
				if (certNo != null) {// 为查询ods部分数据，对证件号以及卡号做处理
					certNo = chgCer(certNo);
					log.debug("处理后的证件号：" + certNo);
				} else {
					log.debug("证件号为null。");
				}
				if (zqbx.indexOf(itemModel.getXid()) != -1) {// 真情类保险
					// 查询数据库
					log.debug("此礼品为真情类保险");
					Map<String, Object> zqbxMap = new HashMap<String, Object>();
					zqbxMap.put("certNbr", certNo);
					Response<List<XnlpZQBXModel>> xnlpZqbxModelListResponse = xnlpService.selectXnlpZQBX(zqbxMap);
					List<XnlpZQBXModel> xnlpZqbxModelList = null;
					if (xnlpZqbxModelListResponse.isSuccess()) {
						xnlpZqbxModelList = xnlpZqbxModelListResponse.getResult();
					}
					buyCount = dozqCount(xnlpZqbxModelList, buyCount, vlimitDays);// 对buyCount进行计算
				} else if (bzbx.indexOf(itemModel.getXid()) != -1) {// 标准类保险
					// 查询数据库
					log.debug("此礼品为标准类保险");
					Map<String, Object> bzbxMap = new HashMap<String, Object>();
					bzbxMap.put("certNbr", certNo);
					Response<List<XnlpBZBXModel>> xnlpBzbxModelListResponse = xnlpService.selectXnlpBZBX(bzbxMap);
					List<XnlpBZBXModel> xnlpBzbxModelList = null;
					if (xnlpBzbxModelListResponse.isSuccess()) {
						xnlpBzbxModelList = xnlpBzbxModelListResponse.getResult();
					}
					buyCount = dobzCount(xnlpBzbxModelList, buyCount, vlimitDays);// 对buyCount进行计算
				} else if (czbx.indexOf(itemModel.getXid()) != -1) {// 车主卡类保险
					// 查询数据库
					log.debug("此礼品为车主卡类保险");
					Map<String, Object> czkbxMap = new HashMap<String, Object>();
					czkbxMap.put("certNbr", certNo);
					Response<List<XnlpCZBXModel>> xnlpCzbxModelListResponse = xnlpService.selectXnlpCZBX(czkbxMap);
					List<XnlpCZBXModel> xnlpCzbxModelList = null;
					if (xnlpCzbxModelListResponse.isSuccess()) {
						xnlpCzbxModelList = xnlpCzbxModelListResponse.getResult();
					}
					buyCount = doczCount(xnlpCzbxModelList, buyCount, vlimitDays);// 对buyCount进行计算
				} else if (dljy.indexOf(itemModel.getXid()) != -1) {// 道路救援类保险
					// 查询数据库
					log.debug("此礼品为道路救援类保险");
					Map<String, Object> dljybxMap = new HashMap<String, Object>();
					dljybxMap.put("certNbr", certNo);
					Response<List<XnlpCZDLModel>> xnlpCzdlModelListResponse = xnlpService.selectXnlpCZDL(dljybxMap);
					List<XnlpCZDLModel> xnlpCzdlModelList = null;
					if (xnlpCzdlModelListResponse.isSuccess()) {
						xnlpCzdlModelList = xnlpCzdlModelListResponse.getResult();
					}
					buyCount = dodlCount(xnlpCzdlModelList, buyCount, vlimitDays);// 对buyCount进行计算
				} else if (lxsyx.indexOf(itemModel.getXid()) != -1) {// 留学生旅行意外险
					log.debug("留学生旅行意外险");
					Map<String, Object> lxsywxMap = new HashMap<String, Object>();
					lxsywxMap.put("certNbr", certNo);
					Response<List<XnlpLXSYModel>> xnlpCzdlModelListResponse = xnlpService.selectXnlpLXSY(lxsywxMap);
					List<XnlpLXSYModel> xnlpCzdlModelList = null;
					if (xnlpCzdlModelListResponse.isSuccess()) {
						xnlpCzdlModelList = xnlpCzdlModelListResponse.getResult();
					}
					buyCount = doxsCount(xnlpCzdlModelList, buyCount, vlimitDays);// 对buyCount进行计算
				}
				log.debug("ODS数据判断后的购买次数：" + buyCount);
				if (buyCount >= vlimit) {// 购买次数大于限购
					return "2";
				}
			} catch (Exception e) {
				log.error("exception:" + e);
				return "3";
			}
		}
		return "0";
	}

	/**
	 * 判断是否是附属卡
	 *
	 * @param goods_id 商品ID
	 * @param entry_card 附属卡
	 * @return
	 */
	public String judgeEntryCard(String goods_id, String entry_card) {
		Response<ItemModel> itemModelResponse = itemService.findByItemcode(goods_id);
		ItemModel itemModel = null;
		if (itemModelResponse.isSuccess()) {
			itemModel = itemModelResponse.getResult();
		}
		String entryCardGoods = attachedGoods;
		if (entryCardGoods.indexOf(itemModel.getXid()) < 0) {// 如果不是附属卡产品
			return "-1";
		}
		if (entry_card.length() == 16 && (entry_card.startsWith("6225582") || entry_card.startsWith("5289312")
				|| entry_card.startsWith("4870132"))) {// 是否附属卡的判断
			return "0";
		} else {
			return "-2";
		}
	}
}
