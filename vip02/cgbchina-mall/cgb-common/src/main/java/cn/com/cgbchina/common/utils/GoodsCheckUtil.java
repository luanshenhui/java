package cn.com.cgbchina.common.utils;

import com.google.common.base.Function;
import com.google.common.base.Splitter;
import com.google.common.base.Strings;
import com.google.common.collect.Collections2;
import com.google.common.collect.Ordering;
import org.joda.time.DateTime;

import java.math.BigDecimal;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Created by 1115012105001 on 2016/10/3.
 */
public class GoodsCheckUtil {

	private final static Splitter splitter = Splitter.on(',').trimResults().omitEmptyStrings();

	/**
	 * 自动下架时间时间不早于当前时间
	 * 
	 * @param dateTime
	 */
	public static void timeAfterNow(DateTime dateTime) {
		if (dateTime.isBeforeNow()) {
			throw new IllegalArgumentException("自动下架时间不得小于当前时间");
		}
	}

	/**
	 * 第三级卡产品编码 逗号分割
	 * 
	 * @param cards
	 */
	public static void checkCards(String cards) {
		Pattern pattern = Pattern.compile("^WWWW|^(\\d{4}\\,)*?\\d{4}$");
		Matcher matcher = pattern.matcher(cards);
		if (!matcher.matches()) {
			throw new IllegalArgumentException("goods.model.cards.check.error");
		}
	}

	/**
	 * 商品积分输入不符合规则
	 * 
	 * @param rate
	 */
	public static void checkRate(String rate) {
		Pattern pattern = Pattern.compile("^1(\\.0(0){0,1}){0,1}$|^(0\\.[0-9]{1,2})$");
		Matcher matcher = pattern.matcher(rate);
		BigDecimal decimalRate = new BigDecimal(rate);
		if (!matcher.matches()) {
			throw new IllegalArgumentException("商品积分输入不符合规则！");
		}
		if (decimalRate.compareTo(BigDecimal.ZERO) < 0 || decimalRate.compareTo(BigDecimal.ONE) > 0) {
			throw new IllegalArgumentException("商品积分输入不符合规则！");
		}
	}

	/**
	 * 商品名称
	 * 
	 * @param goodName
	 */
	public static void checkGoodName(String goodName) {
		Pattern pattern = Pattern.compile("^[^\\\"'<>%]*$");
		Matcher matcher = pattern.matcher(goodName);
		if (!matcher.matches()) {
			throw new IllegalArgumentException("商品名称不允许输入特殊字符");
		}
	}

	/**
	 * 校验价格与市场价
	 * 
	 * @param price
	 */
	public static void checkPrice(String price) {
		Pattern pattern = Pattern.compile("^(([0-9]*)|(([0]\\.\\d{1,2}|[1-9][0-9]*\\.\\d{1,2})))$");
		Matcher matcher = pattern.matcher(price);
		if (!matcher.matches()) {
			throw new IllegalArgumentException("价格格式有误");
		}
		if (new BigDecimal(price).compareTo(new BigDecimal("999999.99")) > 0) {
			throw new IllegalArgumentException("价格不能大于999999.99");
		}
	}

	/**
	 * 校验库存 校验固定积分 校验库存预警值
	 * 
	 * @param num
	 */
	public static void checkNum1To9(String num, String message) {
		Pattern pattern = Pattern.compile("^[1-9]\\d*$");
		Matcher matcher = pattern.matcher(num);
		if (!matcher.matches()) {
			throw new IllegalArgumentException(message);
		}
	}

	/**
	 * 校验固定积分
	 *
	 * @param num
	 */
	public static void checkNum0To9(String num, String message) {
		Pattern pattern = Pattern.compile("^[0-9]\\d*$");
		Matcher matcher = pattern.matcher(num);
		if (!matcher.matches()) {
			throw new IllegalArgumentException(message);
		}
	}

	public static void checkSpecial(String charAndNum, String message) {
		Pattern pattern = Pattern.compile("^[^\\\"'<>%]*$");
		Matcher matcher = pattern.matcher(charAndNum);
		if (!matcher.matches()) {
			throw new IllegalArgumentException(message);
		}
	}

	public  static Integer  getMaxInstallmentNumber(String installmentNumber){
		if(Strings.isNullOrEmpty(installmentNumber)){
			return 1;
		}
		List<String> numberList = splitter.splitToList(installmentNumber);
		// 取最大分期数
		return Ordering.natural().max(Collections2.transform(numberList, new Function<String, Integer>() {
			@Override
			public Integer apply(String s) {
				return Integer.valueOf(s);
			}
		}));

	}

}
