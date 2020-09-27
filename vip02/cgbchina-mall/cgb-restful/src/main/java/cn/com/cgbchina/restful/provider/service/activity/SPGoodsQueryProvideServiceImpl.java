package cn.com.cgbchina.restful.provider.service.activity;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.activity.SPGoodsQuery;
import cn.com.cgbchina.rest.provider.model.activity.SPGoodsReturn;
import cn.com.cgbchina.rest.provider.service.activity.SPGoodsQueryService;
import cn.com.cgbchina.rest.provider.vo.activity.SPGoodsReturnVO;
import cn.com.cgbchina.rest.provider.vo.activity.SPGoodsQueryVO;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL335 特殊商品列表查询 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL335")
@Slf4j
public class SPGoodsQueryProvideServiceImpl implements  SoapProvideService <SPGoodsQueryVO,SPGoodsReturnVO>{
	@Resource
	SPGoodsQueryService sPGoodsQueryService;

	@Override
	public SPGoodsReturnVO process(SoapModel<SPGoodsQueryVO> model, SPGoodsQueryVO content) {
		SPGoodsQuery sPGoodsQuery = BeanUtils.copy(content, SPGoodsQuery.class);
		SPGoodsReturn sPGoodsReturn = sPGoodsQueryService.query(sPGoodsQuery);
		SPGoodsReturnVO sPGoodsReturnVO = BeanUtils.copy(sPGoodsReturn,
				SPGoodsReturnVO.class);
		return sPGoodsReturnVO;
	}

}
