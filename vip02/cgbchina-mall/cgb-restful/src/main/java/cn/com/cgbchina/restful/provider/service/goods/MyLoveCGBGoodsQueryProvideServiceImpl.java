package cn.com.cgbchina.restful.provider.service.goods;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.goods.MyLoveCGBGoodsQuery;
import cn.com.cgbchina.rest.provider.model.goods.MyLoveCGBGoodsQueryReturn;
import cn.com.cgbchina.rest.provider.service.goods.MyLoveCGBGoodsQueryService;
import cn.com.cgbchina.rest.provider.vo.goods.MyLoveCGBGoodsQueryReturnVO;
import cn.com.cgbchina.rest.provider.vo.goods.MyLoveCGBGoodsQueryVO;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL119 猜我喜欢广发商品查询 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL119")
@Slf4j
public class MyLoveCGBGoodsQueryProvideServiceImpl implements  SoapProvideService <MyLoveCGBGoodsQueryVO,MyLoveCGBGoodsQueryReturnVO>{
	@Resource
	MyLoveCGBGoodsQueryService myLoveCGBGoodsQueryService;

	@Override
	public MyLoveCGBGoodsQueryReturnVO process(SoapModel<MyLoveCGBGoodsQueryVO> model, MyLoveCGBGoodsQueryVO content) {
		MyLoveCGBGoodsQuery myLoveCGBGoodsQuery = BeanUtils.copy(content, MyLoveCGBGoodsQuery.class);
		MyLoveCGBGoodsQueryReturn myLoveCGBGoodsQueryReturn = myLoveCGBGoodsQueryService.query(myLoveCGBGoodsQuery);
		MyLoveCGBGoodsQueryReturnVO myLoveCGBGoodsQueryReturnVO = BeanUtils.copy(myLoveCGBGoodsQueryReturn,
				MyLoveCGBGoodsQueryReturnVO.class);
		return myLoveCGBGoodsQueryReturnVO;
	}

}
