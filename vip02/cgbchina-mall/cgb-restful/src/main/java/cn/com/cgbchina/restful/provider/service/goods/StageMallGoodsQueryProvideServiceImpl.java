package cn.com.cgbchina.restful.provider.service.goods;

import javax.annotation.Resource;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.StringUtils;
import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.goods.StageMallGoodsQuery;
import cn.com.cgbchina.rest.provider.model.goods.StageMallGoodsQueryReturn;
import cn.com.cgbchina.rest.provider.service.goods.StageMallGoodsQueryService;
import cn.com.cgbchina.rest.provider.vo.goods.StageMallGoodsQueryReturnVO;
import cn.com.cgbchina.rest.provider.vo.goods.StageMallGoodsQueryVO;
import lombok.extern.slf4j.Slf4j;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;

/**
 * MAL312 商品搜索列表(分期商城) 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL312")
@Slf4j
public class StageMallGoodsQueryProvideServiceImpl implements  SoapProvideService <StageMallGoodsQueryVO,StageMallGoodsQueryReturnVO>{
	@Resource
	StageMallGoodsQueryService stageMallGoodsQueryService;

	@Override
	public StageMallGoodsQueryReturnVO process(SoapModel<StageMallGoodsQueryVO> model, StageMallGoodsQueryVO content) {
		StageMallGoodsQuery stageMallGoodsQuery = BeanUtils.copy(content, StageMallGoodsQuery.class);
		if (Contants.ORDER_SOURCE_ID_09.equals(stageMallGoodsQuery.getOrigin())) {
			try {
				if (!StringUtils.isEmpty(content.getQuery())) {
					String query = URLDecoder.decode(content.getQuery(), "UTF-8");
					stageMallGoodsQuery.setQuery(query);
				}
			} catch (UnsupportedEncodingException e) {
				log.info("APP请求中文转码失败============");
			}
		}
		StageMallGoodsQueryReturn stageMallGoodsQueryReturn = stageMallGoodsQueryService.query(stageMallGoodsQuery);
		StageMallGoodsQueryReturnVO stageMallGoodsQueryReturnVO = BeanUtils.copy(stageMallGoodsQueryReturn,
				StageMallGoodsQueryReturnVO.class);
		return stageMallGoodsQueryReturnVO;
	}

}
