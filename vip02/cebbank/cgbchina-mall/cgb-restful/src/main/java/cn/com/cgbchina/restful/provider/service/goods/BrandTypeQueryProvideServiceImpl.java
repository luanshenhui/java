package cn.com.cgbchina.restful.provider.service.goods;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.goods.BrandTypeQuery;
import cn.com.cgbchina.rest.provider.model.goods.BrandTypeQueryReturn;
import cn.com.cgbchina.rest.provider.service.goods.BrandTypeQueryService;
import cn.com.cgbchina.rest.provider.vo.goods.BrandTypeQueryReturnVO;
import cn.com.cgbchina.rest.provider.vo.goods.BrandTypeQueryVO;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL336 类别品牌查询 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL336")
@Slf4j
public class BrandTypeQueryProvideServiceImpl implements  SoapProvideService <BrandTypeQueryVO,BrandTypeQueryReturnVO>{
	@Resource
	BrandTypeQueryService brandTypeQueryService;

	@Override
	public BrandTypeQueryReturnVO process(SoapModel<BrandTypeQueryVO> model, BrandTypeQueryVO content) {
		BrandTypeQuery brandTypeQuery = BeanUtils.copy(content, BrandTypeQuery.class);
		BrandTypeQueryReturn brandTypeQueryReturn = brandTypeQueryService.query(brandTypeQuery);
		BrandTypeQueryReturnVO brandTypeQueryReturnVO = BeanUtils.copy(brandTypeQueryReturn,
				BrandTypeQueryReturnVO.class);
		return brandTypeQueryReturnVO;
	}

}
