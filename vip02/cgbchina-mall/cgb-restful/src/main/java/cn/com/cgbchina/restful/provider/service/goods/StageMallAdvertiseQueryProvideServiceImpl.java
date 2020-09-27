package cn.com.cgbchina.restful.provider.service.goods;

import cn.com.cgbchina.related.model.EspAdvertiseModel;
import cn.com.cgbchina.related.service.EspAdvertiseService;
import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.vo.goods.StageMallAdvertiseInfoVO;
import cn.com.cgbchina.rest.provider.vo.goods.StageMallAdvertiseQueryReturnVO;
import cn.com.cgbchina.rest.provider.vo.goods.StageMallAdvertiseVO;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

/**
 * MAL321 广告查询(分期商城) 从soap对象生成的vo转为 接口调用的bean
 * 
 * @author Lizy
 * 
 */
@Service
@TradeCode(value = "MAL321")
@Slf4j
public class StageMallAdvertiseQueryProvideServiceImpl implements  SoapProvideService <StageMallAdvertiseVO,StageMallAdvertiseQueryReturnVO>{

	@Resource
	EspAdvertiseService espAdvertiseService;

	/**
	 * 广告查询接口
	 * @param model
	 * @param content 查询参数
	 * @return 广告数据
	 *
	 * geshuo 20160721
	 */
	@Override
	public StageMallAdvertiseQueryReturnVO process(SoapModel<StageMallAdvertiseVO> model, StageMallAdvertiseVO content) {
		StageMallAdvertiseQueryReturnVO stageMallAdvertiseQueryReturnVO = new StageMallAdvertiseQueryReturnVO();

		String advertisePos = content.getAdvertisePos();//广告类型
		String mallType = content.getMallType();//业务类型代码
		if ("01".equals(mallType)) {
			mallType = "YG";//YG：广发
		} else if ("02".equals(mallType)) {
			mallType = "JF";//JF：积分
		}

		try {
			Map<String,Object> paramMap = Maps.newHashMap();
			paramMap.put("advertisePos",advertisePos.trim());//广告类型参数
			paramMap.put("ordertypeId",mallType);

			//根据参数查询有效广告
			Response<List<EspAdvertiseModel>> response = espAdvertiseService.findAvailableAds(paramMap);
			if(!response.isSuccess()){
				log.error("【StageMallAdvertiseQueryProvideServiceImpl】流水：espAdvertiseService.findAvailableAds查询失败 mallType {}, Exception{}", response.getError());
				stageMallAdvertiseQueryReturnVO.setReturnCode("000009");
				stageMallAdvertiseQueryReturnVO.setReturnDes("广告查询异常");
				return stageMallAdvertiseQueryReturnVO;
			}
			List<EspAdvertiseModel> adsModelList = response.getResult();
			List<StageMallAdvertiseInfoVO> advertiseInfoList = Lists.newArrayList();
			if(adsModelList != null && adsModelList.size() > 0){
				//解析数据
				for(EspAdvertiseModel advertiseModel:adsModelList){
					StageMallAdvertiseInfoVO advertiseInfo = new StageMallAdvertiseInfoVO();

					advertiseInfo.setId(String.valueOf(advertiseModel.getId()));//广告id
					advertiseInfo.setLinkType(getLinkType(advertiseModel.getLinkType()));//跳转类型
					advertiseInfo.setAdvertiseDesc(advertiseModel.getAdvertiseDesc());//文字描述
					advertiseInfo.setAdvertiseSeq(String.valueOf(advertiseModel.getAdvertiseSeq()));//显示顺序
					advertiseInfo.setPhoneHref(advertiseModel.getAdvertiseHref());//链接地址
					advertiseInfo.setKeyword(advertiseModel.getKeyword());//关键字
					advertiseInfo.setPictureUrl(advertiseModel.getAdvertiseImage());//手机商城广告图片链接

					advertiseInfoList.add(advertiseInfo);
				}
			}
			stageMallAdvertiseQueryReturnVO.setAds(advertiseInfoList);

			//设置返回报文代码
			stageMallAdvertiseQueryReturnVO.setReturnCode("000000");
			stageMallAdvertiseQueryReturnVO.setReturnDes("广告查询成功");
		} catch (Exception e) {
			log.error("【StageMallAdvertiseQueryProvideServiceImpl】流水：mallType {}, Exception{}", mallType, Throwables.getStackTraceAsString(e));
			stageMallAdvertiseQueryReturnVO.setReturnCode("000009");
			stageMallAdvertiseQueryReturnVO.setReturnDes("广告查询异常");
		}

		return stageMallAdvertiseQueryReturnVO;
	}

	/**
	 * 连接类型转换
	 * @param newLinkType 新连接类型
	 * @return 转换后的类型
	 *
	 * geshuo 20160824
	 */
	private String getLinkType(String newLinkType){
		String linkType = "";
		if(StringUtils.isNotEmpty(newLinkType)){
			//广发：0:页面   1:关键字
			//积分：00：链接 01：分区 02：类别（精确到小类）
			switch (Integer.parseInt(newLinkType)){
				case 1:
					linkType = "1";//关键字
					break;
				case 2:
					linkType = "0";// 页面
					break;
				case 3:
					linkType = "01";// 分区
					break;
				case 4:
					linkType = "02";// 类别
					break;
				case 5:
					linkType = "00";// 链接
					break;
			}
		}
		return linkType;
	}

}
