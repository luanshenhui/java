package cn.com.cgbchina.restful.provider.service.goods;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.goods.IVRIntergralPresentDetailQuery;
import cn.com.cgbchina.rest.provider.model.goods.IVRIntergralPresentReturn;
import cn.com.cgbchina.rest.provider.service.goods.IVRIntergralPresentDetailService;
import cn.com.cgbchina.rest.provider.vo.goods.IVRIntergralPresentReturnVO;
import cn.com.cgbchina.rest.provider.vo.goods.IVRIntergralPresentDetailQueryVO;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL103 IVR积分商城单个礼品查询 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL103")
@Slf4j
public class IVRIntergralPresentDetailProvideServiceImpl implements  SoapProvideService <IVRIntergralPresentDetailQueryVO,IVRIntergralPresentReturnVO>{
	@Resource
	IVRIntergralPresentDetailService iVRIntergralPresentDetailService;

	@Override
	public IVRIntergralPresentReturnVO process(SoapModel<IVRIntergralPresentDetailQueryVO> model, IVRIntergralPresentDetailQueryVO content) {
		IVRIntergralPresentDetailQuery iVRIntergralPresentDetailQuery = BeanUtils.copy(content, IVRIntergralPresentDetailQuery.class);
		IVRIntergralPresentReturn iVRIntergralPresentReturn = iVRIntergralPresentDetailService.detail(iVRIntergralPresentDetailQuery);
		IVRIntergralPresentReturnVO iVRIntergralPresentReturnVO = BeanUtils.copy(iVRIntergralPresentReturn,
				IVRIntergralPresentReturnVO.class);
		return iVRIntergralPresentReturnVO;
	}

}
