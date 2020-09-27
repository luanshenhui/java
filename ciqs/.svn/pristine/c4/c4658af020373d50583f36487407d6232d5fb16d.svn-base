package com.dpn.ciqqlc.standard.service;

import java.util.List;
import java.util.Map;

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
import com.dpn.ciqqlc.standard.model.TfVsaSignRecordDTO;
import com.dpn.ciqqlc.standard.model.VideoEventDTO;
import com.dpn.ciqqlc.standard.model.VslDecDto;
import com.dpn.ciqqlc.standard.model.XunJobDTO;

public interface BillLadingService {

	List<BillCiqGoodModel> findBillList(BillCiqGoodModel billCiqGood)
			throws Exception;

	int findBillCount(BillCiqGoodModel billCiqGood) throws Exception;

	BilllingModel getBillladingData(BilllingModel billlingModel)
			throws Exception;

	ContaEventDTO getContaEventDTO(BilllingModel billlingModel)
			throws Exception;

	CheckJobDTO getCheckJobDTO(BilllingModel billlingModel) throws Exception;

	List<VideoEventDTO> getVideoEventDTO(BilllingModel billlingModel)
			throws Exception;

	BillLadingDTO getBillLadingDTO(BilllingModel billlingModel)
			throws Exception;

	BillLadingBookingDTO getBillLadingBookingDTO(BilllingModel billlingModel)
			throws Exception;

	CiqGoodsDeclDTO getCiqGoodsDeclDTO(BilllingModel billlingModel)
			throws Exception;

	BillCiqGoodModel findOneBillCiqGood(BilllingModel billlingModel)
			throws Exception;

	int findOldBillCount(BillCiqGoodModel billCiqGood) throws Exception;

	List<BillCiqGoodModel> findOldBillList(BillCiqGoodModel billCiqGood)
			throws Exception;

	BillCiqGoodModel findOldOneBillCiqGood(BilllingModel billlingModel)
			throws Exception;

	BillLadingDTO getOldBillLadingDTO(BilllingModel billlingModel)
			throws Exception;

	BillLadingBookingDTO getOldBillLadingBookingDTO(BilllingModel billlingModel)
			throws Exception;

	CiqGoodsDeclDTO getOldCiqGoodsDeclDTO(BilllingModel billlingModel)
			throws Exception;

	ContaEventDTO getOldContaEventDTO(BilllingModel billlingModel)
			throws Exception;

	List<DywUnQualifyRecordDto> findDywUnQualifyRecordList(
			BillCiqGoodModel paramModel) throws Exception;

	BillladingBookModel findBillladingBook(BillCiqGoodModel paramModel)
			throws Exception;

	List<BillladingBookModel> findGoodsName(BillCiqGoodModel paramModel)
			throws Exception;

	@SuppressWarnings("rawtypes")
	XunJobDTO queryXunbill(Map queryMap) throws Exception;

	@SuppressWarnings("rawtypes")
	List queryXunJob(Map queryMap) throws Exception;

	/**
	 * 获取 大窑湾 交通运输工具监管
	 * 
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	VslDecDto getVslDecOne(BillCiqGoodModel vo) throws Exception;

	List<ContaDTO> contaList(String bill_no) throws Exception;

	List<LimsDTO> queryLims(String decl_no) throws Exception;

	LimsDTO queryLimsContent(String id) throws Exception;

	List<LaboratoryDTO> queryLaboratory(String decl_no) throws Exception;

	List<LaboratoryDTO> queryLaboratoryById(String id) throws Exception;

	List<LabDtailDTO> queryLabDtailById(String id) throws Exception;

	List<TfVsaSignRecordDTO> queryCertRcd(String decl_no) throws Exception;

	List<Map<String, String>> findOrg() throws Exception;
	
	BillLadingDTO2 billDetailByNo(String billId) throws Exception;
	
	public GoodsDTO getCiq2000DeclByEx(String declNo) throws Exception;
	public List getCiq2000GoodsByEx(String declNo) throws Exception;

	List<ContaEventDTO> queryContaEventCy(String bill_id) throws Exception;

}
