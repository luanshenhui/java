package cn.com.cgbchina.user.manager;

import cn.com.cgbchina.common.utils.DateHelper;
import cn.com.cgbchina.rest.common.utils.StringUtil;
import cn.com.cgbchina.user.dao.EspCustNewDao;
import cn.com.cgbchina.user.model.EspCustNewModel;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 *
 */
@Component
@Transactional
public class EspCustNewManager {
	@Resource
	private EspCustNewDao espCustNewDao;

	/**
	 * 获取生日价剩余兑换次数
	 * @param custId 客户号
	 * @return 剩余次数
	 *
	 * geshuo 20160721
	 */
	public Integer findAvailableCount(String custId,Integer birthdayLimit) {
		int availCount;
		int birthLimitCount = birthdayLimit;//配置文件中配置的生日使用次数
		Map<String, Object> paramMap = Maps.newHashMap();
		paramMap.put("custId", custId);
		List<EspCustNewModel> modelList = espCustNewDao.findCustNewByParams(paramMap);
		String curYear = DateHelper.date2string(new Date(), DateHelper.YYYY);
		if (modelList != null && modelList.size() > 0) {//客户信息存在
			EspCustNewModel model = modelList.get(0);
			String year = model.getBirthUsedYear();//StringUtil.dealNull(map.get("BIRTH_USED_YEAR"));
			String usedCountStr = "";
			if (model.getBirthUsedCount() != null) {
				usedCountStr = String.valueOf(model.getBirthUsedCount());//StringUtil.dealNull(map.get("BIRTH_USED_COUNT"));
			}
			int birthUsedCount = Integer.parseInt("".equals(usedCountStr) ? "0" : usedCountStr);
			if (!curYear.equals(year)) {//兑换年份不是当年的，则更新兑换年份和初始化生日兑换数量为0
				Map<String, Object> updateMap = Maps.newHashMap();
				updateMap.put("custId", custId);
				updateMap.put("birthUsedYear", curYear);
				updateMap.put("birthUsedCount", 0);
				int row = espCustNewDao.updateCustNewByCustId(updateMap);
				if (row > 0) {
					birthUsedCount = 0;
				}
			}
			availCount = birthLimitCount - birthUsedCount;
		} else {//客户信息不存在，插入新纪录
			EspCustNewModel insertModel = new EspCustNewModel();
			insertModel.setCustId(custId);
			insertModel.setBirthUsedYear(curYear);//年份
			insertModel.setBirthUsedCount(0);//已使用次数
			insertModel.setLastLoginTime(new Date());

			espCustNewDao.insert(insertModel);
			availCount = birthLimitCount;

		}
		return availCount;
	}

	/**
	 * 根据参数更新生日使用次数信息
	 * @param paramMap 更新参数
	 * @return 更新结果
	 */
	public Integer updateCustNewByParams(Map<String,Object> paramMap){
		return espCustNewDao.updateCustNewByParams(paramMap);
	}

	/**
	 * 查询生日次数并更新
	 * @param certNbr 证件号码
	 * @param custId 客户号
	 * @return 查询结果
	 *
	 * geshuo 20160824
	 */
	public Map<String,Object> getBirthUsedCount(String certNbr,String custId){
		List<EspCustNewModel> custNewModelList ;
		List<String> custIdList = Lists.newArrayList();
		Map<String,Object> reMap = Maps.newHashMap();
		String custIdKey;

		Map<String,Object> queryParamMap = Maps.newHashMap();

		if(StringUtils.isEmpty(custId)){//没有开通个人网银
			queryParamMap.put("custId",certNbr);
			custNewModelList = espCustNewDao.findCustNewByParams(queryParamMap);
			custIdKey = certNbr;
		}else{//已经开通个人网银
			queryParamMap.put("custId",custId);
			queryParamMap.put("certNbr",certNbr);
			custNewModelList = espCustNewDao.findCustNewByParams(queryParamMap);
			custIdKey = custId ;
		}
		int usedCount = 0;
		String curYear = DateHelper.date2string(new Date(), DateHelper.YYYY);
		if(custNewModelList!=null &&custNewModelList.size()>0){//客户信息存在
			for(EspCustNewModel model : custNewModelList){
				String year = StringUtil.dealNull(model.getBirthUsedYear());
				String usrdCountStr = String.valueOf(model.getBirthUsedCount());
				int birthUsedCount =  Integer.parseInt("".equals(usrdCountStr)?"0":usrdCountStr);
				if(!curYear.equals(year)){//兑换年份不是当年的，则更新兑换年份和初始化生日兑换数量为0
					Map<String,Object> updateMap = Maps.newHashMap();
					updateMap.put("custId",StringUtil.dealNull(model.getCustId()));
					updateMap.put("birthUsedYear", curYear);
					updateMap.put("birthUsedCount",0);

					int row = espCustNewDao.updateCustNewByParams(updateMap);
					if(row>0){
						birthUsedCount = 0 ;
					}
				}
				usedCount = Math.max(birthUsedCount,usedCount);//若存在多条记录，取"兑换次数"的最大值
				custIdList.add(StringUtil.dealNull(model.getCustId()));
			}
		}else{//客户信息不存在，插入新纪录
			EspCustNewModel insertModel = new EspCustNewModel();
			insertModel.setCustId(custIdKey);
			insertModel.setBirthUsedYear(curYear);//年份
			insertModel.setBirthUsedCount(0);//已使用次数
			insertModel.setLastLoginTime(new Date());

			espCustNewDao.insert(insertModel);
			custIdList.add(custIdKey);
		}
		reMap.put("usedCount", usedCount);//已兑换次数
		reMap.put("custIds",custIdList);//更新的客户信息的custId列表
		return reMap;
	}

	public Integer insert(EspCustNewModel espCustNewModel){
		return espCustNewDao.insert(espCustNewModel);
	}

	public Integer update(EspCustNewModel espCustNewModel){
		return espCustNewDao.update(espCustNewModel);
	}

	public Integer updateBirthUsedCount(String custId){
		return espCustNewDao.updateBirthUsedCount(custId);
	}
}
