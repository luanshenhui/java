package cn.com.cgbchina.restful.provider.service.goods;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.goods.IVRRankListQuery;
import cn.com.cgbchina.rest.provider.model.goods.IVRRankListReturn;
import cn.com.cgbchina.rest.provider.service.goods.IVRRankListService;
import cn.com.cgbchina.rest.provider.vo.goods.IVRRankListReturnVO;
import cn.com.cgbchina.rest.provider.vo.goods.IVRRankListQueryVO;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL202 IVR排行列表查询 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL202")
@Slf4j
public class IVRRankListProvideServiceImpl implements  SoapProvideService <IVRRankListQueryVO,IVRRankListReturnVO>{
	@Resource
	IVRRankListService iVRRankListService;

	@Override
	public IVRRankListReturnVO process(SoapModel<IVRRankListQueryVO> model, IVRRankListQueryVO content) {
		IVRRankListQuery iVRRankListQuery = BeanUtils.copy(content, IVRRankListQuery.class);
		IVRRankListReturn iVRRankListReturn = iVRRankListService.getRankList(iVRRankListQuery);
		IVRRankListReturnVO iVRRankListReturnVO = BeanUtils.copy(iVRRankListReturn,
				IVRRankListReturnVO.class);
		return iVRRankListReturnVO;
	}

}
