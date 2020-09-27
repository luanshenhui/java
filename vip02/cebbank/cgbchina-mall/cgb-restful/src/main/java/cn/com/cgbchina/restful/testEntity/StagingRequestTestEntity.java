package cn.com.cgbchina.restful.testEntity;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.visit.model.payment.FinancialInfo;
import cn.com.cgbchina.rest.visit.model.payment.StagingRequest;
import cn.com.cgbchina.rest.visit.model.payment.WorkOrderQuery;

import com.spirit.util.JsonMapper;

public class StagingRequestTestEntity {
	JsonMapper jsonMapper = JsonMapper.nonEmptyMapper();
	BigDecimal price = new BigDecimal(250);

	public String StagingRequestJson() {
		StagingRequest info = new StagingRequest();

		info.setSrcCaseId(BeanUtils.randomString(5));
		info.setInterfaceType("0");
		info.setCaseType("OPS 0500");
		info.setSubCaseType(BeanUtils.randomString(5));
		info.setProject(BeanUtils.randomString(5));
		info.setRequestType("0");
		info.setMichelleId(BeanUtils.randomString(5));
		info.setBookDesc(BeanUtils.randomString(5));

		info.setSendCode("M");
		info.setRegulator("1");
		info.setSmsnotice("1");
		info.setSmsPhone("18675186626");

		info.setSuborderid(BeanUtils.randomString(5));
		info.setCardnbr(BeanUtils.randomNum(15));
		info.setIdNbr(BeanUtils.randomNum(18));
		info.setUrgentLvl("0200");
		info.setProductCode(BeanUtils.randomString(5));
		info.setProductName(BeanUtils.randomString(5));
		info.setPrice(price);

		info.setAmount("1");
		info.setSumAmt(price);
		info.setFirstPayment(price);
		info.setBills("1");
		info.setPerPeriodAmt(price);
		info.setSupplierCode(BeanUtils.randomString(10));

		info.setFixedFeeHTFlag("E");
		info.setFixedAmtFee(price);
		info.setFeeRatio1(price);
		info.setRatio1Precent(price);
		info.setReducerateFrom(10);
		info.setReducerateTo(10);
		info.setReduceHandingFee(10);

		info.setCreator("123456");

		List<FinancialInfo> financialInfos = new ArrayList<FinancialInfo>();
		FinancialInfo fInfo = new FinancialInfo();
		fInfo.setPropType("AA");
		fInfo.setPropSubType("BB");
		fInfo.setPropOwner("CC");
		fInfo.setPropValue("DD");
		fInfo.setPropMemo("EE");

		financialInfos.add(fInfo);
		info.setFinancialInfos(financialInfos);
		String json = jsonMapper.toJson(info);
		return json;
	}

	public String WorkOrderQueryJson() {
		WorkOrderQuery info = new WorkOrderQuery();
		info.setCaseID("12312312");
		info.setSrcCaseId("12312");
		String json = jsonMapper.toJson(info);
		return json;
	}

}
