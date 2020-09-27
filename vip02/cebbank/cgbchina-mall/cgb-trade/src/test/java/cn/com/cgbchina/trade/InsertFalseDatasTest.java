package cn.com.cgbchina.trade;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import javax.annotation.Resource;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import cn.com.cgbchina.trade.dao.OrderMainDao;
import cn.com.cgbchina.trade.dao.OrderSubDao;
import cn.com.cgbchina.trade.model.OrderMainModel;
import cn.com.cgbchina.trade.model.OrderSubModel;

/**
 * 
 * @author xiewl
 * @version 2016年6月7日 下午2:38:19
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = "classpath*:spring/trade-context.xml")
@ActiveProfiles("dev")
public class InsertFalseDatasTest {
	@Resource
	private OrderSubDao orderSubDao;
	@Resource
	private OrderMainDao orderMainDao;

	@Test
	public void insertOrderSubModels() {
		// 生成30万条主订单数据
		// 生成60万条至订单数据 每两条子订单属于一条主订单 时间跨度为一个月30天，并每天2万条子订单数据，1万条主订单
		Date startDate = getLastMonth();
		int subOrderNum = 600000;
		String mainid = "";
		for (int i = 0; i < subOrderNum; i++) {
			if (i % 2 == 0) {
				mainid = String.valueOf(i);
				orderMainDao.insert(writeOrderMainModel(startDate, mainid));
			}
			orderSubDao.insert(writeOrderSubModel(startDate, String.valueOf(i), mainid));
			if ((i + 1) % 20000 == 0) {
				startDate = addDay(startDate, 1);
			}
		}
		System.out.println("finnish");
	}

	private OrderMainModel writeOrderMainModel(Date date, String id) {
		OrderMainModel orderMainModel = new OrderMainModel();
		orderMainModel.setOrdermainId(id);
		orderMainModel.setCsgAddress("佛山");
		orderMainModel.setCsgPostcode("520000");
		orderMainModel.setCsgPhone1("13888888888");
		orderMainModel.setCsgPhone2("075788888888");
		orderMainModel.setInvoice("111111111111111");
		orderMainModel.setOrdertypeId("0");
		orderMainModel.setOrdertypeNm("ooooo");
		orderMainModel.setCardno("1000000000000");
		orderMainModel.setTotalNum(1000);
		orderMainModel.setTotalPrice(new BigDecimal("1000.00"));
		orderMainModel.setIsInvoice("0");
		orderMainModel.setPermLimit(new BigDecimal("20.0"));
		orderMainModel.setCashLimit(new BigDecimal("0.00"));
		orderMainModel.setStagesLimit(new BigDecimal("1"));
		orderMainModel.setCreateTime(new Date());
		orderMainModel.setDelFlag(0);
		return orderMainModel;
	}

	private OrderSubModel writeOrderSubModel(Date date, String id, String mainId) {
		OrderSubModel orderSubModel = new OrderSubModel();
		orderSubModel.setOrderId(id);
		orderSubModel.setOrdermainId(mainId);
		orderSubModel.setOperSeq(1000);
		orderSubModel.setOrdertypeId("YG");
		orderSubModel.setOrdertypeNm("广发商城");
		orderSubModel.setPaywayCode("0001");
		orderSubModel.setPaywayNm("现金");
		orderSubModel.setCardno("1000100010001000100");
		orderSubModel.setVerifyFlag("1");
		orderSubModel.setVendorId("007");
		orderSubModel.setVendorSnm("广发电器部");
		orderSubModel.setSourceId("00");
		orderSubModel.setSourceNm("商城");
		orderSubModel.setOtSourceId("00");
		orderSubModel.setOtSourceNm("商城");
		orderSubModel.setGoodsId("100000");
		orderSubModel.setBankNbr("253");
		orderSubModel.setBonusTotalvalue(new Long((long) 100.25));
		orderSubModel.setCalMoney(new BigDecimal("200.00"));
		orderSubModel.setOrigMoney(new BigDecimal("10.00"));
		orderSubModel.setTotalMoney(new BigDecimal("190.00"));
		orderSubModel.setActType("2");
		orderSubModel.setVoucherId("V562");
		orderSubModel.setVoucherNm("youhuiquan1");
		orderSubModel.setVoucherPrice(new BigDecimal("5.00"));
		orderSubModel.setActId("00000");
		orderSubModel.setSinglePrice(new BigDecimal("5.00"));
		orderSubModel.setSingleBonus(new Long(0));
		orderSubModel.setBonusType("00");
		orderSubModel.setBonusTypeNm("开业积分");
		orderSubModel.setGoodsType("00");
		orderSubModel.setGoodsTypeName("实物");
		orderSubModel.setIsTieinSale("0");
		orderSubModel.setBalanceStatus("0003");
		orderSubModel.setBatchNo("1");
		orderSubModel.setEUpdateStatus("1");
		orderSubModel.setOrderDesc("nul");
		orderSubModel.setCardnoBenefit("1010101011");
		orderSubModel.setValidateCode("validateCode");
		orderSubModel.setGoodsPaywayId("1");
		orderSubModel.setGoodsNum(10);
		orderSubModel.setMachCode("152");
		orderSubModel.setCurrType("RMB");
		orderSubModel.setExchangeRate(new BigDecimal("1.0"));
		orderSubModel.setTypeId("11");
		orderSubModel.setSpecShopno("1000");
		orderSubModel.setCommDate(fmtDate(date));
		orderSubModel.setDelFlag("0");
		orderSubModel.setCreateTime(new Date());
		return orderSubModel;
	}

	/**
	 * 获取一个月前的日期 格式yyyyMMdd
	 * 
	 * @return
	 */
	private Date getLastMonth() {
		return addMonth(parseDate(fmtDate(new Date())), -1);
	}

	private String fmtDate(Date date) {
		return format(date, "yyyyMMdd");
	}

	private String format(Date date, String format) {
		if (date == null)
			return null;
		return new SimpleDateFormat(format).format(date);
	}

	private Date parseDate(String dateStr) {
		return parseDate(dateStr, "yyyyMMdd");
	}

	private Date parseDate(String dateStr, String pattern) {
		if (dateStr == null) {
			return null;
		}
		if (dateStr.length() != pattern.length()) {
			throw new IllegalArgumentException("参数输入不正确,日期:" + dateStr + " 格式:" + pattern);
		}
		SimpleDateFormat sdf = new SimpleDateFormat(pattern);
		try {
			sdf.setLenient(false);
			return sdf.parse(dateStr);
		} catch (Exception e) {
			throw new IllegalArgumentException(e);
		}
	}

	private Date addMonth(Date date, int i) {
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);
		calendar.add(Calendar.MONTH, i);
		return calendar.getTime();
	}

	public static Date addDay(Date date, int i) {
		if (date == null) {
			return null;
		}
		if (i == 0) {
			return date;
		}
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);
		calendar.add(Calendar.DATE, i);
		return calendar.getTime();
	}
}