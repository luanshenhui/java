package cn.com.cgbchina.restful.provider.service.goods;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.goods.MyIntergalPresentsQuery;
import cn.com.cgbchina.rest.provider.model.goods.MyIntergalPresentsReturn;
import cn.com.cgbchina.rest.provider.service.goods.MyIntergalPresentsService;
import cn.com.cgbchina.rest.provider.vo.goods.MyIntergalPresentsReturnVO;
import cn.com.cgbchina.rest.provider.vo.goods.MyIntergalPresentsQueryVO;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL118 适合我的积分礼品查询 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL118")
@Slf4j
public class MyIntergalPresentsProvideServiceImpl implements  SoapProvideService <MyIntergalPresentsQueryVO,MyIntergalPresentsReturnVO>{
	@Resource
	MyIntergalPresentsService myIntergalPresentsService;

	@Override
	public MyIntergalPresentsReturnVO process(SoapModel<MyIntergalPresentsQueryVO> model, MyIntergalPresentsQueryVO content) {
		MyIntergalPresentsQuery myIntergalPresentsQuery = BeanUtils.copy(content, MyIntergalPresentsQuery.class);
		MyIntergalPresentsReturn myIntergalPresentsReturn = myIntergalPresentsService.query(myIntergalPresentsQuery);
		MyIntergalPresentsReturnVO myIntergalPresentsReturnVO = BeanUtils.copy(myIntergalPresentsReturn,
				MyIntergalPresentsReturnVO.class);
		return myIntergalPresentsReturnVO;
	}

}
