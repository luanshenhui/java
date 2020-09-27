package cn.com.cgbchina.restful.provider.service.user;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.user.AddressUpdate;
import cn.com.cgbchina.rest.provider.model.user.AddressUpdateReturn;
import cn.com.cgbchina.rest.provider.service.user.AddressUpdateService;
import cn.com.cgbchina.rest.provider.vo.user.AddressUpdateReturnVO;
import cn.com.cgbchina.rest.provider.vo.user.AddressUpdateVO;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL333 修改地址接口 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL333")
@Slf4j
public class AddressUpdateProvideServiceImpl implements  SoapProvideService <AddressUpdateVO,AddressUpdateReturnVO>{
	@Resource
	AddressUpdateService addressUpdateService;

	@Override
	public AddressUpdateReturnVO process(SoapModel<AddressUpdateVO> model, AddressUpdateVO content) {
		AddressUpdate addressUpdate = BeanUtils.copy(content, AddressUpdate.class);
		AddressUpdateReturn addressUpdateReturn = addressUpdateService.update(addressUpdate);
		AddressUpdateReturnVO addressUpdateReturnVO = BeanUtils.copy(addressUpdateReturn,
				AddressUpdateReturnVO.class);
		return addressUpdateReturnVO;
	}

}
