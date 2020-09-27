package com.dpn.ciqqlc.service;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import asposewobfuscated.ha;

import com.dpn.ciqqlc.standard.model.CheckDocsRcdDTO;
import com.dpn.ciqqlc.standard.model.DeclarationDTO;
import com.dpn.ciqqlc.standard.model.HlthCheckDTO;
import com.dpn.ciqqlc.standard.model.ImageDTO;
import com.dpn.ciqqlc.standard.model.MailSteamerChkDealDTO;
import com.dpn.ciqqlc.standard.model.MailSteamerChkDealModel;
import com.dpn.ciqqlc.standard.model.MailSteamerDTO;
import com.dpn.ciqqlc.standard.model.MailSteamerHlthCheckModel;
import com.dpn.ciqqlc.standard.model.MailSteamerResultDTO;
import com.dpn.ciqqlc.standard.model.MailSteamerRmkDTO;
import com.dpn.ciqqlc.standard.model.MailSteamerSampDTO;
import com.dpn.ciqqlc.standard.service.MailSteamerService;
@Repository("mailSteamerDbServ")
public class MailSteamerDb implements MailSteamerService {
	/**
     * sqlSession.
     * @since 1.0.0
     */
    @Autowired
    @Qualifier("blankSST")
    private SqlSession sqlSession = null;

	public List<MailSteamerDTO> findEnforcementprocessList(
			Map<String, String> map) throws Exception {
		return sqlSession.selectList("findEnforcementprocessList", map);
	}

	public int findEnforcementprocessCount(Map<String, String> map)
			throws Exception {
		return sqlSession.selectOne("findEnforcementprocessCount", map);
	}

	public Map<String, String> findEnforcementprocessById(String processId)
			throws Exception {
		return sqlSession.selectOne("findEnforcementprocessById", processId);
	}
	
	
	public List<Map<String, String>> getfileList(
			Map<String, String> map) throws Exception {
		return sqlSession.selectList("getfileList", map);
	}
	
	public List<Map<String, String>> getDocList(
			Map<String, String> map) throws Exception {
		return sqlSession.selectList("getDocList", map);
	}
	
	public Map<String, String> processtemplate(String doc_id) throws Exception {
		return sqlSession.selectOne("processtemplate", doc_id);
	}

	public List<DeclarationDTO> findDeclarationlist(Map<String, String> map)
			throws Exception {
		return sqlSession.selectList("findDeclarationlist", map);
	}

	public int findDeclarationCount(Map<String, String> map) throws Exception {
		return sqlSession.selectOne("findDeclarationCount", map);
	}
	
	
	public List<HlthCheckDTO> getHlthcheckList(Map<String, String> map)
			throws Exception {
		return sqlSession.selectList("getHlthcheckList", map);
	}
	
	public CheckDocsRcdDTO findDocByTypeNMainId(Map<String, String> paramMap) {
		List<CheckDocsRcdDTO> result = sqlSession.selectList("SQL.MailSteamer.findDocByTypeNMainId", paramMap); 
		if(result.size()>0){
			return result.get(0);
		}else{
			return new CheckDocsRcdDTO();
		}
		 
	}
	
	public List<HlthCheckDTO> findHlthchecklist(
			Map<String, String> map) throws Exception {
		return sqlSession.selectList("findHlthchecklist", map);
	}

	public int findHlthcheckCount(Map<String, String> map)
			throws Exception {
		return sqlSession.selectOne("findHlthcheckCount", map);
	}

	public List<MailSteamerDTO> findMailSteamerList(MailSteamerDTO mailsteamer)
			throws Exception {
		return sqlSession.selectList("SQL.MailSteamer.findMailSteamerList",mailsteamer);
	}
	
	public MailSteamerDTO findMailSteamerOne(MailSteamerDTO mailsteamer)
			throws Exception {
		return sqlSession.selectOne("SQL.MailSteamer.findMailSteamerOne",mailsteamer);
	}
	
	public List<HlthCheckDTO> getHlthcheckdetail(Map<String, String> map) throws Exception {
		return sqlSession.selectList("getHlthcheckdetail", map);
	}

	public List<ImageDTO> getImgeList(Map<String, String> map) throws Exception {
		return sqlSession.selectList("getImgeList", map);
	}
	
	public List<Map<String, String>> findHlthcheckdetail(Map<String, String> map) throws Exception {
		return sqlSession.selectList("findHlthcheckdetail", map);
	}
	
	public void insertMailChkDeal(MailSteamerChkDealModel mailSteamerChkDealModel) {
		String uuid =	UUID.randomUUID().toString();
		mailSteamerChkDealModel.setId(uuid);
		this.sqlSession.insert("SQL.MailSteamer.insertMailChkDeal", mailSteamerChkDealModel);
	}

	public void insertMailHlthCheck(
			MailSteamerHlthCheckModel mailSteamerHlthCheckModel) {
		String uuid =	UUID.randomUUID().toString();
		mailSteamerHlthCheckModel.setId(uuid);
		this.sqlSession.insert("SQL.MailSteamer.insertMailHlthCheck", mailSteamerHlthCheckModel);
		
	}

	public void insertMailSamp(MailSteamerSampDTO mailSteamerSampDTO) {
		String uuid =	UUID.randomUUID().toString();
		mailSteamerSampDTO.setId(uuid);
		this.sqlSession.insert("SQL.MailSteamer.insertMailSamp", mailSteamerSampDTO);
	}

	public MailSteamerRmkDTO findMailSteamerRmkByDecMasterId(String mailId) {
		return sqlSession.selectOne("findMailSteamerRmkByDecMasterId", mailId);
	}
	
	/**
	 * 接口文档3.27 - 邮轮检疫处理查询列表
	 */
	public List<MailSteamerChkDealDTO> findMailSteamerChkDealList(String dec_master_id) {
		return sqlSession.selectList("SQL.MailSteamer.findMailSteamerChkDealList", dec_master_id);
	}

	public void insertMailChkDealSingle(
			MailSteamerChkDealDTO mailSteamerChkDealDTO) {
		String uuid =	UUID.randomUUID().toString();
		mailSteamerChkDealDTO.setId(uuid);
		this.sqlSession.insert("SQL.MailSteamer.insertMailChkDealSingle", mailSteamerChkDealDTO);
	}

	public int insertMailSteamerRmk(MailSteamerRmkDTO dto) {
		return this.sqlSession.insert("SQL.MailSteamer.insertMailSteamerRmk", dto);
	}

	public int updateMailSteamerRmkById(MailSteamerRmkDTO dto) {
		return this.sqlSession.insert("SQL.MailSteamer.updateMailSteamerRmkById", dto);
	}
	
	public List<MailSteamerSampDTO> findSampList(
			Map<String, String> map) throws Exception {
		return sqlSession.selectList("findSampList", map);
	}
	
	public int findSampCount(Map<String, String> map)
			throws Exception {
		return sqlSession.selectOne("findSampCount", map);
	}

	public List<MailSteamerChkDealDTO> findChkDealList(Map<String, String> map)
			throws Exception {
		return sqlSession.selectList("findChkDealList", map);
	}

	public int findChkDealCount(Map<String, String> map) throws Exception {
		return sqlSession.selectOne("findChkDealCount", map);
	}

	public HlthCheckDTO getLatestCheck(String dec_master_id) throws Exception {
		//return sqlSession.selectOne("getLatestCheck", dec_master_id);
		List<HlthCheckDTO> list = sqlSession.selectList("getLatestCheck", dec_master_id);
		if(null != list && list.size() > 0){
			return list.get(0);
		}
		return new HlthCheckDTO();
	}

	public MailSteamerSampDTO getLatestSamp(String dec_master_id) throws Exception {
		//return sqlSession.selectOne("getLatestSamp", dec_master_id);
		List<MailSteamerSampDTO> list = sqlSession.selectList("getLatestSamp", dec_master_id);
		if(null != list && list.size() > 0){
			return list.get(0);
		}
		return new MailSteamerSampDTO();
	}

	public MailSteamerChkDealDTO getLatestDeal(String dec_master_id)
			throws Exception {
		//return sqlSession.selectOne("getLatestDeal", dec_master_id);
		List<MailSteamerChkDealDTO> list = sqlSession.selectList("getLatestDeal", dec_master_id);
		if(null != list && list.size() > 0){
			return list.get(0);
		}
		return new MailSteamerChkDealDTO();
	}
	
	@Override
	public List<Map<String, String>> getLastResult(String dec_master_id)
			throws Exception {
		return sqlSession.selectList("getLastResult", dec_master_id);
	}

	public void insertMailResult(MailSteamerResultDTO dto) {
		this.sqlSession.insert("SQL.MailSteamer.insertMailResult", dto);
	}

	@Override
	public List<MailSteamerSampDTO> findSamp(String proc_main_id,
			String doc_type) {
		Map<String, String> map = new HashMap<String, String>();
		map.put("proc_main_id", proc_main_id);
		map.put("doc_type", doc_type);
		return this.sqlSession.selectList("SQL.MailSteamer.findSamp", map);
	}

	@Override
	public MailSteamerChkDealModel findMailDeal(Map<String, String> paramMap) {
		return this.sqlSession.selectOne("SQL.MailSteamer.findMailDeal", paramMap);
	}

	@Override
	public List<Map<String, String>> findSampById(String proc_main_id) {
		return this.sqlSession.selectList("SQL.MailSteamer.findSampById", proc_main_id);
	}

	@Override
	public List<Map<String, String>> findChekDetail(String proc_main_id,
			String proc_type) {
		Map<String, String> param = new HashMap<String, String>();
		param.put("proc_main_id", proc_main_id);
		param.put("proc_type", proc_type);
		return this.sqlSession.selectList("SQL.MailSteamer.findChekDetail", param);
	}

	@Override
	public List<Map<String, String>> findClyj() {
		return this.sqlSession.selectList("SQL.MailSteamer.findClyj");
	}
}
