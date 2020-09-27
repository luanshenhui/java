package com.dpn.ciqqlc.service;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.dpn.ciqqlc.http.form.ExpFoodProdForm;
import com.dpn.ciqqlc.standard.model.CheckDocsRcdDTO;
import com.dpn.ciqqlc.standard.model.EfpeApplyDTO;
import com.dpn.ciqqlc.standard.model.EfpeRegulatoryModel;
import com.dpn.ciqqlc.standard.model.ExpFoodProdCheckDto;
import com.dpn.ciqqlc.standard.model.ExpFoodProdDTO;
import com.dpn.ciqqlc.standard.model.ExpFoodProdPsnRdmDTO;
import com.dpn.ciqqlc.standard.model.ExpFoodProdReportDto;
import com.dpn.ciqqlc.standard.model.FileInfoDto;
import com.dpn.ciqqlc.standard.model.QlcEfpePsnDto;
import com.dpn.ciqqlc.standard.model.VideoFileEventModel;
import com.dpn.ciqqlc.standard.service.ExpFoodProdService;

/**
 * ExpFoodProdDb
 * @author xwj
 *
 */
@Repository("expFoodProdDb")
public class ExpFoodProdDb implements ExpFoodProdService {
	
	@Autowired
    @Qualifier("blankSST")
    private SqlSession sqlSession = null;

	public List<EfpeApplyDTO> findList(ExpFoodProdForm form) {
		return sqlSession.selectList("SQL.ExpFoodProd.findList", form);
	}
	
	public List<EfpeApplyDTO> findListApp(ExpFoodProdForm form) {
		return sqlSession.selectList("SQL.ExpFoodProd.findListApp", form);
	}

	public int findListCount(ExpFoodProdForm form) {
		return sqlSession.selectOne("SQL.ExpFoodProd.findListCount", form);
	}

	public EfpeApplyDTO findById(String id) {
		return sqlSession.selectOne("SQL.ExpFoodProd.findById", id);
	}
	
	public int add(ExpFoodProdDTO dto) {
		return sqlSession.insert("SQL.ExpFoodProd.insert", dto);
	}
	
	public CheckDocsRcdDTO findDocByTypeNMainId(Map<String, String> paramMap) {
		return sqlSession.selectOne("SQL.ExpFoodProd.findDocByTypeNMainId", paramMap);
	}
	
	public List<VideoFileEventModel> videoFileEventList(Map<String, String> map) {
		return sqlSession.selectList("SQL.ExpFoodProd.videoFileEventList",map);
	}

	public List<ExpFoodProdPsnRdmDTO> findByPseon(
			ExpFoodProdPsnRdmDTO foodProdPsnRdmDTO) {
//		return sqlSession.selectList("SQL.ExpFoodProd.findByPseon", foodProdPsnRdmDTO);		
		return sqlSession.selectList("SQL.ExpFoodProd.findAllPseonNew", foodProdPsnRdmDTO);		
	}

	public List<ExpFoodProdPsnRdmDTO> findByBasePseon(
			ExpFoodProdPsnRdmDTO foodProdPsnRdmDTO) throws Exception{
				return sqlSession.selectList("SQL.ExpFoodProd.findByBasePseon2", foodProdPsnRdmDTO);				
//			List<ExpFoodProdPsnRdmDTO> list =	sqlSession.selectList("SQL.ExpFoodProd.findByBasePseon", foodProdPsnRdmDTO);
//			if(list !=null && list.size() >0){
//				return list;
//			}
//				return null;
	}

	public int insterPersonRdm(ExpFoodProdPsnRdmDTO foodProdPsnRdmDTO) throws Exception{
		foodProdPsnRdmDTO.setRdm_date(new Date());
		return sqlSession.insert("SQL.ExpFoodProd.insertPeson", foodProdPsnRdmDTO);
	}

	public int findPersonCount(ExpFoodProdPsnRdmDTO dto) {
//		return sqlSession.selectOne("SQL.ExpFoodProd.findPersonCount", dto);
		return sqlSession.selectOne("SQL.ExpFoodProd.findAllPseonNewCount", dto);
	}

	public List<ExpFoodProdPsnRdmDTO> findAllPseon(ExpFoodProdPsnRdmDTO dto) {
		return sqlSession.selectList("SQL.ExpFoodProd.findAllPseonDown", dto);	
	}

	/*public List<FileInfoDto> findFileInfo(FileInfoDto dto) throws Exception{
		return  sqlSession.selectList("SQL.EXPFOODPOF.findFileInfo", dto);
	}

	public int findFileCount(FileInfoDto dto) throws Exception{
		return  sqlSession.selectOne("SQL.EXPFOODPOF.findFileCount", dto);
	}*/

	public void saveUpload(FileInfoDto dto) throws Exception{
		sqlSession.insert("SQL.EXPFOODPOF.saveUpload", dto);
		
	}

	public List<ExpFoodProdCheckDto> findCheckList(String applyid)
			throws Exception {
		return  sqlSession.selectList("SQL.ExpFoodProd.findCheckList", applyid);
	}

	public List<ExpFoodProdPsnRdmDTO> findRadmPeson(ExpFoodProdPsnRdmDTO dto) throws Exception{
		return sqlSession.selectList("SQL.ExpFoodProd.findRadmPeson", dto);
	}

	public List<ExpFoodProdReportDto> findFoodProdReport(
			ExpFoodProdReportDto expFoodProdReport) throws Exception {
		return sqlSession.selectList("SQL.ExpFoodProd.findFoodProdReport", expFoodProdReport);
	}

	public List<QlcEfpePsnDto> findByBasePseon2(QlcEfpePsnDto efpePsn)
			throws Exception {
		return sqlSession.selectList("SQL.ExpFoodProd.findByBasePseon2", efpePsn);
	}

	@Override
	public List<EfpeRegulatoryModel> findEfpeRegulatoryList(
			EfpeRegulatoryModel form) {
		return sqlSession.selectList("SQL.ExpFoodProd.findList", form);
	}

	@Override
	public int findEfpeRegulatoryListCount(EfpeRegulatoryModel form) {
		return sqlSession.selectOne("SQL.ExpFoodProd.findListCount", form);
	}

	@Override
	public List<EfpeRegulatoryModel> findEfpeRegulatory(
			EfpeRegulatoryModel efpeRegulatoryModel) throws Exception {
		return sqlSession.selectList("SQL.ExpFoodProd.findEfpeRegulatory", efpeRegulatoryModel);
	}

	@Override
	public List<EfpeRegulatoryModel> findEfpeRegulatoryAll(
			EfpeRegulatoryModel model) {
		return sqlSession.selectList("SQL.ExpFoodProd.findEfpeRegulatoryAll", model);
	}

	@Override
	public List<EfpeRegulatoryModel> findEfpeRegulatoryAll2(
			EfpeRegulatoryModel form) {
		return sqlSession.selectList("SQL.ExpFoodProd.findEfpeRegulatoryAll2", form);
	}

	@Override
	public FileInfoDto selectReport(FileInfoDto f) {
		return sqlSession.selectOne("SQL.ExpFoodProd.selectReport", f);
	}

}
