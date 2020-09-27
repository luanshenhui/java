package cn.com.cgbchina.restful.provider.service.activity;

import cn.com.cgbchina.item.model.EspAreaInfModel;
import cn.com.cgbchina.item.service.EspAreaInfService;
import cn.com.cgbchina.rest.common.annotation.TradeCode;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.utils.StringUtil;
import cn.com.cgbchina.rest.provider.service.SoapProvideService;
import cn.com.cgbchina.rest.provider.vo.activity.AreaInfoVO;
import cn.com.cgbchina.rest.provider.vo.activity.AreaQueryReturnVO;
import cn.com.cgbchina.rest.provider.vo.activity.AreaVO;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

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
	EspAreaInfService espAreaInfService;

	/**
	 * 分区查询接口
	 * @param model
	 * @param content　查询参数
	 * @return 查询结果
	 *
	 * geshu0 20160728
	 */
	@Override
	public AreaQueryReturnVO process(SoapModel<AreaVO> model, AreaVO content) {
		AreaQueryReturnVO areaQueryReturnVO = new AreaQueryReturnVO();

		String mallType = content.getMallType(); //商城类型
		try {
			Map<String,Object> paramMap = Maps.newHashMap();
			if ("01".equals(mallType)) {
				paramMap.put("ordertypeId", "YG");//YG：广发
			} else if ("02".equals(mallType)) {
				paramMap.put("ordertypeId", "JF");//JF：积分
				paramMap.put("publishStatus","00");//00：已发布
				paramMap.put("curStatus","0102");//0102：已启用
			}
			Response<List<EspAreaInfModel>> areaResponse = espAreaInfService.findAreaInfoByParams(paramMap);
			if(!areaResponse.isSuccess()){
				log.error("AreaQueryProvideServiceImpl.process espAreaInfService.findAreaInfoByParams.error mallType:{}", mallType);
				areaQueryReturnVO.setReturnCode("000009");
				areaQueryReturnVO.setReturnDes("分区查询异常");
				return areaQueryReturnVO;
			}
			List<EspAreaInfModel> areaList = areaResponse.getResult();//获取查询结果
			List<AreaInfoVO> areaInfos = Lists.newArrayList();
			if (areaList != null && areaList.size() > 0){
				//取得返回的每行具体信息
				for (EspAreaInfModel areaModel:areaList) {
					AreaInfoVO areaItem = new AreaInfoVO();
					areaItem.setAreaId(StringUtil.dealNull(areaModel.getAreaId()));//分区ID
					areaItem.setAreaNm(StringUtil.dealNull(areaModel.getAreaName()));//分区名字
					areaItem.setOrderTypeId(StringUtil.dealNull(areaModel.getOrdertypeId()));//业务类型代码
					areaItem.setAreaType(StringUtil.dealNull(areaModel.getAreaType()));//分区类型
					areaItem.setJfType(StringUtil.dealNull(areaModel.getIntegralType()));//积分类型
					areaItem.setAreaSeq(StringUtil.dealNull(String.valueOf(areaModel.getAreaSeq())));//分区顺序
					areaItem.setGoodsType(StringUtil.dealNull(areaModel.getGoodsType()));//商品类别
					areaItem.setFormatId(StringUtil.dealNull(areaModel.getFormatId()));//分区卡板
					areaInfos.add(areaItem);
				}
			}
			areaQueryReturnVO.setAreaInfos(areaInfos);
			areaQueryReturnVO.setReturnCode("000000");
			areaQueryReturnVO.setReturnDes("分区查询成功");
		} catch (Exception e) {
			log.error("AreaQueryProvideServiceImpl.process.error Exception:{}", Throwables.getStackTraceAsString(e));
			areaQueryReturnVO.setReturnCode("000009");
			areaQueryReturnVO.setReturnDes("分区查询异常");
		}

		return areaQueryReturnVO;
	}

}
