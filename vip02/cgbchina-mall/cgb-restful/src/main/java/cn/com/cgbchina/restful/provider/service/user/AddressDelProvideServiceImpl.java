package cn.com.cgbchina.restful.provider.service.user;

import javax.annotation.Resource;

import cn.com.cgbchina.rest.common.utils.StringUtil;
import cn.com.cgbchina.user.model.MemberAddressModel;
import cn.com.cgbchina.user.service.MemberAddressService;
import com.alibaba.dubbo.common.utils.StringUtils;
import com.google.common.base.Throwables;
import com.spirit.common.model.Response;
import org.springframework.stereotype.Service;

import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.model.user.AddressDel;
import cn.com.cgbchina.rest.provider.model.user.AddressDelReturn;
import cn.com.cgbchina.rest.provider.vo.user.AddressDelReturnVO;
import cn.com.cgbchina.rest.provider.vo.user.AddressDelVO;
import lombok.extern.slf4j.Slf4j;

/**
 * MAL334 删除地址接口 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL334")
@Slf4j
public class AddressDelProvideServiceImpl implements  SoapProvideService <AddressDelVO,AddressDelReturnVO>{
	@Resource
	MemberAddressService memberAddressService;

	/**
	 * 删除地址接口
	 * @param model
	 * @param content 删除参数
	 * @return 删除结果
	 *
	 * geshuo 20160727
	 */
	@Override
	public AddressDelReturnVO process(SoapModel<AddressDelVO> model, AddressDelVO content) {
		AddressDelReturnVO addressDelReturnVO = new AddressDelReturnVO();//返回结果
		String addressId = StringUtil.dealNull(content.getAddressId());// 地址id
		String reqType = StringUtil.dealNull(content.getReqType());// 请求操作类型 01：删除地址 02：设置默认地址

		try{
			if(StringUtils.isEmpty(addressId)){
				addressDelReturnVO.setReturnCode("000008");
				addressDelReturnVO.setReturnDes("报文参数错误:地址编号必须填写");
				return addressDelReturnVO;
			}

			Response<MemberAddressModel> memberAddressModelResponse= memberAddressService.findById(Long.parseLong(addressId));
			if (!memberAddressModelResponse.isSuccess()||memberAddressModelResponse.getResult() == null) {
				addressDelReturnVO.setReturnCode("000010");
				addressDelReturnVO.setReturnDes("找不到该地址");
				return addressDelReturnVO;
			}
			MemberAddressModel addressModel = memberAddressModelResponse.getResult();
			if ("01".equals(reqType)) {// 删除地址
				Response<Boolean> booleanResponse = memberAddressService.delete(Long.parseLong(addressId));
				if (!booleanResponse.isSuccess()||!booleanResponse.getResult()) {
					addressDelReturnVO.setReturnCode("000010");
					addressDelReturnVO.setReturnDes("找不到该地址");
					return addressDelReturnVO;
				}
			} else if("02".equals(reqType)){// 设置默认地址
				String cusId = addressModel.getCustId();//客户号
				Response<Boolean> updateResponse = memberAddressService.setDefault(Long.parseLong(addressId), cusId);
				if(!updateResponse.isSuccess()){
					addressDelReturnVO.setReturnCode("000027");
					addressDelReturnVO.setReturnDes("设置默认地址失败");
					return addressDelReturnVO;
				}
			} else{
				//查询类型参数错误
				addressDelReturnVO.setReturnCode("000008");
				addressDelReturnVO.setReturnDes("请求类型错误");
				return addressDelReturnVO;
			}

			addressDelReturnVO.setReturnCode("000000");
			if ("01".equals(reqType)) {// 删除地址
				addressDelReturnVO.setReturnDes("删除地址成功");
			} else if("02".equals(reqType)){// 设置默认地址
				addressDelReturnVO.setReturnDes("设置默认地址成功");
			}
		}catch (Exception e){
			log.error("AddressDelServiceImpl.del.error Exception{} ", Throwables.getStackTraceAsString(e));
			if ("01".equals(reqType)) {// 删除地址
				addressDelReturnVO.setReturnCode("000027");
				addressDelReturnVO.setReturnDes("删除地址失败");
			} else if("02".equals(reqType)){// 设置默认地址
				addressDelReturnVO.setReturnCode("000027");
				addressDelReturnVO.setReturnDes("设置默认地址失败");
			}
		}

		return addressDelReturnVO;
	}

}
