package cn.com.cgbchina.restful.provider.service.user;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.vo.user.AppStageMallAddressInfoVO;
import cn.com.cgbchina.rest.provider.vo.user.AppStageMallAddressQueryVO;
import cn.com.cgbchina.rest.provider.vo.user.AppStageMallAddressReturnVO;
import cn.com.cgbchina.user.model.MemberAddressModel;
import cn.com.cgbchina.user.service.MemberAddressService;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * MAL317 地址查询接口(分期商城) 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL317")
@Slf4j
public class AppStageMallAddressQueryProvideServiceImpl implements  SoapProvideService <AppStageMallAddressQueryVO,AppStageMallAddressReturnVO>{
	@Resource
	MemberAddressService memberAddressService;

	/**
	 * 地址条件查询接口
	 * @param model
	 * @param content 查询参数
	 * @return 查询结果
	 *
	 * geshuo 20160727
	 */
	@Override
	public AppStageMallAddressReturnVO process(SoapModel<AppStageMallAddressQueryVO> model, AppStageMallAddressQueryVO content) {
		AppStageMallAddressReturnVO result = new AppStageMallAddressReturnVO();
		Map<String,Object> paramMap = Maps.newHashMap();
		String custId = content.getCustId();//客户编号
		String origin =  content.getOrigin();//发起方
		String csgIdCard = content.getIdCard();//证件号码（广发微信商城需求增加）

		try{
			if(Contants.CHANNEL_SN_WX.equals(origin)||Contants.CHANNEL_SN_WS.equals(origin)||
					Contants.CHANNEL_SN_YX.equals(origin)||Contants.CHANNEL_SN_YS.equals(origin)){
				//微信渠道
				if(StringUtils.isEmpty(custId) && StringUtils.isEmpty(csgIdCard)){
					result.setReturnCode("000008");
					result.setReturnCode("报文参数错误:客户号和证件号至少填一个");
					return result;
				}

				if(StringUtils.isNotEmpty(custId)){
					paramMap.put("custId",custId);//用户id
				}
				if(StringUtils.isNotEmpty(csgIdCard)){
					paramMap.put("csgIdCard",csgIdCard);
				}

			} else {//手机/APP渠道
				if(StringUtils.isEmpty(custId)){
					result.setReturnCode("000008");
					result.setReturnCode("报文参数错误:客户号不能为空");
					return result;
				}
				paramMap.put("custId",custId);
			}

			Response<List<MemberAddressModel>> response = memberAddressService.findByParams(paramMap);
			if(!response.isSuccess()){
				result.setReturnCode("000009");
				result.setReturnCode("地址查询异常");
				return result;
			}
			List<MemberAddressModel> addressModelList = response.getResult();

			List<AppStageMallAddressInfoVO> addressResultList = Lists.newArrayList();
	 
			if(addressModelList!= null && addressModelList.size()>0){
				int i=1;
				for(MemberAddressModel addressModel:addressModelList){
					AppStageMallAddressInfoVO addressInfo = new AppStageMallAddressInfoVO();
					addressInfo.setAddressId(String.valueOf(addressModel.getId()));
					addressInfo.setCsgProvinceCode(addressModel.getProvinceId());
					addressInfo.setCsgProvince(addressModel.getProvinceName());
					addressInfo.setCsgCityCode(addressModel.getCityId());
					addressInfo.setCsgCity(addressModel.getCityName());
					addressInfo.setCsgBoroughCode(addressModel.getAreaId());//区域id
					addressInfo.setCsgBorough(addressModel.getAreaName());//区域名称
					addressInfo.setCsgAddress(addressModel.getAddress());//详细地址
					if(StringUtils.isNotEmpty(addressModel.getPostcode())){
						addressInfo.setCsgPostcode(addressModel.getPostcode());
					}
					addressInfo.setCsgName(addressModel.getConsignee());//收件人
					addressInfo.setCsgMobile(addressModel.getMobile());
					if(StringUtils.isNotEmpty(addressModel.getTelephone())){
						addressInfo.setCsgPhone(addressModel.getTelephone());
					}
					if(StringUtils.isNotEmpty(addressModel.getCsgEmail())){
						addressInfo.setCsgEmail(addressModel.getCsgEmail());
					}
					if(null != addressModel.getCsgSeq()){
						addressInfo.setCsgSeq(String.valueOf(addressModel.getCsgSeq()));
					}
					addressInfo.setIsDefault("0".equals(addressModel.getIsDefault()) ? "1" : "0");
					Date createDate = addressModel.getCreateTime();
					addressInfo.setCreateDate(DateHelper.date2string(createDate, DateHelper.YYYYMMDD));//创建日期
					addressInfo.setCreateTime(DateHelper.date2string(createDate, "HHmmss"));//创建时间

					Date modifyDate = addressModel.getModifyTime();
					addressInfo.setModifyDate(DateHelper.date2string(modifyDate,DateHelper.YYYYMMDD));//创建日期
					addressInfo.setModifyTime(DateHelper.date2string(modifyDate, "HHmmss"));//创建时间
					i++;
					addressResultList.add(addressInfo);
				}
			}

			result.setAddresses(addressResultList);//设置返回结果
			result.setReturnCode("000000");
			result.setReturnDes("SUCCESS");

		} catch(Exception e){
			log.error("AppStageMallAddressQueryProvideServiceImpl.process.error Exception{} ", Throwables.getStackTraceAsString(e));
			result.setReturnCode("000009");
			result.setReturnCode("地址查询异常");
			return result;
		}
		return result;
	}

}
