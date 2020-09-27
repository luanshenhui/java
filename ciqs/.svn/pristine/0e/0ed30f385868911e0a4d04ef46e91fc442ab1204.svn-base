package com.dpn.ciqqlc.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.dpn.ciqqlc.common.util.DateUtil;
import com.dpn.ciqqlc.standard.model.BillCiqGoodModel;
import com.dpn.ciqqlc.standard.model.BillLadingBookingDTO;
import com.dpn.ciqqlc.standard.model.BillLadingDTO;
import com.dpn.ciqqlc.standard.model.BillLadingDTO2;
import com.dpn.ciqqlc.standard.model.BillladingBookModel;
import com.dpn.ciqqlc.standard.model.BilllingModel;
import com.dpn.ciqqlc.standard.model.CheckJobDTO;
import com.dpn.ciqqlc.standard.model.CiqGoodsDeclDTO;
import com.dpn.ciqqlc.standard.model.ContaDTO;
import com.dpn.ciqqlc.standard.model.ContaEventDTO;
import com.dpn.ciqqlc.standard.model.DywUnQualifyRecordDto;
import com.dpn.ciqqlc.standard.model.GoodsDTO;
import com.dpn.ciqqlc.standard.model.LabDtailDTO;
import com.dpn.ciqqlc.standard.model.LaboratoryDTO;
import com.dpn.ciqqlc.standard.model.LimsDTO;
import com.dpn.ciqqlc.standard.model.TfSysProcessLog;
import com.dpn.ciqqlc.standard.model.TfVsaSignRecordDTO;
import com.dpn.ciqqlc.standard.model.VideoEventDTO;
import com.dpn.ciqqlc.standard.model.VslDecDto;
import com.dpn.ciqqlc.standard.model.WarningDto;
import com.dpn.ciqqlc.standard.model.XunJobDTO;
import com.dpn.ciqqlc.standard.service.BillLadingService;
@Repository("billLadingServer")
public class BillLadingFlow implements BillLadingService{
	@Autowired
	@Qualifier("blankSST")
	private SqlSession sqlSession;
	
	@Autowired
	@Qualifier("ECIQSST")
	private SqlSession ceiQSession;
	
	@Autowired
	@Qualifier("blank_Sys")
	private SqlSession limsSession;
	
	public List<BillCiqGoodModel> findBillList(BillCiqGoodModel billCiqGood) throws Exception {
		return sqlSession.selectList("SQL.BILLCIQGOOD.findBillList", billCiqGood);
	}

	public int findBillCount(BillCiqGoodModel billCiqGood)throws Exception  {
		return sqlSession.selectOne("SQL.BILLCIQGOOD.findBillCount", billCiqGood);
	}

	public BilllingModel getBillladingData(BilllingModel billlingModel) throws Exception {
		List<BilllingModel>  list=ceiQSession.selectList("SQL.BILLCIQGOOD.getBillladingData", billlingModel);
		return list.size()>0?list.get(0):null;
	}

	public ContaEventDTO getContaEventDTO(BilllingModel billlingModel)throws Exception  {
		List<ContaEventDTO>  list=sqlSession.selectList("SQL.BILLCIQGOOD.getContaEventDTO", billlingModel);
		return list.size()>0?list.get(0):null;
	}

	public CheckJobDTO getCheckJobDTO(BilllingModel billlingModel)throws Exception  {
		List<CheckJobDTO>  list=sqlSession.selectList("SQL.BILLCIQGOOD.getCheckJobDTO", billlingModel);
		for(CheckJobDTO  d:list){
			if(null!=d && null!=d.getCheck_result() && d.getCheck_result().equals("3")){
				return d;
			}
		}
		return list.size()>0?list.get(0):null;
	}

	public List<VideoEventDTO> getVideoEventDTO(BilllingModel billlingModel) throws Exception {
		List<VideoEventDTO>  list=sqlSession.selectList("SQL.BILLCIQGOOD.getVideoEventDTO", billlingModel);
		for(VideoEventDTO v:list){
			String month=DateUtil.DateToString(DateUtil.formatDate(v.getCreate_date()),"yyyyMM");
			String day=DateUtil.DateToString(DateUtil.formatDate(v.getCreate_date()),"yyyyMMdd");
			String file=v.getFile_name();
			v.setFile_name(file);
		}
		return list;
	}

	public BillLadingDTO getBillLadingDTO(BilllingModel billlingModel)throws Exception  {
		return sqlSession.selectOne("SQL.BILLCIQGOOD.getBillLadingDTO", billlingModel);
	}

	public BillLadingBookingDTO getBillLadingBookingDTO(
			BilllingModel billlingModel)throws Exception  {
		return sqlSession.selectOne("SQL.BILLCIQGOOD.getBillLadingBookingDTO", billlingModel);
	}

	public CiqGoodsDeclDTO getCiqGoodsDeclDTO(BilllingModel billlingModel)throws Exception  {
		List<CiqGoodsDeclDTO>  list=sqlSession.selectList("SQL.BILLCIQGOOD.getCiqGoodsDeclDTO", billlingModel);
		return list.size()>0?list.get(0):null;
	}

	public BillCiqGoodModel findOneBillCiqGood(BilllingModel billlingModel)throws Exception  {
		return sqlSession.selectOne("SQL.BILLCIQGOOD.findOneBillCiqGood", billlingModel);
	}

	public int findOldBillCount(BillCiqGoodModel billCiqGood)throws Exception  {
		return sqlSession.selectOne("SQL.BILLCIQGOOD.findOldBillCount", billCiqGood);
	}

	public List<BillCiqGoodModel> findOldBillList(BillCiqGoodModel billCiqGood) throws Exception {
		return sqlSession.selectList("SQL.BILLCIQGOOD.findOldBillList", billCiqGood);
	}

	public BillCiqGoodModel findOldOneBillCiqGood(BilllingModel billlingModel)  throws Exception{
		return sqlSession.selectOne("SQL.BILLCIQGOOD.findOldOneBillCiqGood", billlingModel);
	}

	public BillLadingDTO getOldBillLadingDTO(BilllingModel billlingModel)  throws Exception{
		return sqlSession.selectOne("SQL.BILLCIQGOOD.getOldBillLadingDTO", billlingModel);
	}

	public BillLadingBookingDTO getOldBillLadingBookingDTO(
			BilllingModel billlingModel) throws Exception {
		return sqlSession.selectOne("SQL.BILLCIQGOOD.getOldBillLadingBookingDTO", billlingModel);
	}

	public CiqGoodsDeclDTO getOldCiqGoodsDeclDTO(BilllingModel billlingModel) throws Exception {
		List<CiqGoodsDeclDTO>  list=sqlSession.selectList("SQL.BILLCIQGOOD.getOldCiqGoodsDeclDTO", billlingModel);
		return list.size()>0?list.get(0):null;
	}

	public ContaEventDTO getOldContaEventDTO(BilllingModel billlingModel)  throws Exception{
		List<ContaEventDTO>  list=sqlSession.selectList("SQL.BILLCIQGOOD.getOldContaEventDTO", billlingModel);
		return list.size()>0?list.get(0):null;
	}

	public List<DywUnQualifyRecordDto> findDywUnQualifyRecordList(
			BillCiqGoodModel paramModel) throws Exception {
		return sqlSession.selectList("SQL.BILLCIQGOOD.findDywUnQualifyRecordList", paramModel);
	}

	public BillladingBookModel findBillladingBook(BillCiqGoodModel paramModel)throws Exception {
		List<BillladingBookModel>  list=sqlSession.selectList("SQL.BILLCIQGOOD.findBillladingBook", paramModel);
		return list.size()>0?list.get(0):null;
	}

	public List<BillladingBookModel> findGoodsName(BillCiqGoodModel paramModel)
			throws Exception {
		return sqlSession.selectList("SQL.BILLCIQGOOD.findGoodsName", paramModel);
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	public XunJobDTO queryXunbill(Map queryMap) throws Exception {
		String bookNo = (String) queryMap.get("bookNo");
		XunJobDTO xunJobDTO = new XunJobDTO();
		if(bookNo.endsWith("0")){
			queryMap.put("type", "in");
//			xunJobDTO = verifyCheckDAO.queryBillDecForPrt_sto(queryMap);
			xunJobDTO =sqlSession.selectOne("SQL.BILLCIQGOOD.queryBillDecForPrt_sto", queryMap);
		}else if(bookNo.endsWith("1")){
			queryMap.put("type", "out");
//			xunJobDTO = verifyCheckDAO.queryBillDecForPrt_sto(queryMap);
			xunJobDTO =sqlSession.selectOne("SQL.BILLCIQGOOD.queryBillDecForPrt_sto", queryMap);
		}else if(bookNo.endsWith("2")){
//			xunJobDTO = verifyCheckDAO.queryBillDecForPrt_book(queryMap);
			xunJobDTO =sqlSession.selectOne("SQL.BILLCIQGOOD.queryBillDecForPrt_book", queryMap);
		}
		return xunJobDTO;
	}

	@SuppressWarnings("rawtypes")
	public List queryXunJob(Map queryMap) throws Exception {
		return sqlSession.selectList("SQL.BILLCIQGOOD.queryXunJob",queryMap);
	}

	public VslDecDto getVslDecOne(BillCiqGoodModel vo) throws Exception {
		List<VslDecDto>  list=sqlSession.selectList("SQL.BILLCIQGOOD.getVslDecList", vo);
		return list.size()>0?list.get(0):null;
	}

	public List<ContaDTO> contaList(String bill_no) throws Exception {
		List<ContaDTO> list = sqlSession.selectList("contaList", bill_no);
		return list;
	}

	public List<LimsDTO> queryLims(String decl_no) throws Exception {
		return limsSession.selectList("queryLims", decl_no);
	}

	public LimsDTO queryLimsContent(String id) throws Exception {
		return limsSession.selectOne("queryLimsContent", id);
	}

	public List<LaboratoryDTO> queryLaboratory(String decl_no) throws Exception {
		return sqlSession.selectList("queryLaboratory", decl_no);
	}

	public List<LaboratoryDTO> queryLaboratoryById(String id) throws Exception {
		return sqlSession.selectList("queryLaboratoryById", id);
	}

	public List<LabDtailDTO> queryLabDtailById(String id) throws Exception {
		return sqlSession.selectList("queryLabDtailById", id);
	}

	@Override
	public List<TfVsaSignRecordDTO> queryCertRcd(String decl_no)
			throws Exception {
		return sqlSession.selectList("queryCertRcd", decl_no);
	}

	@Override
	public List<Map<String, String>> findOrg() throws Exception {
		return sqlSession.selectList("findOrg");
	}

	@Override
	public BillLadingDTO2 billDetailByNo(String billNo) throws Exception {
		return sqlSession.selectOne("billDetailByNo",billNo);
	}

	@Override
	public GoodsDTO getCiq2000DeclByEx(String declNo) throws Exception {
		return sqlSession.selectOne("getCiq2000DeclByEx",declNo);
	}

	@Override
	public List getCiq2000GoodsByEx(String declNo) throws Exception {
		return sqlSession.selectList("getCiq2000GoodsByEx",declNo);
	}

	@Override
	public List<ContaEventDTO> queryContaEventCy(String bill_id)
			throws Exception {
		return sqlSession.selectList("queryContaEventCy",bill_id);
	}

	@Override
	public List<WarningDto> getWarningDto(WarningDto w) throws Exception {
		return sqlSession.selectList("SQL.BILLCIQGOOD.getWarningDto",w);
	}

	@Override
	public List<TfSysProcessLog> queryTfSysProcessLog(String decl_no)
			throws Exception {
		return sqlSession.selectList("queryTfSysProcessLog",decl_no);
	}
	
	@Override
	public List<TfSysProcessLog> queryTfSysProcessLogByDecl_no(String decl_no)
			throws Exception {
		return sqlSession.selectList("queryTfSysProcessLogByDecl_no",decl_no);
	}
}
