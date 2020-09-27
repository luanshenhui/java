package cn.com.cgbchina.user.service;

import cn.com.cgbchina.user.dao.ACardCustToelectronbankDao;
import cn.com.cgbchina.user.dao.ACustToelectronbankDao;
import cn.com.cgbchina.user.model.ACardCustToelectronbankModel;
import cn.com.cgbchina.user.model.ACustToelectronbankModel;
import com.google.common.base.Function;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.Annotation.Param;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.validation.constraints.NotNull;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * Created by 11150721040343 on 16-4-8.
 */
@Service("aCustToelectronbankServiceImpl")
@Slf4j
public class ACustToelectronbankServiceImpl implements ACustToelectronbankService {

	@Resource
	private ACustToelectronbankDao aCustToelectronbankDao;
	@Resource
	private ACardCustToelectronbankDao aCardCustToelectronbankDao;

	@Override
	public String getUserBirth(@Param("certNo") String certNo, List<String> cardNos) {
		if (Strings.isNullOrEmpty(certNo)){
			certNo = aCardCustToelectronbankDao.findCertNbrByCardNbrs(cardNos);
		}
		List<ACustToelectronbankModel> result = aCustToelectronbankDao.selectBirthDay(certNo);
		if (result!=null && result.size()!=0){
			Date birth = result.get(0).getBirthDay();
			if (birth == null){
				return null;
			}
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			String birthDay = sdf.format(birth);
			return birthDay;
		}else {
			return null;
		}
	}

	/**
	 * 客户信息查询,外部接口调用
	 * @param paramMap 查询参数
	 * @return 查询结果
	 *
	 * geshuo 20160721
	 */
	public Response<List<ACustToelectronbankModel>> findCustInfoByParams(Map<String,Object> paramMap){
		Response<List<ACustToelectronbankModel>> response = new Response<List<ACustToelectronbankModel>>();
		try{
			List<ACustToelectronbankModel> dataList = aCustToelectronbankDao.findCustInfoByParams(paramMap);
			response.setResult(dataList);
		}catch (Exception e){
			log.error("ACustToelectronbankServiceImpl.findCustInfoByParams.error{}", Throwables.getStackTraceAsString(e));
			response.setSuccess(false);
			response.setError("ACustToelectronbankServiceImpl.findCustInfoByParams.error");
		}
		return response;
	}

	@Override
	public Response<List<ACustToelectronbankModel>> findUserBirthInfo(String certNbr) {
		Response<List<ACustToelectronbankModel>> response = Response.newResponse();
		try{
		List<ACustToelectronbankModel> list = aCustToelectronbankDao.selectBirthDay(certNbr);
		response.setResult(list);
		}catch (Exception e){
			log.error("ACustToelectronbankServiceImpl.findUserBirthInfo.error{}", Throwables.getStackTraceAsString(e));
		}
		return response;
	}

	/**
	 * Description : 根据卡号集合 查询商城卡客户信息
	 * @param cards 卡号
	 * @return 返回 Key 为卡号，value 为 客户信息 的集合
	 */
	@Override
	public Response<Map<String, ACustToelectronbankModel>> findCustsByCards(List<String> cards) {
		Response<Map<String, ACustToelectronbankModel>> response = Response.newResponse();
		List<ACustToelectronbankModel> custModels = null;
		try {
			List<ACardCustToelectronbankModel> certNbrModels = aCardCustToelectronbankDao.findCertNbrsByCards(cards);
			if (null == certNbrModels || certNbrModels.isEmpty()) {
				response.setError("find.certNbrs.isEmpty");
				return response;
			}
			List<String> certNbrs = Lists.transform(certNbrModels,
					new Function<ACardCustToelectronbankModel, String>() {
						@NotNull
						@Override
						public String apply(@NotNull ACardCustToelectronbankModel input) {
							return input.getCertNbr();
						}
					});
			if(!certNbrs.isEmpty()) {
				// 去重
				List<String> param = Lists.newArrayList(new HashSet<String>(certNbrs));
				custModels = aCustToelectronbankDao.findCustsByCerts(param);
			}
			if (null == custModels || custModels.isEmpty()) {
				response.setError("find.custModels.isEmpty");
				return response;
			}
			// 根据证件号 查用户信息
			Map<String, ACustToelectronbankModel> custMap = Maps.uniqueIndex(custModels,
					new Function<ACustToelectronbankModel, String>() {
						@NotNull
						@Override
						public String apply(@NotNull ACustToelectronbankModel input) {
							return input.getCertNbr();
						}
					});

			// 根据卡号 查证件号
			Map<String, ACardCustToelectronbankModel> certMap = Maps.uniqueIndex(certNbrModels,
					new Function<ACardCustToelectronbankModel, String>() {
						@NotNull
						@Override
						public String apply(@NotNull ACardCustToelectronbankModel input) {
							return input.getCardNbr();
						}
					});

			//返回数据
			Map<String, ACustToelectronbankModel> resultMap = Maps.newHashMapWithExpectedSize(certMap.keySet().size());
			for (String card : certMap.keySet()) {
				ACardCustToelectronbankModel model = certMap.get(card);
				if(null == model) {
					continue;
				}
				ACustToelectronbankModel aCustToelectronbankModel = custMap.get(model.getCertNbr());
				if(null == aCustToelectronbankModel) {
					continue;
				}
				resultMap.put(card, aCustToelectronbankModel);
			}
			response.setResult(resultMap);
		} catch (Exception e) {
			log.error("ACardCustToelectronbankServiceImpl.findCustsByCards.error{}",
					Throwables.getStackTraceAsString(e));
			response.setError("ACardCustToelectronbankServiceImpl.findCustsByCards.error");
		}
		return response;
	}
}
