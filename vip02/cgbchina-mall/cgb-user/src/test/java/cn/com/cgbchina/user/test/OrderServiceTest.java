package cn.com.cgbchina.user.test;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.spirit.util.JsonMapper;

import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.visit.model.BaseResult;
import cn.com.cgbchina.rest.visit.model.order.O2OOrderInfo;
import cn.com.cgbchina.rest.visit.model.order.ResendOrderInfo;
import cn.com.cgbchina.rest.visit.model.order.SendOrderToO2OInfo;
import cn.com.cgbchina.rest.visit.service.order.OrdersServiceImpl;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "classpath*:spring/user-service-context-test.xml",
		"classpath*:spring/mysql-dao-context-test.xml", "classpath*:spring/redis-context-test.xml" })
@ActiveProfiles("devTest")
public class OrderServiceTest {

	private JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();

	@Resource
	OrdersServiceImpl ordersServiceImpl;
	private String mainOrder="2016101110000001";
	private String subOrder="201610111000000101";
	/**
	 * �ط���ת����֤��
	 */
//	@Test
	public void test_resendOrder_01() {
		ResendOrderInfo info = BeanUtils.randomClass(ResendOrderInfo.class);
		info.setSubOrderNo(subOrder);
		info.setOrderNo(mainOrder);
		info.setMobile("13057949749");
		// ��Ӧ��Id
		info.setVendorName("10001");
		System.out.println("==============" + jsonMapper.toJson(info));
		BaseResult result = ordersServiceImpl.resendOrder(info);
		System.out.println("��������" + jsonMapper.toJson(result));
		Assert.assertNotNull(ordersServiceImpl.getClass().getName() + "�Ա�ʧ��", result);
	}

	/**
	 * O2O�������� ���ֶ������
	 */
	 @Test
	public void test_sendO2OOrderInfo_01() {

		SendOrderToO2OInfo info = BeanUtils.randomClass(SendOrderToO2OInfo.class);
		// �������
		info.setPayment(new BigDecimal(199));
		// ��Ӧ��Id
		info.setVendorName("10001");
		// ����Id ��Ϊ��
		info.setOrganId("");
		List<O2OOrderInfo> o2OOrderInfos = new ArrayList<O2OOrderInfo>();
		O2OOrderInfo o2OOrderInfo = new O2OOrderInfo();
		o2OOrderInfo.setSubOrderId(subOrder);
		// O2O��ϵͳ�ṩ�Ķ������
		o2OOrderInfo.setSOrderId("");
		// O2O��ϵͳ�ṩ�Ķһ�ȯ���
		o2OOrderInfo.setGoodsId("ymhj-COSTAbq30");
		// ����
		o2OOrderInfo.setType(0);
		// �ַ�����
		o2OOrderInfo.setNumber(1);
		// ���׽��
		o2OOrderInfo.setAmount(new BigDecimal(30));
		// ��Ʒ����
		o2OOrderInfo.setPrice(new BigDecimal(30));
		// �����ֻ�����
		o2OOrderInfo.setMobile("13057949749");

		o2OOrderInfos.add(o2OOrderInfo);
		info.setO2OOrderInfos(o2OOrderInfos);
		info.setOrderno(mainOrder);
		// info.setO2OOrderInfos();
		BaseResult result = ordersServiceImpl.sendO2OOrderInfo(info);
		System.out.println("��������" + jsonMapper.toJson(result));
		Assert.assertNotNull(ordersServiceImpl.getClass().getName() + "�Ա�ʧ��", result);
	}

	/**
	 * O2O�������� ���ڶ������
	 */
	// @Test
	public void test_sendO2OOrderInfo_02() {

		SendOrderToO2OInfo info = BeanUtils.randomClass(SendOrderToO2OInfo.class);
		// �������
		info.setPayment(new BigDecimal(244));
		// ��Ӧ��Id
		info.setVendorName("070711");
		// ����Id ��Ϊ��
		info.setOrganId("");
		List<O2OOrderInfo> o2OOrderInfos = new ArrayList<O2OOrderInfo>();
		O2OOrderInfo o2OOrderInfo = new O2OOrderInfo();
		o2OOrderInfo.setSubOrderId("201607120000000215");
		// O2O��ϵͳ�ṩ�Ķ������
		o2OOrderInfo.setSOrderId("13042");
		// O2O��ϵͳ�ṩ�Ķһ�ȯ���
		o2OOrderInfo.setGoodsId("11012");
		// ����
		o2OOrderInfo.setType(0);
		// �ַ�����
		o2OOrderInfo.setNumber(1);
		// ���׽��
		o2OOrderInfo.setAmount(new BigDecimal(244));
		// ��Ʒ����
		o2OOrderInfo.setPrice(new BigDecimal(244));
		// �����ֻ�����
		o2OOrderInfo.setMobile("13998515207");

		o2OOrderInfos.add(o2OOrderInfo);
		info.setO2OOrderInfos(o2OOrderInfos);
		// info.setO2OOrderInfos();
		BaseResult result = ordersServiceImpl.sendO2OOrderInfo(info);
		System.out.println("��������" + jsonMapper.toJson(result));
		Assert.assertNotNull(ordersServiceImpl.getClass().getName() + "�Ա�ʧ��", result);
	}

}
