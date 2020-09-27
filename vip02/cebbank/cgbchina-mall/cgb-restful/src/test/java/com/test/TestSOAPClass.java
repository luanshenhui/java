package com.test;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.UUID;

import javax.annotation.Resource;

import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.spirit.util.JsonMapper;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.vo.activity.ActivityQueryReturnVO;
import cn.com.cgbchina.rest.provider.vo.activity.ActivityQueryVO;
import cn.com.cgbchina.rest.provider.vo.activity.AreaQueryReturnVO;
import cn.com.cgbchina.rest.provider.vo.activity.AreaVO;
import cn.com.cgbchina.rest.provider.vo.activity.NoticAddReturnVO;
import cn.com.cgbchina.rest.provider.vo.activity.NoticAddVO;
import cn.com.cgbchina.rest.provider.vo.activity.NoticCancelReturnVO;
import cn.com.cgbchina.rest.provider.vo.activity.NoticCancelVO;
import cn.com.cgbchina.rest.provider.vo.activity.SPGoodsQueryVO;
import cn.com.cgbchina.rest.provider.vo.activity.SPGoodsReturnVO;
import cn.com.cgbchina.rest.provider.vo.activity.WXYXo2oGoodsQueryReturnVO;
import cn.com.cgbchina.rest.provider.vo.activity.WXYXo2oGoodsQueryVO;
import cn.com.cgbchina.rest.provider.vo.coupon.PrivilegeTypeQueryReturnVO;
import cn.com.cgbchina.rest.provider.vo.coupon.PrivilegeTypeQueryVO;
import cn.com.cgbchina.rest.provider.vo.goods.BrandTypeQueryReturnVO;
import cn.com.cgbchina.rest.provider.vo.goods.BrandTypeQueryVO;
import cn.com.cgbchina.rest.provider.vo.goods.CCIntergalPresentDetailQueryVO;
import cn.com.cgbchina.rest.provider.vo.goods.CCIntergalPresentDetailVO;
import cn.com.cgbchina.rest.provider.vo.goods.CCIntergalPresentQueryVO;
import cn.com.cgbchina.rest.provider.vo.goods.CCIntergalPresentReturnVO;
import cn.com.cgbchina.rest.provider.vo.goods.IVRIntergralPresentDetailQueryVO;
import cn.com.cgbchina.rest.provider.vo.goods.IVRIntergralPresentReturnVO;
import cn.com.cgbchina.rest.provider.vo.goods.IVRRankListQueryVO;
import cn.com.cgbchina.rest.provider.vo.goods.IVRRankListReturnVO;
import cn.com.cgbchina.rest.provider.vo.goods.MyIntergalPresentsQueryVO;
import cn.com.cgbchina.rest.provider.vo.goods.MyIntergalPresentsReturnVO;
import cn.com.cgbchina.rest.provider.vo.goods.MyLoveCGBGoodsQueryReturnVO;
import cn.com.cgbchina.rest.provider.vo.goods.MyLoveCGBGoodsQueryVO;
import cn.com.cgbchina.rest.provider.vo.goods.StageMallAdvertiseQueryReturnVO;
import cn.com.cgbchina.rest.provider.vo.goods.StageMallAdvertiseVO;
import cn.com.cgbchina.rest.provider.vo.goods.StageMallGoodsDetailByAPPQueryVO;
import cn.com.cgbchina.rest.provider.vo.goods.StageMallGoodsDetailByAPPReturnVO;
import cn.com.cgbchina.rest.provider.vo.goods.StageMallGoodsDetailQueryVO;
import cn.com.cgbchina.rest.provider.vo.goods.StageMallGoodsDetailReturnVO;
import cn.com.cgbchina.rest.provider.vo.goods.StageMallGoodsQueryReturnVO;
import cn.com.cgbchina.rest.provider.vo.goods.StageMallGoodsQueryVO;
import cn.com.cgbchina.rest.provider.vo.goods.StageMallGoodsTypeQueryReturnVO;
import cn.com.cgbchina.rest.provider.vo.goods.StageMallGoodsTypeQueryVO;
import cn.com.cgbchina.rest.provider.vo.goods.StageMallUserCommentQueryReturnVO;
import cn.com.cgbchina.rest.provider.vo.goods.StageMallUserCommentQueryVO;
import cn.com.cgbchina.rest.provider.vo.order.AppIntergralAddOrderReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.AppIntergralAddOrderVO;
import cn.com.cgbchina.rest.provider.vo.order.AppStageMallPayVerificationReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.AppStageMallPayVerificationVO;
import cn.com.cgbchina.rest.provider.vo.order.CCAddOrderByCgbAddReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.CCAddOrderByCgbAddVO;
import cn.com.cgbchina.rest.provider.vo.order.CCAndIVRIntergalOrderReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.CCAndIVRIntergalOrderVO;
import cn.com.cgbchina.rest.provider.vo.order.CCIntergralAnticipationReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.CCIntergralAnticipationVO;
import cn.com.cgbchina.rest.provider.vo.order.CCIntergralOrderCancelOrRefundReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.CCIntergralOrderCancelOrRefundVO;
import cn.com.cgbchina.rest.provider.vo.order.CCIntergralOrderDetailQueryVO;
import cn.com.cgbchina.rest.provider.vo.order.CCIntergralOrderDetailReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.CCIntergralOrderUpdateReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.CCIntergralOrderUpdateVO;
import cn.com.cgbchina.rest.provider.vo.order.CCIntergralOrdersQueryVO;
import cn.com.cgbchina.rest.provider.vo.order.CCIntergralOrdersReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.CCVerificationCodeQueryVO;
import cn.com.cgbchina.rest.provider.vo.order.CCVerificationCodeReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.IntergralAddOrderReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.IntergralAddOrderVO;
import cn.com.cgbchina.rest.provider.vo.order.IntergrallPayVerificationReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.IntergrallPayVerificationVO;
import cn.com.cgbchina.rest.provider.vo.order.PreferentialPriceRetrunVO;
import cn.com.cgbchina.rest.provider.vo.order.PreferentialPriceVO;
import cn.com.cgbchina.rest.provider.vo.order.SMSOrderAddReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.SMSOrderAddVO;
import cn.com.cgbchina.rest.provider.vo.order.StageMallOrderCancelorRefundReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.StageMallOrderCancelorRefundVO;
import cn.com.cgbchina.rest.provider.vo.order.StageMallOrderDetailReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.StageMallOrderDetailVO;
import cn.com.cgbchina.rest.provider.vo.order.StageMallOrderQueryByCCReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.StageMallOrderQueryByCCVO;
import cn.com.cgbchina.rest.provider.vo.order.StageMallOrderUpdateReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.StageMallOrderUpdateStateRetrunVO;
import cn.com.cgbchina.rest.provider.vo.order.StageMallOrderUpdateStateVO;
import cn.com.cgbchina.rest.provider.vo.order.StageMallOrderUpdateVO;
import cn.com.cgbchina.rest.provider.vo.order.StageMallOrdersDetailByAPPQueryVO;
import cn.com.cgbchina.rest.provider.vo.order.StageMallOrdersDetailByAPPReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.StageMallOrdersQueryByAPPReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.StageMallOrdersQueryByAPPVO;
import cn.com.cgbchina.rest.provider.vo.order.VerificationCodeQueryVO;
import cn.com.cgbchina.rest.provider.vo.order.VerificationCodeReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.WXIntergralRefundReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.WXIntergralVO;
import cn.com.cgbchina.rest.provider.vo.order.WXOrderAddByIntergralQueryVO;
import cn.com.cgbchina.rest.provider.vo.order.WXOrderAddByIntergralReturnVO;
import cn.com.cgbchina.rest.provider.vo.order.WXYX020FreeOrderQueryVO;
import cn.com.cgbchina.rest.provider.vo.order.WXYX020FreeOrderReturnVO;
import cn.com.cgbchina.rest.provider.vo.user.AddressDelReturnVO;
import cn.com.cgbchina.rest.provider.vo.user.AddressDelVO;
import cn.com.cgbchina.rest.provider.vo.user.AddressUpdateReturnVO;
import cn.com.cgbchina.rest.provider.vo.user.AddressUpdateVO;
import cn.com.cgbchina.rest.provider.vo.user.AppStageMallAddressAddReturnVO;
import cn.com.cgbchina.rest.provider.vo.user.AppStageMallAddressAddVO;
import cn.com.cgbchina.rest.provider.vo.user.AppStageMallAddressQueryVO;
import cn.com.cgbchina.rest.provider.vo.user.AppStageMallAddressReturnVO;
import cn.com.cgbchina.rest.provider.vo.user.CustCarAddReturnVO;
import cn.com.cgbchina.rest.provider.vo.user.CustCarAddVO;
import cn.com.cgbchina.rest.provider.vo.user.CustCarDelReturnVO;
import cn.com.cgbchina.rest.provider.vo.user.CustCarDelVO;
import cn.com.cgbchina.rest.provider.vo.user.CustCarQueryReturnVO;
import cn.com.cgbchina.rest.provider.vo.user.CustCarQueryVO;
import cn.com.cgbchina.rest.provider.vo.user.CustCarUpdateReturnVO;
import cn.com.cgbchina.rest.provider.vo.user.CustCarUpdateVO;
import cn.com.cgbchina.rest.provider.vo.user.CustInfoQueryReturnVO;
import cn.com.cgbchina.rest.provider.vo.user.CustInfoVO;
import cn.com.cgbchina.rest.provider.vo.user.OrderHistoryAddressQueryReturnVO;
import cn.com.cgbchina.rest.provider.vo.user.OrderHistoryAddressQueryVO;
import cn.com.cgbchina.rest.provider.vo.user.StageMallFavoriteAddReturnVO;
import cn.com.cgbchina.rest.provider.vo.user.StageMallFavoriteAddVO;
import cn.com.cgbchina.rest.provider.vo.user.StageMallFavoriteDelReturnVO;
import cn.com.cgbchina.rest.provider.vo.user.StageMallFavoriteDelVO;
import cn.com.cgbchina.rest.provider.vo.user.StageMallFavoriteQueryVO;
import cn.com.cgbchina.rest.provider.vo.user.StageMallFavoritesReturnVO;
import cn.com.cgbchina.restful.provider.service.activity.ActivityQueryProvideServiceImpl;
import cn.com.cgbchina.restful.provider.service.activity.AreaQueryProvideServiceImpl;
import cn.com.cgbchina.restful.provider.service.activity.NoticAddProvideServiceImpl;
import cn.com.cgbchina.restful.provider.service.activity.NoticCancelProvideServiceImpl;
import cn.com.cgbchina.restful.provider.service.activity.SPGoodsQueryProvideServiceImpl;
import cn.com.cgbchina.restful.provider.service.activity.WXYXo2oGoodsQueryProvideServiceImpl;
import cn.com.cgbchina.restful.provider.service.coupon.PrivilegeTypeQueryProvideServiceImpl;
import cn.com.cgbchina.restful.provider.service.goods.BrandTypeQueryProvideServiceImpl;
import cn.com.cgbchina.restful.provider.service.goods.CCIntergralPresentDetailProvideServiceImpl;
import cn.com.cgbchina.restful.provider.service.goods.CCIntergralPresentsQueryProvideServiceImpl;
import cn.com.cgbchina.restful.provider.service.goods.IVRIntergralPresentDetailProvideServiceImpl;
import cn.com.cgbchina.restful.provider.service.goods.IVRRankListProvideServiceImpl;
import cn.com.cgbchina.restful.provider.service.goods.MyIntergalPresentsProvideServiceImpl;
import cn.com.cgbchina.restful.provider.service.goods.MyLoveCGBGoodsQueryProvideServiceImpl;
import cn.com.cgbchina.restful.provider.service.goods.StageMallAdvertiseQueryProvideServiceImpl;
import cn.com.cgbchina.restful.provider.service.goods.StageMallGoodsDetailByAPPProvideServiceImpl;
import cn.com.cgbchina.restful.provider.service.goods.StageMallGoodsDetailProvideServiceImpl;
import cn.com.cgbchina.restful.provider.service.goods.StageMallGoodsQueryProvideServiceImpl;
import cn.com.cgbchina.restful.provider.service.goods.StageMallGoodsTypeQueryProvideServiceImpl;
import cn.com.cgbchina.restful.provider.service.goods.StageMallUserCommentQueryProvideServiceImpl;
import cn.com.cgbchina.restful.provider.service.order.AppIntergralAddOrderProvideServiceImpl;
import cn.com.cgbchina.restful.provider.service.order.AppStageMallPayVerificationProvideServiceImpl;
import cn.com.cgbchina.restful.provider.service.order.CCAddOrderByCgbProvideServiceImpl;
import cn.com.cgbchina.restful.provider.service.order.CCAndIVRIntergralAddOrderProvideServiceImpl;
import cn.com.cgbchina.restful.provider.service.order.CCIntergralAnticipationProvideServiceImpl;
import cn.com.cgbchina.restful.provider.service.order.CCIntergralOrderCancelOrRefundProvideServiceImpl;
import cn.com.cgbchina.restful.provider.service.order.CCIntergralOrderDetailProvideServiceImpl;
import cn.com.cgbchina.restful.provider.service.order.CCIntergralOrderUpdateProvideServiceImpl;
import cn.com.cgbchina.restful.provider.service.order.CCIntergralOrdersQueryProvideServiceImpl;
import cn.com.cgbchina.restful.provider.service.order.CCVerificationCodeProvideServiceImpl;
import cn.com.cgbchina.restful.provider.service.order.IntergralAddOrderProvideServiceImpl;
import cn.com.cgbchina.restful.provider.service.order.IntergrallPayVerificationProvideServiceImpl;
import cn.com.cgbchina.restful.provider.service.order.PreferentialPriceQueryProvideServiceImpl;
import cn.com.cgbchina.restful.provider.service.order.SMSOrderAddProvideServiceImpl;
import cn.com.cgbchina.restful.provider.service.order.StageMallOrderCancelorRefundProvideServiceImpl;
import cn.com.cgbchina.restful.provider.service.order.StageMallOrderDetailProvideServiceImpl;
import cn.com.cgbchina.restful.provider.service.order.StageMallOrderQueryByCCProvideServiceImpl;
import cn.com.cgbchina.restful.provider.service.order.StageMallOrderUpdateProvideServiceImpl;
import cn.com.cgbchina.restful.provider.service.order.StageMallOrderUpdateStateProvideServiceImpl;
import cn.com.cgbchina.restful.provider.service.order.StageMallOrdersDetailByAPPProvideServiceImpl;
import cn.com.cgbchina.restful.provider.service.order.StageMallOrdersQueryByAPPProvideServiceImpl;
import cn.com.cgbchina.restful.provider.service.order.WXIntergralRefundProvideServiceImpl;
import cn.com.cgbchina.restful.provider.service.order.WXOrderAddByIntergralProvideServiceImpl;
import cn.com.cgbchina.restful.provider.service.order.WXYX020FreeOrderAddProvideServiceImpl;
import cn.com.cgbchina.restful.provider.service.order.WXYXVerificationCodeProvideServiceImpl;
import cn.com.cgbchina.restful.provider.service.user.AddressDelProvideServiceImpl;
import cn.com.cgbchina.restful.provider.service.user.AddressUpdateProvideServiceImpl;
import cn.com.cgbchina.restful.provider.service.user.AppStageMallAddressAddProvideServiceImpl;
import cn.com.cgbchina.restful.provider.service.user.AppStageMallAddressQueryProvideServiceImpl;
import cn.com.cgbchina.restful.provider.service.user.CustCarAddProvideServiceImpl;
import cn.com.cgbchina.restful.provider.service.user.CustCarDelProvideServiceImpl;
import cn.com.cgbchina.restful.provider.service.user.CustCarQueryProvideServiceImpl;
import cn.com.cgbchina.restful.provider.service.user.CustCarUpdateProvideServiceImpl;
import cn.com.cgbchina.restful.provider.service.user.CustInfoQueryProvideServiceImpl;
import cn.com.cgbchina.restful.provider.service.user.OrderHistoryAddressQueryProvideServiceImpl;
import cn.com.cgbchina.restful.provider.service.user.StageMallFavoriteAddProvideServiceImpl;
import cn.com.cgbchina.restful.provider.service.user.StageMallFavoriteDelProvideServiceImpl;
import cn.com.cgbchina.restful.provider.service.user.StageMallFavoriteQueryProvideServiceImpl;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = "classpath*:spring/rest-service-context.xml")
@ActiveProfiles("dev")
public class TestSOAPClass {

	private JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();

	private SoapModel createSopa(Object obj) {
		String codes = null;
		TradeCode code = obj.getClass().getAnnotation(TradeCode.class);
		if (code != null) {
			codes = code.value();
		}
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		SimpleDateFormat sdf2 = new SimpleDateFormat("HHmmss");
		SoapModel sopaModel = new SoapModel();
		sopaModel.setVersionNo("1");
		sopaModel.setToEncrypt("0");
		sopaModel.setCommCode("50001");
		sopaModel.setCommType("0");
		sopaModel.setReceiverId("BPSN");
		sopaModel.setSenderId("SHOP");
		sopaModel.setSenderSN(UUID.randomUUID().toString());
		sopaModel.setSenderDate(sdf.format(new Date()));
		sopaModel.setSenderTime(sdf2.format(new Date()));
		sopaModel.setTradeCode(codes);
		return sopaModel;
	}

	@Test
	public void MAL330ActivityQueryProvideServiceImplTest() {
		SoapModel model = createSopa(activityQueryProvideServiceImpl);
		ActivityQueryVO content = BeanUtils.randomClass(ActivityQueryVO.class);
		ActivityQueryReturnVO result = activityQueryProvideServiceImpl.process(model, content);
		System.out.println("输出结果:" + jsonMapper.toJson(result));
		Assert.assertNotNull(activityQueryProvideServiceImpl.getClass().getName() + " 测试失败", result);
	}

	@Test
	public void MAL101CCIntergralPresentsQueryProvideServiceImplTEST() {
		SoapModel model = createSopa(cCIntergralPresentsQueryProvideServiceImpl);
		CCIntergalPresentQueryVO content = BeanUtils.randomClass(CCIntergalPresentQueryVO.class);
		CCIntergalPresentReturnVO result = cCIntergralPresentsQueryProvideServiceImpl.process(model, content);
		System.out.println("输出结果:" + jsonMapper.toJson(result));
		Assert.assertNotNull(cCIntergralPresentsQueryProvideServiceImpl.getClass().getName() + " 测试失败", result);
	}

	@Test
	public void MAL102CCIntergralPresentDetailProvideServiceImplTEST() {
		SoapModel model = createSopa(cCIntergralPresentDetailProvideServiceImpl);
		CCIntergalPresentDetailQueryVO content = BeanUtils.randomClass(CCIntergalPresentDetailQueryVO.class);
		CCIntergalPresentDetailVO result = cCIntergralPresentDetailProvideServiceImpl.process(model, content);
		System.out.println("输出结果:" + jsonMapper.toJson(result));
		Assert.assertNotNull(cCIntergralPresentDetailProvideServiceImpl.getClass().getName() + " 测试失败", result);
	}

	@Test
	public void MAL103IVRIntergralPresentDetailProvideServiceImplTEST() {
		SoapModel model = createSopa(iVRIntergralPresentDetailProvideServiceImpl);
		IVRIntergralPresentDetailQueryVO content = BeanUtils.randomClass(IVRIntergralPresentDetailQueryVO.class);
		IVRIntergralPresentReturnVO result = iVRIntergralPresentDetailProvideServiceImpl.process(model, content);
		System.out.println("输出结果:" + jsonMapper.toJson(result));
		Assert.assertNotNull(iVRIntergralPresentDetailProvideServiceImpl.getClass().getName() + " 测试失败", result);
	}

	@Test
	public void MAL104CCAndIVRIntergralAddOrderProvideServiceImplTEST() {
		SoapModel model = createSopa(cCAndIVRIntergralAddOrderProvideServiceImpl);
		CCAndIVRIntergalOrderVO content = BeanUtils.randomClass(CCAndIVRIntergalOrderVO.class);
		CCAndIVRIntergalOrderReturnVO result = cCAndIVRIntergralAddOrderProvideServiceImpl.process(model, content);
		System.out.println("输出结果:" + jsonMapper.toJson(result));
		Assert.assertNotNull(cCAndIVRIntergralAddOrderProvideServiceImpl.getClass().getName() + " 测试失败", result);
	}

	@Test
	public void MAL105CCIntergralOrdersQueryProvideServiceImplTEST() {
		SoapModel model = createSopa(cCIntergralOrdersQueryProvideServiceImpl);
		CCIntergralOrdersQueryVO content = BeanUtils.randomClass(CCIntergralOrdersQueryVO.class);
		CCIntergralOrdersReturnVO result = cCIntergralOrdersQueryProvideServiceImpl.process(model, content);
		System.out.println("输出结果:" + jsonMapper.toJson(result));
		Assert.assertNotNull(cCIntergralOrdersQueryProvideServiceImpl.getClass().getName() + " 测试失败", result);
	}

	@Test
	public void MAL106CCIntergralOrderUpdateProvideServiceImplTEST() {
		SoapModel model = createSopa(cCIntergralOrderUpdateProvideServiceImpl);
		CCIntergralOrderUpdateVO content = BeanUtils.randomClass(CCIntergralOrderUpdateVO.class);
		CCIntergralOrderUpdateReturnVO result = cCIntergralOrderUpdateProvideServiceImpl.process(model, content);
		System.out.println("输出结果:" + jsonMapper.toJson(result));
		Assert.assertNotNull(cCIntergralOrderUpdateProvideServiceImpl.getClass().getName() + " 测试失败", result);
	}

	@Test
	public void MAL107CCIntergralOrderCancelOrRefundProvideServiceImplTEST() {
		SoapModel model = createSopa(cCIntergralOrderCancelOrRefundProvideServiceImpl);
		CCIntergralOrderCancelOrRefundVO content = BeanUtils.randomClass(CCIntergralOrderCancelOrRefundVO.class);
		CCIntergralOrderCancelOrRefundReturnVO result = cCIntergralOrderCancelOrRefundProvideServiceImpl.process(model,
				content);
		System.out.println("输出结果:" + jsonMapper.toJson(result));
		Assert.assertNotNull(cCIntergralOrderCancelOrRefundProvideServiceImpl.getClass().getName() + " 测试失败", result);
	}

	@Test
	public void MAL108CCIntergralOrderDetailProvideServiceImplTEST() {
		SoapModel model = createSopa(cCIntergralOrderDetailProvideServiceImpl);
		CCIntergralOrderDetailQueryVO content = BeanUtils.randomClass(CCIntergralOrderDetailQueryVO.class);
		CCIntergralOrderDetailReturnVO result = cCIntergralOrderDetailProvideServiceImpl.process(model, content);
		System.out.println("输出结果:" + jsonMapper.toJson(result));
		Assert.assertNotNull(cCIntergralOrderDetailProvideServiceImpl.getClass().getName() + " 测试失败", result);
	}

	@Test
	public void MAL109StageMallOrderUpdateProvideServiceImplTEST() {
		SoapModel model = createSopa(stageMallOrderUpdateProvideServiceImpl);
		StageMallOrderUpdateVO content = BeanUtils.randomClass(StageMallOrderUpdateVO.class);
		StageMallOrderUpdateReturnVO result = stageMallOrderUpdateProvideServiceImpl.process(model, content);
		System.out.println("输出结果:" + jsonMapper.toJson(result));
		Assert.assertNotNull(stageMallOrderUpdateProvideServiceImpl.getClass().getName() + " 测试失败", result);
	}

	@Test
	public void MAL110StageMallOrderCancelorRefundProvideServiceImplTEST() {
		SoapModel model = createSopa(stageMallOrderCancelorRefundProvideServiceImpl);
		StageMallOrderCancelorRefundVO content = BeanUtils.randomClass(StageMallOrderCancelorRefundVO.class);
		StageMallOrderCancelorRefundReturnVO result = stageMallOrderCancelorRefundProvideServiceImpl.process(model,
				content);
		System.out.println("输出结果:" + jsonMapper.toJson(result));
		Assert.assertNotNull(stageMallOrderCancelorRefundProvideServiceImpl.getClass().getName() + " 测试失败", result);
	}

	@Test
	public void MAL111StageMallOrderDetailProvideServiceImplTEST() {
		SoapModel model = createSopa(stageMallOrderDetailProvideServiceImpl);
		StageMallOrderDetailVO content = BeanUtils.randomClass(StageMallOrderDetailVO.class);
		StageMallOrderDetailReturnVO result = stageMallOrderDetailProvideServiceImpl.process(model, content);
		System.out.println("输出结果:" + jsonMapper.toJson(result));
		Assert.assertNotNull(stageMallOrderDetailProvideServiceImpl.getClass().getName() + " 测试失败", result);
	}

	@Test
	public void MAL113StageMallOrderQueryByCCProvideServiceImplTEST() {
		SoapModel model = createSopa(stageMallOrderQueryByCCProvideServiceImpl);
		StageMallOrderQueryByCCVO content = BeanUtils.randomClass(StageMallOrderQueryByCCVO.class);
		StageMallOrderQueryByCCReturnVO result = stageMallOrderQueryByCCProvideServiceImpl.process(model, content);
		System.out.println("输出结果:" + jsonMapper.toJson(result));
		Assert.assertNotNull(stageMallOrderQueryByCCProvideServiceImpl.getClass().getName() + " 测试失败", result);
	}

	@Test
	public void MAL114OrderHistoryAddressQueryProvideServiceImplTEST() {
		SoapModel model = createSopa(orderHistoryAddressQueryProvideServiceImpl);
		OrderHistoryAddressQueryVO content = BeanUtils.randomClass(OrderHistoryAddressQueryVO.class);
		OrderHistoryAddressQueryReturnVO result = orderHistoryAddressQueryProvideServiceImpl.process(model, content);
		System.out.println("输出结果:" + jsonMapper.toJson(result));
		Assert.assertNotNull(orderHistoryAddressQueryProvideServiceImpl.getClass().getName() + " 测试失败", result);
	}

	@Test
	public void MAL115CCAddOrderByCgbProvideServiceImplTEST() {
		SoapModel model = createSopa(cCAddOrderByCgbProvideServiceImpl);
		CCAddOrderByCgbAddVO content = BeanUtils.randomClass(CCAddOrderByCgbAddVO.class);
		CCAddOrderByCgbAddReturnVO result = cCAddOrderByCgbProvideServiceImpl.process(model, content);
		System.out.println("输出结果:" + jsonMapper.toJson(result));
		Assert.assertNotNull(cCAddOrderByCgbProvideServiceImpl.getClass().getName() + " 测试失败", result);
	}

	@Test
	public void MAL117StageMallGoodsDetailProvideServiceImplTEST() {
		SoapModel model = createSopa(stageMallGoodsDetailProvideServiceImpl);
		StageMallGoodsDetailQueryVO content = BeanUtils.randomClass(StageMallGoodsDetailQueryVO.class);
		StageMallGoodsDetailReturnVO result = stageMallGoodsDetailProvideServiceImpl.process(model, content);
		System.out.println("输出结果:" + jsonMapper.toJson(result));
		Assert.assertNotNull(stageMallGoodsDetailProvideServiceImpl.getClass().getName() + " 测试失败", result);
	}

	@Test
	public void MAL120PrivilegeTypeQueryProvideServiceImplTEST() {
		SoapModel model = createSopa(privilegeTypeQueryProvideServiceImpl);
		PrivilegeTypeQueryVO content = BeanUtils.randomClass(PrivilegeTypeQueryVO.class);
		PrivilegeTypeQueryReturnVO result = privilegeTypeQueryProvideServiceImpl.process(model, content);
		System.out.println("输出结果:" + jsonMapper.toJson(result));
		Assert.assertNotNull(privilegeTypeQueryProvideServiceImpl.getClass().getName() + " 测试失败", result);
	}

	@Test
	public void MAL121CCVerificationCodeProvideServiceImplTEST() {
		SoapModel model = createSopa(cCVerificationCodeProvideServiceImpl);
		CCVerificationCodeQueryVO content = BeanUtils.randomClass(CCVerificationCodeQueryVO.class);
		CCVerificationCodeReturnVO result = cCVerificationCodeProvideServiceImpl.process(model, content);
		System.out.println("输出结果:" + jsonMapper.toJson(result));
		Assert.assertNotNull(cCVerificationCodeProvideServiceImpl.getClass().getName() + " 测试失败", result);
	}

	@Test
	public void MAL201CCIntergralAnticipationProvideServiceImplTEST() {
		SoapModel model = createSopa(cCIntergralAnticipationProvideServiceImpl);
		CCIntergralAnticipationVO content = BeanUtils.randomClass(CCIntergralAnticipationVO.class);
		CCIntergralAnticipationReturnVO result = cCIntergralAnticipationProvideServiceImpl.process(model, content);
		System.out.println("输出结果:" + jsonMapper.toJson(result));
		Assert.assertNotNull(cCIntergralAnticipationProvideServiceImpl.getClass().getName() + " 测试失败", result);
	}

	@Test
	public void MAL202IVRRankListProvideServiceImplTEST() {
		SoapModel model = createSopa(iVRRankListProvideServiceImpl);
		IVRRankListQueryVO content = BeanUtils.randomClass(IVRRankListQueryVO.class);
		IVRRankListReturnVO result = iVRRankListProvideServiceImpl.process(model, content);
		System.out.println("输出结果:" + jsonMapper.toJson(result));
		Assert.assertNotNull(iVRRankListProvideServiceImpl.getClass().getName() + " 测试失败", result);
	}

	@Test
	public void MAL112StageMallOrderUpdateStateProvideServiceImplTEST() {
		SoapModel model = createSopa(stageMallOrderUpdateStateProvideServiceImpl);
		StageMallOrderUpdateStateVO content = BeanUtils.randomClass(StageMallOrderUpdateStateVO.class);
		StageMallOrderUpdateStateRetrunVO result = stageMallOrderUpdateStateProvideServiceImpl.process(model, content);
		System.out.println("输出结果:" + jsonMapper.toJson(result));
		Assert.assertNotNull(stageMallOrderUpdateStateProvideServiceImpl.getClass().getName() + " 测试失败", result);
	}

	@Test
	public void MAL118MyIntergalPresentsProvideServiceImplTEST() {
		SoapModel model = createSopa(myIntergalPresentsProvideServiceImpl);
		MyIntergalPresentsQueryVO content = BeanUtils.randomClass(MyIntergalPresentsQueryVO.class);
		MyIntergalPresentsReturnVO result = myIntergalPresentsProvideServiceImpl.process(model, content);
		System.out.println("输出结果:" + jsonMapper.toJson(result));
		Assert.assertNotNull(myIntergalPresentsProvideServiceImpl.getClass().getName() + " 测试失败", result);
	}

	@Test
	public void MAL119MyLoveCGBGoodsQueryProvideServiceImplTEST() {
		SoapModel model = createSopa(myLoveCGBGoodsQueryProvideServiceImpl);
		MyLoveCGBGoodsQueryVO content = BeanUtils.randomClass(MyLoveCGBGoodsQueryVO.class);
		MyLoveCGBGoodsQueryReturnVO result = myLoveCGBGoodsQueryProvideServiceImpl.process(model, content);
		System.out.println("输出结果:" + jsonMapper.toJson(result));
		Assert.assertNotNull(myLoveCGBGoodsQueryProvideServiceImpl.getClass().getName() + " 测试失败", result);
	}

	@Test
	public void MAL301StageMallFavoriteAddProvideServiceImplTEST() {
		SoapModel model = createSopa(stageMallFavoriteAddProvideServiceImpl);
		StageMallFavoriteAddVO content = BeanUtils.randomClass(StageMallFavoriteAddVO.class);
		StageMallFavoriteAddReturnVO result = stageMallFavoriteAddProvideServiceImpl.process(model, content);
		System.out.println("输出结果:" + jsonMapper.toJson(result));
		Assert.assertNotNull(stageMallFavoriteAddProvideServiceImpl.getClass().getName() + " 测试失败", result);
	}

	@Test
	public void MAL302StageMallFavoriteQueryProvideServiceImplTEST() {
		SoapModel model = createSopa(stageMallFavoriteQueryProvideServiceImpl);
		StageMallFavoriteQueryVO content = BeanUtils.randomClass(StageMallFavoriteQueryVO.class);
		StageMallFavoritesReturnVO result = stageMallFavoriteQueryProvideServiceImpl.process(model, content);
		System.out.println("输出结果:" + jsonMapper.toJson(result));
		Assert.assertNotNull(stageMallFavoriteQueryProvideServiceImpl.getClass().getName() + " 测试失败", result);
	}

	@Test
	public void MAL303StageMallFavoriteDelProvideServiceImplTEST() {
		SoapModel model = createSopa(stageMallFavoriteDelProvideServiceImpl);
		StageMallFavoriteDelVO content = BeanUtils.randomClass(StageMallFavoriteDelVO.class);
		StageMallFavoriteDelReturnVO result = stageMallFavoriteDelProvideServiceImpl.process(model, content);
		System.out.println("输出结果:" + jsonMapper.toJson(result));
		Assert.assertNotNull(stageMallFavoriteDelProvideServiceImpl.getClass().getName() + " 测试失败", result);
	}

	@Test
	public void MAL304CustCarAddProvideServiceImplTEST() {
		SoapModel model = createSopa(custCarAddProvideServiceImpl);
		CustCarAddVO content = BeanUtils.randomClass(CustCarAddVO.class);
		CustCarAddReturnVO result = custCarAddProvideServiceImpl.process(model, content);
		System.out.println("输出结果:" + jsonMapper.toJson(result));
		Assert.assertNotNull(custCarAddProvideServiceImpl.getClass().getName() + " 测试失败", result);
	}

	@Test
	public void MAL305CustCarQueryProvideServiceImplTEST() {
		SoapModel model = createSopa(custCarQueryProvideServiceImpl);
		CustCarQueryVO content = BeanUtils.randomClass(CustCarQueryVO.class);
		CustCarQueryReturnVO result = custCarQueryProvideServiceImpl.process(model, content);
		System.out.println("输出结果:" + jsonMapper.toJson(result));
		Assert.assertNotNull(custCarQueryProvideServiceImpl.getClass().getName() + " 测试失败", result);
	}

	@Test
	public void MAL306CustCarUpdateProvideServiceImplTEST() {
		SoapModel model = createSopa(custCarUpdateProvideServiceImpl);
		CustCarUpdateVO content = BeanUtils.randomClass(CustCarUpdateVO.class);
		CustCarUpdateReturnVO result = custCarUpdateProvideServiceImpl.process(model, content);
		System.out.println("输出结果:" + jsonMapper.toJson(result));
		Assert.assertNotNull(custCarUpdateProvideServiceImpl.getClass().getName() + " 测试失败", result);
	}

	@Test
	public void MAL307CustCarDelProvideServiceImplTEST() {
		SoapModel model = createSopa(custCarDelProvideServiceImpl);
		CustCarDelVO content = BeanUtils.randomClass(CustCarDelVO.class);
		CustCarDelReturnVO result = custCarDelProvideServiceImpl.process(model, content);
		System.out.println("输出结果:" + jsonMapper.toJson(result));
		Assert.assertNotNull(custCarDelProvideServiceImpl.getClass().getName() + " 测试失败", result);
	}

	@Test
	public void MAL308StageMallOrdersQueryByAPPProvideServiceImplTEST() {
		SoapModel model = createSopa(stageMallOrdersQueryByAPPProvideServiceImpl);
		StageMallOrdersQueryByAPPVO content = BeanUtils.randomClass(StageMallOrdersQueryByAPPVO.class);
		StageMallOrdersQueryByAPPReturnVO result = stageMallOrdersQueryByAPPProvideServiceImpl.process(model, content);
		System.out.println("输出结果:" + jsonMapper.toJson(result));
		Assert.assertNotNull(stageMallOrdersQueryByAPPProvideServiceImpl.getClass().getName() + " 测试失败", result);
	}

	@Test
	public void MAL309StageMallOrdersDetailByAPPProvideServiceImplTEST() {
		SoapModel model = createSopa(stageMallOrdersDetailByAPPProvideServiceImpl);
		StageMallOrdersDetailByAPPQueryVO content = BeanUtils.randomClass(StageMallOrdersDetailByAPPQueryVO.class);
		StageMallOrdersDetailByAPPReturnVO result = stageMallOrdersDetailByAPPProvideServiceImpl.process(model,
				content);
		System.out.println("输出结果:" + jsonMapper.toJson(result));
		Assert.assertNotNull(stageMallOrdersDetailByAPPProvideServiceImpl.getClass().getName() + " 测试失败", result);
	}

	@Test
	public void MAL311StageMallGoodsTypeQueryProvideServiceImplTEST() {
		SoapModel model = createSopa(stageMallGoodsTypeQueryProvideServiceImpl);
		StageMallGoodsTypeQueryVO content = BeanUtils.randomClass(StageMallGoodsTypeQueryVO.class);
		StageMallGoodsTypeQueryReturnVO result = stageMallGoodsTypeQueryProvideServiceImpl.process(model, content);
		System.out.println("输出结果:" + jsonMapper.toJson(result));
		Assert.assertNotNull(stageMallGoodsTypeQueryProvideServiceImpl.getClass().getName() + " 测试失败", result);
	}

	@Test
	public void MAL312StageMallGoodsQueryProvideServiceImplTEST() {
		SoapModel model = createSopa(stageMallGoodsQueryProvideServiceImpl);
		StageMallGoodsQueryVO content = BeanUtils.randomClass(StageMallGoodsQueryVO.class);
		StageMallGoodsQueryReturnVO result = stageMallGoodsQueryProvideServiceImpl.process(model, content);
		System.out.println("输出结果:" + jsonMapper.toJson(result));
		Assert.assertNotNull(stageMallGoodsQueryProvideServiceImpl.getClass().getName() + " 测试失败", result);
	}

	@Test
	public void MAL313StageMallGoodsDetailByAPPProvideServiceImplTEST() {
		SoapModel model = createSopa(stageMallGoodsDetailByAPPProvideServiceImpl);
		StageMallGoodsDetailByAPPQueryVO content = BeanUtils.randomClass(StageMallGoodsDetailByAPPQueryVO.class);
		StageMallGoodsDetailByAPPReturnVO result = stageMallGoodsDetailByAPPProvideServiceImpl.process(model, content);
		System.out.println("输出结果:" + jsonMapper.toJson(result));
		Assert.assertNotNull(stageMallGoodsDetailByAPPProvideServiceImpl.getClass().getName() + " 测试失败", result);
	}

	@Test
	public void MAL320StageMallUserCommentQueryProvideServiceImplTEST() {
		SoapModel model = createSopa(stageMallUserCommentQueryProvideServiceImpl);
		StageMallUserCommentQueryVO content = BeanUtils.randomClass(StageMallUserCommentQueryVO.class);
		StageMallUserCommentQueryReturnVO result = stageMallUserCommentQueryProvideServiceImpl.process(model, content);
		System.out.println("输出结果:" + jsonMapper.toJson(result));
		Assert.assertNotNull(stageMallUserCommentQueryProvideServiceImpl.getClass().getName() + " 测试失败", result);
	}

	@Test
	public void MAL321StageMallAdvertiseQueryProvideServiceImplTEST() {
		SoapModel model = createSopa(stageMallAdvertiseQueryProvideServiceImpl);
		StageMallAdvertiseVO content = BeanUtils.randomClass(StageMallAdvertiseVO.class);
		StageMallAdvertiseQueryReturnVO result = stageMallAdvertiseQueryProvideServiceImpl.process(model, content);
		System.out.println("输出结果:" + jsonMapper.toJson(result));
		Assert.assertNotNull(stageMallAdvertiseQueryProvideServiceImpl.getClass().getName() + " 测试失败", result);
	}

	@Test
	public void MAL322PreferentialPriceQueryProvideServiceImplTEST() {
		SoapModel model = createSopa(preferentialPriceQueryProvideServiceImpl);
		PreferentialPriceVO content = BeanUtils.randomClass(PreferentialPriceVO.class);
		PreferentialPriceRetrunVO result = preferentialPriceQueryProvideServiceImpl.process(model, content);
		System.out.println("输出结果:" + jsonMapper.toJson(result));
		Assert.assertNotNull(preferentialPriceQueryProvideServiceImpl.getClass().getName() + " 测试失败", result);
	}

	@Test
	public void MAL323CustInfoQueryProvideServiceImplTEST() {
		SoapModel model = createSopa(custInfoQueryProvideServiceImpl);
		CustInfoVO content = BeanUtils.randomClass(CustInfoVO.class);
		CustInfoQueryReturnVO result = custInfoQueryProvideServiceImpl.process(model, content);
		System.out.println("输出结果:" + jsonMapper.toJson(result));
		Assert.assertNotNull(custInfoQueryProvideServiceImpl.getClass().getName() + " 测试失败", result);
	}

	@Test
	public void MAL326AreaQueryProvideServiceImplTEST() {
		SoapModel model = createSopa(areaQueryProvideServiceImpl);
		AreaVO content = BeanUtils.randomClass(AreaVO.class);
		AreaQueryReturnVO result = areaQueryProvideServiceImpl.process(model, content);
		System.out.println("输出结果:" + jsonMapper.toJson(result));
		Assert.assertNotNull(areaQueryProvideServiceImpl.getClass().getName() + " 测试失败", result);
	}

	@Test
	public void MAL330ActivityQueryProvideServiceImplTEST() {
		SoapModel model = createSopa(activityQueryProvideServiceImpl);
		ActivityQueryVO content = BeanUtils.randomClass(ActivityQueryVO.class);
		ActivityQueryReturnVO result = activityQueryProvideServiceImpl.process(model, content);
		System.out.println("输出结果:" + jsonMapper.toJson(result));
		Assert.assertNotNull(activityQueryProvideServiceImpl.getClass().getName() + " 测试失败", result);
	}

	@Test
	public void MAL331NoticAddProvideServiceImplTEST() {
		SoapModel model = createSopa(noticAddProvideServiceImpl);
		NoticAddVO content = BeanUtils.randomClass(NoticAddVO.class);
		NoticAddReturnVO result = noticAddProvideServiceImpl.process(model, content);
		System.out.println("输出结果:" + jsonMapper.toJson(result));
		Assert.assertNotNull(noticAddProvideServiceImpl.getClass().getName() + " 测试失败", result);
	}

	@Test
	public void MAL332NoticCancelProvideServiceImplTEST() {
		SoapModel model = createSopa(noticCancelProvideServiceImpl);
		NoticCancelVO content = BeanUtils.randomClass(NoticCancelVO.class);
		NoticCancelReturnVO result = noticCancelProvideServiceImpl.process(model, content);
		System.out.println("输出结果:" + jsonMapper.toJson(result));
		Assert.assertNotNull(noticCancelProvideServiceImpl.getClass().getName() + " 测试失败", result);
	}

	@Test
	public void MAL333AddressUpdateProvideServiceImplTEST() {
		SoapModel model = createSopa(addressUpdateProvideServiceImpl);
		AddressUpdateVO content = BeanUtils.randomClass(AddressUpdateVO.class);
		AddressUpdateReturnVO result = addressUpdateProvideServiceImpl.process(model, content);
		System.out.println("输出结果:" + jsonMapper.toJson(result));
		Assert.assertNotNull(addressUpdateProvideServiceImpl.getClass().getName() + " 测试失败", result);
	}

	@Test
	public void MAL334AddressDelProvideServiceImplTEST() {
		SoapModel model = createSopa(addressDelProvideServiceImpl);
		AddressDelVO content = BeanUtils.randomClass(AddressDelVO.class);
		AddressDelReturnVO result = addressDelProvideServiceImpl.process(model, content);
		System.out.println("输出结果:" + jsonMapper.toJson(result));
		Assert.assertNotNull(addressDelProvideServiceImpl.getClass().getName() + " 测试失败", result);
	}

	@Test
	public void MAL335SPGoodsQueryProvideServiceImplTEST() {
		SoapModel model = createSopa(sPGoodsQueryProvideServiceImpl);
		SPGoodsQueryVO content = BeanUtils.randomClass(SPGoodsQueryVO.class);
		SPGoodsReturnVO result = sPGoodsQueryProvideServiceImpl.process(model, content);
		System.out.println("输出结果:" + jsonMapper.toJson(result));
		Assert.assertNotNull(sPGoodsQueryProvideServiceImpl.getClass().getName() + " 测试失败", result);
	}

	@Test
	public void MAL336BrandTypeQueryProvideServiceImplTEST() {
		SoapModel model = createSopa(brandTypeQueryProvideServiceImpl);
		BrandTypeQueryVO content = BeanUtils.randomClass(BrandTypeQueryVO.class);
		BrandTypeQueryReturnVO result = brandTypeQueryProvideServiceImpl.process(model, content);
		System.out.println("输出结果:" + jsonMapper.toJson(result));
		Assert.assertNotNull(brandTypeQueryProvideServiceImpl.getClass().getName() + " 测试失败", result);
	}

	@Test
	public void MAL421WXYXo2oGoodsQueryProvideServiceImplTEST() {
		SoapModel model = createSopa(wXYXo2oGoodsQueryProvideServiceImpl);
		WXYXo2oGoodsQueryVO content = BeanUtils.randomClass(WXYXo2oGoodsQueryVO.class);
		WXYXo2oGoodsQueryReturnVO result = wXYXo2oGoodsQueryProvideServiceImpl.process(model, content);
		System.out.println("输出结果:" + jsonMapper.toJson(result));
		Assert.assertNotNull(wXYXo2oGoodsQueryProvideServiceImpl.getClass().getName() + " 测试失败", result);
	}

	@Test
	public void MAL422WXYXVerificationCodeProvideServiceImplTEST() {
		SoapModel model = createSopa(wXYXVerificationCodeProvideServiceImpl);
		VerificationCodeQueryVO content = BeanUtils.randomClass(VerificationCodeQueryVO.class);
		VerificationCodeReturnVO result = wXYXVerificationCodeProvideServiceImpl.process(model, content);
		System.out.println("输出结果:" + jsonMapper.toJson(result));
		Assert.assertNotNull(wXYXVerificationCodeProvideServiceImpl.getClass().getName() + " 测试失败", result);
	}

	@Test
	public void MAL423WXYX020FreeOrderAddProvideServiceImplTEST() {
		SoapModel model = createSopa(wXYX020FreeOrderAddProvideServiceImpl);
		WXYX020FreeOrderQueryVO content = BeanUtils.randomClass(WXYX020FreeOrderQueryVO.class);
		WXYX020FreeOrderReturnVO result = wXYX020FreeOrderAddProvideServiceImpl.process(model, content);
		System.out.println("输出结果:" + jsonMapper.toJson(result));
		Assert.assertNotNull(wXYX020FreeOrderAddProvideServiceImpl.getClass().getName() + " 测试失败", result);
	}

	@Test
	public void MAL501WXOrderAddByIntergralProvideServiceImplTEST() {
		SoapModel model = createSopa(wXOrderAddByIntergralProvideServiceImpl);
		WXOrderAddByIntergralQueryVO content = BeanUtils.randomClass(WXOrderAddByIntergralQueryVO.class);
		WXOrderAddByIntergralReturnVO result = wXOrderAddByIntergralProvideServiceImpl.process(model, content);
		System.out.println("输出结果:" + jsonMapper.toJson(result));
		Assert.assertNotNull(wXOrderAddByIntergralProvideServiceImpl.getClass().getName() + " 测试失败", result);
	}

	/*
	 * @Test public void MAL503WXPayProvideServiceImplTEST() { SoapModel model = createSopa(wXPayProvideServiceImpl);
	 * WXPayVO content = BeanUtils.randomClass(WXPayVO.class); WXPayReturnVO result =
	 * wXPayProvideServiceImpl.process(model, content); System.out.println("输出结果:" + jsonMapper.toJson(result));
	 * Assert.assertNotNull(wXPayProvideServiceImpl.getClass().getName() + " 测试失败", result); }
	 */

	@Test
	public void MAL502WXIntergralRefundProvideServiceImplTEST() {
		SoapModel model = createSopa(wXIntergralRefundProvideServiceImpl);
		WXIntergralVO content = BeanUtils.randomClass(WXIntergralVO.class);
		WXIntergralRefundReturnVO result = wXIntergralRefundProvideServiceImpl.process(model, content);
		System.out.println("输出结果:" + jsonMapper.toJson(result));
		Assert.assertNotNull(wXIntergralRefundProvideServiceImpl.getClass().getName() + " 测试失败", result);
	}

	@Test
	public void MAL314AppIntergralAddOrderProvideServiceImplTEST() {
		SoapModel model = createSopa(appIntergralAddOrderProvideServiceImpl);
		AppIntergralAddOrderVO content = BeanUtils.randomClass(AppIntergralAddOrderVO.class);
		AppIntergralAddOrderReturnVO result = appIntergralAddOrderProvideServiceImpl.process(model, content);
		System.out.println("输出结果:" + jsonMapper.toJson(result));
		Assert.assertNotNull(appIntergralAddOrderProvideServiceImpl.getClass().getName() + " 测试失败", result);
	}

	@Test
	public void MAL315AppStageMallPayVerificationProvideServiceImplTEST() {
		SoapModel model = createSopa(appStageMallPayVerificationProvideServiceImpl);
		AppStageMallPayVerificationVO content = BeanUtils.randomClass(AppStageMallPayVerificationVO.class);
		AppStageMallPayVerificationReturnVO result = appStageMallPayVerificationProvideServiceImpl.process(model,
				content);
		System.out.println("输出结果:" + jsonMapper.toJson(result));
		Assert.assertNotNull(appStageMallPayVerificationProvideServiceImpl.getClass().getName() + " 测试失败", result);
	}

	@Test
	public void MAL317AppStageMallAddressQueryProvideServiceImplTEST() {
		SoapModel model = createSopa(appStageMallAddressQueryProvideServiceImpl);
		AppStageMallAddressQueryVO content = BeanUtils.randomClass(AppStageMallAddressQueryVO.class);
		AppStageMallAddressReturnVO result = appStageMallAddressQueryProvideServiceImpl.process(model, content);
		System.out.println("输出结果:" + jsonMapper.toJson(result));
		Assert.assertNotNull(appStageMallAddressQueryProvideServiceImpl.getClass().getName() + " 测试失败", result);
	}

	@Test
	public void MAL318AppStageMallAddressAddProvideServiceImplTEST() {
		SoapModel model = createSopa(appStageMallAddressAddProvideServiceImpl);
		AppStageMallAddressAddVO content = BeanUtils.randomClass(AppStageMallAddressAddVO.class);
		AppStageMallAddressAddReturnVO result = appStageMallAddressAddProvideServiceImpl.process(model, content);
		System.out.println("输出结果:" + jsonMapper.toJson(result));
		Assert.assertNotNull(appStageMallAddressAddProvideServiceImpl.getClass().getName() + " 测试失败", result);
	}

	@Test
	public void MAL324IntergralAddOrderProvideServiceImplTEST() {
		SoapModel model = createSopa(intergralAddOrderProvideServiceImpl);
		IntergralAddOrderVO content = BeanUtils.randomClass(IntergralAddOrderVO.class);
		IntergralAddOrderReturnVO result = intergralAddOrderProvideServiceImpl.process(model, content);
		System.out.println("输出结果:" + jsonMapper.toJson(result));
		Assert.assertNotNull(intergralAddOrderProvideServiceImpl.getClass().getName() + " 测试失败", result);
	}

	@Test
	public void MAL325IntergrallPayVerificationProvideServiceImplTEST() {
		SoapModel model = createSopa(intergrallPayVerificationProvideServiceImpl);
		IntergrallPayVerificationVO content = BeanUtils.randomClass(IntergrallPayVerificationVO.class);
		IntergrallPayVerificationReturnVO result = intergrallPayVerificationProvideServiceImpl.process(model, content);
		System.out.println("输出结果:" + jsonMapper.toJson(result));
		Assert.assertNotNull(intergrallPayVerificationProvideServiceImpl.getClass().getName() + " 测试失败", result);
	}

	@Test
	public void MAL401SMSOrderAddProvideServiceImplTEST() {
		SoapModel model = createSopa(sMSOrderAddProvideServiceImpl);
		SMSOrderAddVO content = BeanUtils.randomClass(SMSOrderAddVO.class);
		SMSOrderAddReturnVO result = sMSOrderAddProvideServiceImpl.process(model, content);
		System.out.println("输出结果:" + jsonMapper.toJson(result));
		Assert.assertNotNull(sMSOrderAddProvideServiceImpl.getClass().getName() + " 测试失败", result);
	}

	@Resource
	CCIntergralPresentsQueryProvideServiceImpl cCIntergralPresentsQueryProvideServiceImpl;
	@Resource
	CCIntergralPresentDetailProvideServiceImpl cCIntergralPresentDetailProvideServiceImpl;
	@Resource
	IVRIntergralPresentDetailProvideServiceImpl iVRIntergralPresentDetailProvideServiceImpl;
	@Resource
	CCAndIVRIntergralAddOrderProvideServiceImpl cCAndIVRIntergralAddOrderProvideServiceImpl;
	@Resource
	CCIntergralOrdersQueryProvideServiceImpl cCIntergralOrdersQueryProvideServiceImpl;
	@Resource
	CCIntergralOrderUpdateProvideServiceImpl cCIntergralOrderUpdateProvideServiceImpl;
	@Resource
	CCIntergralOrderCancelOrRefundProvideServiceImpl cCIntergralOrderCancelOrRefundProvideServiceImpl;
	@Resource
	CCIntergralOrderDetailProvideServiceImpl cCIntergralOrderDetailProvideServiceImpl;
	@Resource
	StageMallOrderUpdateProvideServiceImpl stageMallOrderUpdateProvideServiceImpl;
	@Resource
	StageMallOrderCancelorRefundProvideServiceImpl stageMallOrderCancelorRefundProvideServiceImpl;
	@Resource
	StageMallOrderDetailProvideServiceImpl stageMallOrderDetailProvideServiceImpl;
	@Resource
	StageMallOrderQueryByCCProvideServiceImpl stageMallOrderQueryByCCProvideServiceImpl;
	@Resource
	OrderHistoryAddressQueryProvideServiceImpl orderHistoryAddressQueryProvideServiceImpl;
	@Resource
	CCAddOrderByCgbProvideServiceImpl cCAddOrderByCgbProvideServiceImpl;
	@Resource
	StageMallGoodsDetailProvideServiceImpl stageMallGoodsDetailProvideServiceImpl;
	@Resource
	PrivilegeTypeQueryProvideServiceImpl privilegeTypeQueryProvideServiceImpl;
	@Resource
	CCVerificationCodeProvideServiceImpl cCVerificationCodeProvideServiceImpl;
	@Resource
	CCIntergralAnticipationProvideServiceImpl cCIntergralAnticipationProvideServiceImpl;
	@Resource
	IVRRankListProvideServiceImpl iVRRankListProvideServiceImpl;
	@Resource
	StageMallOrderUpdateStateProvideServiceImpl stageMallOrderUpdateStateProvideServiceImpl;
	@Resource
	MyIntergalPresentsProvideServiceImpl myIntergalPresentsProvideServiceImpl;
	@Resource
	MyLoveCGBGoodsQueryProvideServiceImpl myLoveCGBGoodsQueryProvideServiceImpl;
	@Resource
	StageMallFavoriteAddProvideServiceImpl stageMallFavoriteAddProvideServiceImpl;
	@Resource
	StageMallFavoriteQueryProvideServiceImpl stageMallFavoriteQueryProvideServiceImpl;
	@Resource
	StageMallFavoriteDelProvideServiceImpl stageMallFavoriteDelProvideServiceImpl;
	@Resource
	CustCarAddProvideServiceImpl custCarAddProvideServiceImpl;
	@Resource
	CustCarQueryProvideServiceImpl custCarQueryProvideServiceImpl;
	@Resource
	CustCarUpdateProvideServiceImpl custCarUpdateProvideServiceImpl;
	@Resource
	CustCarDelProvideServiceImpl custCarDelProvideServiceImpl;
	@Resource
	StageMallOrdersQueryByAPPProvideServiceImpl stageMallOrdersQueryByAPPProvideServiceImpl;
	@Resource
	StageMallOrdersDetailByAPPProvideServiceImpl stageMallOrdersDetailByAPPProvideServiceImpl;
	@Resource
	StageMallGoodsTypeQueryProvideServiceImpl stageMallGoodsTypeQueryProvideServiceImpl;
	@Resource
	StageMallGoodsQueryProvideServiceImpl stageMallGoodsQueryProvideServiceImpl;
	@Resource
	StageMallGoodsDetailByAPPProvideServiceImpl stageMallGoodsDetailByAPPProvideServiceImpl;
	@Resource
	StageMallUserCommentQueryProvideServiceImpl stageMallUserCommentQueryProvideServiceImpl;
	@Resource
	StageMallAdvertiseQueryProvideServiceImpl stageMallAdvertiseQueryProvideServiceImpl;
	@Resource
	PreferentialPriceQueryProvideServiceImpl preferentialPriceQueryProvideServiceImpl;
	@Resource
	CustInfoQueryProvideServiceImpl custInfoQueryProvideServiceImpl;
	@Resource
	AreaQueryProvideServiceImpl areaQueryProvideServiceImpl;

	@Resource
	NoticAddProvideServiceImpl noticAddProvideServiceImpl;
	@Resource
	NoticCancelProvideServiceImpl noticCancelProvideServiceImpl;
	@Resource
	AddressUpdateProvideServiceImpl addressUpdateProvideServiceImpl;
	@Resource
	AddressDelProvideServiceImpl addressDelProvideServiceImpl;
	@Resource
	SPGoodsQueryProvideServiceImpl sPGoodsQueryProvideServiceImpl;
	@Resource
	BrandTypeQueryProvideServiceImpl brandTypeQueryProvideServiceImpl;
	@Resource
	WXYXo2oGoodsQueryProvideServiceImpl wXYXo2oGoodsQueryProvideServiceImpl;
	@Resource
	WXYXVerificationCodeProvideServiceImpl wXYXVerificationCodeProvideServiceImpl;
	@Resource
	WXYX020FreeOrderAddProvideServiceImpl wXYX020FreeOrderAddProvideServiceImpl;
	@Resource
	WXOrderAddByIntergralProvideServiceImpl wXOrderAddByIntergralProvideServiceImpl;
	// @Resource
	// WXPayProvideServiceImpl wXPayProvideServiceImpl;
	@Resource
	WXIntergralRefundProvideServiceImpl wXIntergralRefundProvideServiceImpl;
	@Resource
	AppIntergralAddOrderProvideServiceImpl appIntergralAddOrderProvideServiceImpl;
	@Resource
	AppStageMallPayVerificationProvideServiceImpl appStageMallPayVerificationProvideServiceImpl;
	@Resource
	AppStageMallAddressQueryProvideServiceImpl appStageMallAddressQueryProvideServiceImpl;
	@Resource
	AppStageMallAddressAddProvideServiceImpl appStageMallAddressAddProvideServiceImpl;
	@Resource
	IntergralAddOrderProvideServiceImpl intergralAddOrderProvideServiceImpl;
	@Resource
	IntergrallPayVerificationProvideServiceImpl intergrallPayVerificationProvideServiceImpl;
	@Resource
	SMSOrderAddProvideServiceImpl sMSOrderAddProvideServiceImpl;

	@Resource
	ActivityQueryProvideServiceImpl activityQueryProvideServiceImpl;

}
