package cn.com.cgbchina.restful.provider.service.activity;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.activity.Area;
import cn.com.cgbchina.rest.provider.model.activity.AreaQueryReturn;
import cn.com.cgbchina.rest.provider.service.activity.AreaQueryService;
import cn.com.cgbchina.rest.provider.vo.activity.AreaQueryReturnVO;
import cn.com.cgbchina.rest.provider.vo.activity.AreaVO;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL326 分区查询接口 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL326")
@Slf4j
public class AreaQueryProvideServiceImpl implements  SoapProvideService <AreaVO,AreaQueryReturnVO>{
	@Resource
	AreaQueryService areaQueryService;

	@Override
	public AreaQueryReturnVO process(SoapModel<AreaVO> model, AreaVO content) {
		Area area = BeanUtils.copy(content, Area.class);
		AreaQueryReturn areaQueryReturn = areaQueryService.query(area);
		AreaQueryReturnVO areaQueryReturnVO = BeanUtils.copy(areaQueryReturn,
				AreaQueryReturnVO.class);
		return areaQueryReturnVO;
	}

}
