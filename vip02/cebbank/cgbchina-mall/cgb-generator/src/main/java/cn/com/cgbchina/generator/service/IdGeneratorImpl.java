package cn.com.cgbchina.generator.service;

import cn.com.cgbchina.generator.IdEnum;
import cn.com.cgbchina.generator.IdGenarator;
import cn.com.cgbchina.generator.dao.IdGenaratorDao;
import cn.com.cgbchina.generator.exception.IdGeneratorException;
import com.google.common.base.Throwables;
import com.google.common.math.LongMath;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.Date;

import static com.google.common.base.Preconditions.checkArgument;
import static com.spirit.util.Arguments.notNull;

/**
 * Created by 11140721050130 on 2016/4/30.
 */
@Service
@Slf4j
public class IdGeneratorImpl implements IdGenarator {
	private static final DateTimeFormatter YYYYMMDD = DateTimeFormat.forPattern("yyyyMMdd");
	private static final DateTimeFormatter MMDD = DateTimeFormat.forPattern("MMdd");
	private static final DateTimeFormatter dtf = DateTimeFormat.forPattern("yyMMdd");
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
	public String orderMainId(String chanel) {
		Long id = idGenaratorDao.newId(IdEnum.ORDER_MAIN);
		return YYYYMMDD.print(new DateTime(new Date())) + chanel
				+ String.format("%06d", LongMath.mod(id, 999999L));
	}

	@Override
	public String orderSubId(String orderId, String userId) {
		Long id = idGenaratorDao.newId(IdEnum.ORDER);
		return orderId + String.format("%03d", LongMath.mod(id, 99999L));
	}

	@Override
	public String orderSerialNo() {
		Long id = idGenaratorDao.newId(IdEnum.ORDER_SERIAL_NO);
		return MMDD.print(new DateTime(new Date())) + "9"
				+ String.format("%07d", LongMath.mod(id, 9999999L));
	}

	@Override
	public String jfRefundSerialNo() {
		Long id = idGenaratorDao.newId(IdEnum.JF_REFUND_SERIAL_NO);
		return MMDD.print(new DateTime(new Date())) + "8"
				+ String.format("%07d", LongMath.mod(id, 9999999L));
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
		}
		return null;
	}

	private String formatItemId(Long id, String userId) {
		return generatorUserId(userId) + dtf.print(new DateTime(new Date()))
				+ String.format("%05d", LongMath.mod(id, 99999L));
	}

	// 商品Id生成规则
	private String formatGoodsId(Long id, String userId) {
		return generatorUserId(userId) + dtf.print(new DateTime(new Date()))
				+ String.format("%05d", LongMath.mod(id, 99999L));
	}
	//支付方式生成规则
	private String formatPayWayId(Long id,String userId){
		return generatorUserId(userId) + dtf.print(new DateTime(new Date()))
				+ String.format("%05d", LongMath.mod(id, 99999L));
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

}
