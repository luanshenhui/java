package cn.com.cgbchina.restful.provider.service.activity;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.activity.WXYXo2oGoodsQuery;
import cn.com.cgbchina.rest.provider.model.activity.WXYXo2oGoodsQueryReturn;
import cn.com.cgbchina.rest.provider.service.activity.WXYXo2oGoodsQueryService;
import cn.com.cgbchina.rest.provider.vo.activity.WXYXo2oGoodsQueryReturnVO;
import cn.com.cgbchina.rest.provider.vo.activity.WXYXo2oGoodsQueryVO;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL421 微信易信O2O0元秒杀商品详情查询 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL421")
@Slf4j
public class WXYXo2oGoodsQueryProvideServiceImpl implements  SoapProvideService <WXYXo2oGoodsQueryVO,WXYXo2oGoodsQueryReturnVO>{
	@Resource
	WXYXo2oGoodsQueryService wXYXo2oGoodsQueryService;

	@Override
	public WXYXo2oGoodsQueryReturnVO process(SoapModel<WXYXo2oGoodsQueryVO> model, WXYXo2oGoodsQueryVO content) {
		WXYXo2oGoodsQuery wXYXo2oGoodsQuery = BeanUtils.copy(content, WXYXo2oGoodsQuery.class);
		WXYXo2oGoodsQueryReturn wXYXo2oGoodsQueryReturn = wXYXo2oGoodsQueryService.query(wXYXo2oGoodsQuery);
		WXYXo2oGoodsQueryReturnVO wXYXo2oGoodsQueryReturnVO = BeanUtils.copy(wXYXo2oGoodsQueryReturn,
				WXYXo2oGoodsQueryReturnVO.class);
		return wXYXo2oGoodsQueryReturnVO;
	}

}
