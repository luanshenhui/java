package cn.com.cgbchina.generator.service;

import static com.google.common.base.Preconditions.checkArgument;
import static com.spirit.util.Arguments.notNull;

import java.util.Date;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.springframework.stereotype.Service;

import com.google.common.base.Throwables;
import com.google.common.math.LongMath;

import cn.com.cgbchina.common.utils.RandomHelper;
import cn.com.cgbchina.generator.IdEnum;
import cn.com.cgbchina.generator.IdGenarator;
import cn.com.cgbchina.generator.dao.IdGenaratorDao;
import cn.com.cgbchina.generator.exception.IdGeneratorException;
import lombok.extern.slf4j.Slf4j;

/**
 * Created by 11140721050130 on 2016/4/30.
 */
@Service
@Slf4j
public class IdGeneratorImpl implements IdGenarator {
	private static final DateTimeFormatter YYYYMMDD = DateTimeFormat.forPattern("yyyyMMdd");
	private static final DateTimeFormatter MMDD = DateTimeFormat.forPattern("MMdd");
	private static final DateTimeFormatter dtf = DateTimeFormat.forPattern("yyMMdd");
	private static final DateTimeFormatter YYYYMMDDHHMMSS = DateTimeFormat.forPattern("yyyyMMddHHmmss");
	private static final DateTimeFormatter YYMMDDHH = DateTimeFormat.forPattern("yyMMddHH");

	@Resource
	private IdGenaratorDao idGenaratorDao;

	@Override
	public String id(IdEnum type, String userId) {
		try {
			checkArgument(notNull(userId), "userId.not.empty");
			checkArgument(notNull(type), "type.not.empty");
			Long id = idGenaratorDao.newId(type);
			return format(type, id, userId);
		} catch (Exception e) {
			log.error("id generator error,cause:{}", Throwables.getStackTraceAsString(e));
			throw new IdGeneratorException(e.getMessage());
		}
	}
	@Override
	public String goodsPayWayId(String orderTypeId) {
		String goodsPayWayId = "";
		Long id = idGenaratorDao.newId(IdEnum.PAY_WAY);
		if ("YG".equals(orderTypeId)) {
			goodsPayWayId = "04" + YYMMDDHH.print(new DateTime(new Date()))
					+ (String.format("%08d", LongMath.mod(id, 99999L))).substring(
							(String.format("%08d", LongMath.mod(id, 99999L))).length() - 5,
							(String.format("%08d", LongMath.mod(id, 99999L))).length());
		} else if ("JF".equals(orderTypeId)) {
			goodsPayWayId = "05" + YYMMDDHH.print(new DateTime(new Date()))
					+ (String.format("%08d", LongMath.mod(id, 99999L))).substring(
							(String.format("%08d", LongMath.mod(id, 99999L))).length() - 5,
							(String.format("%08d", LongMath.mod(id, 99999L))).length());
		} else {
			goodsPayWayId = "00" + YYMMDDHH.print(new DateTime(new Date()))
					+ (String.format("%08d", LongMath.mod(id, 99999L))).substring(
							(String.format("%08d", LongMath.mod(id, 99999L))).length() - 5,
							(String.format("%08d", LongMath.mod(id, 99999L))).length());
		}
		return goodsPayWayId;
	}

	@Override
	public String itemMid() {
		//试运行期间不适用此发号器
		//return RandomHelper.randomUpperAndNumber(5);
		Long number = idGenaratorDao.newId(IdEnum.ITEM_MID_TRY);
        return "9"+StringUtils.leftPad(String.valueOf(number),4,"0");
	}

	@Override
	public String orderMainId(String chanel) {
		return orderMainId(true,chanel);
	}
	
	/**
	 * 真实处理id生成的
	 * @param flg true:并行期 false:非并行期
	 * @param chanel
	 * @return
	 */
	private String orderMainId(boolean flg,String chanel){
		Long id = idGenaratorDao.newId(IdEnum.ORDER_MAIN);
		String result=YYYYMMDD.print(new DateTime(new Date())) + chanel + String.format("%06d", LongMath.mod(id, 999999L));
		if(flg){
			return 9+result.substring(1,result.length());
		}else{
			return result;
		}
		
	}

	@Override
	public String orderSubId(String orderId, String userId) {
		Long id = idGenaratorDao.newId(IdEnum.ORDER);
		return orderId + String.format("%03d", LongMath.mod(id, 99999L));
	}

	@Override
	public String orderSerialNo() {
		Long id = idGenaratorDao.newId(IdEnum.ORDER_SERIAL_NO);
		return MMDD.print(new DateTime(new Date())) + "9" + String.format("%07d", LongMath.mod(id, 9999999L));
	}

	@Override
	public String jfRefundSerialNo() {
		Long id = idGenaratorDao.newId(IdEnum.JF_REFUND_SERIAL_NO);
		return MMDD.print(new DateTime(new Date())) + "8" + String.format("%07d", LongMath.mod(id, 9999999L));
	}

	/**
	 * TODO 土地掉渣的方法，之后会改为设计模式----zhangchj
	 * <p>
	 * 根据类型获取id生成格式
	 *
	 * @param type 类型
	 * @return
	 */

	private String format(IdEnum type, Long id, String userId) {
		switch (type) {
		case ORDER_MAIN:
			return formatOrderMainId(id, userId);
		case ORDER:
			return formatOrderId(id, userId);
		case GOODS:
			return formatGoodsId(id, userId);
		case ITEM:
			return formatItemId(id, userId);
		case PAY_WAY:
			return formatPayWayId(id, userId);
		case ITEM_MID:
			return formatItemMid(id, userId);
		}
		return null;
	}

	private String formatItemId(Long id, String userId) {
		return dtf.print(new DateTime(new Date())) + (String.format("%09d", LongMath.mod(id, 99999L)))
				.substring((String.format("%09d", LongMath.mod(id, 99999L))).length() - 8);
	}

	// 商品Id生成规则
	private String formatGoodsId(Long id, String userId) {
		return dtf.print(new DateTime(new Date())) + (String.format("%08d", LongMath.mod(id, 99999L)))
				.substring((String.format("%08d", LongMath.mod(id, 99999L))).length() - 7);
	}

	// 商品支付方式id
	private String formatPayWayId(Long id, String userId) {
		return dtf.print(new DateTime(new Date())) + String.format("%05d", LongMath.mod(id, 99999L));
	}

	// 单品mid
	private String formatItemMid(Long id, String userId) {
		return dtf.print(new DateTime(new Date())) + (String.format("%03d", LongMath.mod(id, 99999L))).substring(
				(String.format("%03d", LongMath.mod(id, 99999L))).length() - 2,
				(String.format("%03d", LongMath.mod(id, 99999L))).length());
	}

	// 订单Id生成格式（用户Id + yyMMdd(6位) + Id生成（redis自增））
	private String formatOrderId(Long id, String userId) {
		return generatorOrderId(id, userId);
	}

	// 主订单号生产规则（同订单Id）
	private String formatOrderMainId(Long id, String userId) {
		return generatorOrderId(id, userId);
	}

	private String generatorOrderId(Long id, String userId) {
		return generatorUserId(userId) + dtf.print(new DateTime(new Date()))
				+ String.format("%06d", LongMath.mod(id, 999999L));
	}

	private String generatorUserId(String userId) {
		return StringUtils.substring(userId.toString(), userId.toString().length() - 4);
	}

	@Override
	public String genarateSenderSN() {
		return YYYYMMDDHHMMSS.print(new DateTime(new Date()))
				+ String.format("%08d", idGenaratorDao.newId(IdEnum.INTF_SOAP));
	}

}
