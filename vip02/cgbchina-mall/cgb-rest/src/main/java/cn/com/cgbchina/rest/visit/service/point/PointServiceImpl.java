package cn.com.cgbchina.rest.visit.service.point;

import cn.com.cgbchina.generator.IdGenarator;
import cn.com.cgbchina.rest.common.connect.ConnectOtherSys;
import cn.com.cgbchina.rest.common.model.SoapModel;
import cn.com.cgbchina.rest.common.process.InputSoapBodyProcessImpl;
import cn.com.cgbchina.rest.common.process.InputSoapHanderProcessImpl;
import cn.com.cgbchina.rest.common.process.OutputSoapProcessImpl;
import cn.com.cgbchina.rest.common.utils.BeanUtils;
import cn.com.cgbchina.rest.common.utils.SOAPUtils;
import cn.com.cgbchina.rest.visit.model.point.PointTypeQuery;
import cn.com.cgbchina.rest.visit.model.point.PointTypeQueryResult;
import cn.com.cgbchina.rest.visit.model.point.QueryPointResult;
import cn.com.cgbchina.rest.visit.model.point.QueryPointsInfo;
import cn.com.cgbchina.rest.visit.vo.point.PointTypeQueryResultVO;
import cn.com.cgbchina.rest.visit.vo.point.PointTypeQueryVO;
import cn.com.cgbchina.rest.visit.vo.point.QueryPointResultVO;
import cn.com.cgbchina.rest.visit.vo.point.QueryPointsInfoVO;
import com.google.common.base.MoreObjects;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

@Service
public class PointServiceImpl implements PointService {
	private static final String RECEIVERID = "JFDJ";
	@Resource
	private InputSoapHanderProcessImpl inputSoapHanderProcessImpl;
	@Resource
	private InputSoapBodyProcessImpl inputSoapBodyProcessImpl;
	@Resource
	private OutputSoapProcessImpl outputSoapProcessImpl;
	@Resource
	private IdGenarator idGenarator;

	@Override
	public PointTypeQueryResult queryPointType(PointTypeQuery query) {
		query.setCurrentPage(String.valueOf(Integer.valueOf(query.getCurrentPage()) + 1));
		PointTypeQueryVO sendVo = BeanUtils.copy(query, PointTypeQueryVO.class);
		SoapModel<PointTypeQueryVO> model = SOAPUtils.createSOAPModel(idGenarator.genarateSenderSN(), sendVo);
		model.setTradeCode("bms007");
		model.setReceiverId(RECEIVERID);
		String outXml = outputSoapProcessImpl.packing(model, String.class);
		String returnXml = ConnectOtherSys.connectSoapSys(outXml, model);
		PointTypeQueryResultVO resultOther = (PointTypeQueryResultVO) inputSoapBodyProcessImpl.packing(returnXml,
				PointTypeQueryResultVO.class);
		PointTypeQueryResult result = BeanUtils.copy(resultOther, PointTypeQueryResult.class);
		return result;
	}

	@Override
	public QueryPointResult queryPoint(QueryPointsInfo info) {
		info.setCurrentPage(String.valueOf(Integer.valueOf(MoreObjects.firstNonNull(info.getCurrentPage(),"0")) + 1));
		QueryPointsInfoVO sendVo = BeanUtils.copy(info, QueryPointsInfoVO.class);
		SoapModel<QueryPointsInfoVO> model = SOAPUtils.createSOAPModel(idGenarator.genarateSenderSN(), sendVo);
		model.setTradeCode("bms011");
		model.setReceiverId(RECEIVERID);
		String outXml = outputSoapProcessImpl.packing(model, String.class);
		String returnXml = ConnectOtherSys.connectSoapSys(outXml, model);
		QueryPointResultVO resultOther = (QueryPointResultVO) inputSoapBodyProcessImpl.packing(returnXml,
				QueryPointResultVO.class);
//		for (QueryPointsInfoResultVO list : resultOther.getQueryPointsInfoResults()) {
//			if (list != null && StringUtils.isNotEmpty(list.getJgId())) {
//				list.setJgId("00" + list.getJgId());
//			}
//		}
		QueryPointResult result = BeanUtils.copy(resultOther, QueryPointResult.class);
		return result;
	}

}
