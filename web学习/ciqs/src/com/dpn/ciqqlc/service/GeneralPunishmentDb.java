package com.dpn.ciqqlc.service;

import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Collections;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.dpn.ciqqlc.common.util.Constants;
import com.dpn.ciqqlc.common.util.DateUtil;
import com.dpn.ciqqlc.http.form.GeneralPunishmentForm;
import com.dpn.ciqqlc.http.form.QueryBaseIo;
import com.dpn.ciqqlc.http.form.YbcfQueryIo;
import com.dpn.ciqqlc.http.result.AjaxResult;
import com.dpn.ciqqlc.standard.model.CheckDocsRcdDTO;
import com.dpn.ciqqlc.standard.model.FileInfoDto;
import com.dpn.ciqqlc.standard.model.GeneralPunishmentDTO;
import com.dpn.ciqqlc.standard.model.GeneralPunishmentHistoryDTO;
import com.dpn.ciqqlc.standard.model.LocalePunishDTO;
import com.dpn.ciqqlc.standard.model.SelectModel;
import com.dpn.ciqqlc.standard.model.UserInfoDTO;
import com.dpn.ciqqlc.standard.model.VideoFileEventModel;
import com.dpn.ciqqlc.standard.service.GeneralPunishmentService;
import com.sun.tools.jxc.apt.Const;

/**
 * 一般处罚
 * @author xwj
 *
 */
@Repository("generalPunishmentDb")
@Transactional
public class GeneralPunishmentDb implements GeneralPunishmentService {
	
	@Autowired
    @Qualifier("blankSST")
    private SqlSession sqlSession = null;
	
	public List<GeneralPunishmentHistoryDTO> findListHistory(GeneralPunishmentHistoryDTO dto){
		return sqlSession.selectList("SQL.GeneralPunishment.findListHistory", dto);
	}
	
	public List<GeneralPunishmentHistoryDTO> findHistoryByStatus(GeneralPunishmentHistoryDTO dto){
		return sqlSession.selectList("SQL.GeneralPunishment.findHistoryByStatus", dto);
	}
	public GeneralPunishmentHistoryDTO findHistory(GeneralPunishmentHistoryDTO dto){
		return sqlSession.selectOne("SQL.GeneralPunishment.findHistory", dto);
	}	
	public List<GeneralPunishmentDTO> findList(GeneralPunishmentForm form) {
		return sqlSession.selectList("SQL.GeneralPunishment.findList", form);
	}

	public int findListCount(GeneralPunishmentForm form) {
		return sqlSession.selectOne("SQL.GeneralPunishment.findListCount", form);
	}
	
	@Override
	public List<Map<String,Object>> findNewList(YbcfQueryIo form) {
		
		List<Map<String,Object>> list = sqlSession.selectList("SQL.GeneralPunishment.findNewList", form);
//		
//		for (Map<String, Object> map : list) {
//			if(Constants.AUDIT_STEP_9.equals(form.getStep()) || Constants.AUDIT_STEP_18.equals(form.getStep()) || Constants.AUDIT_STEP_19.equals(form.getStep())){
//				String map.get("STEP_9_FILE_ID");
//				if(map.get("STEP_9_FILE_ID")){}
//				
//			}
//		}
		return list;
	}

	@Override
	public int findNewListCount(YbcfQueryIo form) {
		return sqlSession.selectOne("SQL.GeneralPunishment.findNewListCount", form);
	}
	
	public GeneralPunishmentDTO findById(String id) {
		return sqlSession.selectOne("SQL.GeneralPunishment.findById", id);
	}
	public GeneralPunishmentDTO findNewById(String id) {
		return sqlSession.selectOne("SQL.GeneralPunishment.findNewById", id);
	}	
	public String getLatestCaseNo(String currYear){
		return sqlSession.selectOne("SQL.GeneralPunishment.getLatestCaseNo", currYear);
	}

	public int add(GeneralPunishmentDTO dto) {
		return sqlSession.insert("SQL.GeneralPunishment.insert", dto);
	}
	
	public int addHistory(GeneralPunishmentHistoryDTO dto) {
		return sqlSession.insert("SQL.GeneralPunishment.insertHistory", dto);
	}
	
	public int update(GeneralPunishmentDTO dto) {
		return sqlSession.insert("SQL.GeneralPunishment.update", dto);
	}

	public int updateHistory(GeneralPunishmentHistoryDTO dto) {
		return sqlSession.insert("SQL.GeneralPunishment.updateHistory", dto);
	}
	
	public int delete(String pre_report_no) {
		return sqlSession.delete("SQL.GeneralPunishment.delete", pre_report_no);
	}

	public int deleteHistory(GeneralPunishmentHistoryDTO dto) {
		return sqlSession.delete("SQL.GeneralPunishment.deleteHistory", dto);
	}

	public CheckDocsRcdDTO findDocByTypeNMainId(Map<String, Object> paramMap) {
		return sqlSession.selectOne("SQL.GeneralPunishment.findDocByTypeNMainId", paramMap);
	}

	public int addDoc(CheckDocsRcdDTO dto) {
		return sqlSession.insert("SQL.GeneralPunishment.insertDoc", dto);
	}

	public int updateDoc(CheckDocsRcdDTO dto) {
		return sqlSession.insert("SQL.GeneralPunishment.updateDoc", dto);
	}
	
	public List<VideoFileEventModel> videoFileEventList(Map<String, String> map) {
		return sqlSession.selectList("SQL.GeneralPunishment.videoFileEventList",map);
	}

	public int saveFile(FileInfoDto dto) {
		return sqlSession.insert("SQL.GeneralPunishment.insertFile", dto);
	}

	public FileInfoDto findFile(FileInfoDto dto) {
		return sqlSession.selectOne("SQL.GeneralPunishment.findFile", dto);
	}
	
	public int updateFile(FileInfoDto dto) {
		return sqlSession.insert("SQL.GeneralPunishment.updateFile", dto);
	}

	@Override
	public int deleteHistoryWhenFinished(GeneralPunishmentHistoryDTO dto) {
		return sqlSession.delete("SQL.GeneralPunishment.deleteHistoryWhenFinished", dto);
	}

	@Override
	public GeneralPunishmentHistoryDTO findStepByReportNo(
			GeneralPunishmentHistoryDTO dto) {
		return sqlSession.selectOne("SQL.GeneralPunishment.findStepByReportNo", dto);
	}

	@Override
	public int findDocCountByTypeMainId(Map<String, Object> paramMap) {
		return sqlSession.selectOne("SQL.GeneralPunishment.findDocCountByTypeMainId", paramMap);
	}
	
	@Override
	public List<Map<String,String>> findPunishList(LocalePunishDTO dto){
		return sqlSession.selectList("SQL.GeneralPunishment.findPunishList", dto);
	}
	
	@Override
	public String getWhereSql(List<QueryBaseIo> list){
		
//		StringBuilder sb = new StringBuilder();
//		for (QueryBaseIo b : list) {
//			sb.append(" and "+ b.getwName() + )
//		}
		return "";
	}
	
	@Override
	public List<SelectModel> findOrgList(){
		return sqlSession.selectList("SQL.GeneralPunishment.findOrgList", Collections.EMPTY_MAP);
	}
	
	@Override
	public List<SelectModel> findSBOrgList(){
		return sqlSession.selectList("SQL.GeneralPunishment.findSBOrgList", Collections.EMPTY_MAP);
	}
	/**
	 * 查询文档是否填写
	 */
	public int findDocByHisoryDocId(Map<String, Object> map){
		return sqlSession.selectOne("SQL.GeneralPunishment.findDocByHisoryDocId", map);
	}
	
	@Override
	public AjaxResult adoptStep(GeneralPunishmentHistoryDTO dto1,GeneralPunishmentDTO currGp,String nextStep) {
		
		GeneralPunishmentHistoryDTO paramDto = new GeneralPunishmentHistoryDTO();
		paramDto.setPre_report_no(dto1.getPre_report_no());
		paramDto.setAudit_step(nextStep);
		
		String audit_org = dto1.getAudit_org();
		if(Constants.AUDIT_STEP_3.equals(nextStep)){
			audit_org = currGp.getAccept_org();
		}
		paramDto.setAudit_status("0");
		List<GeneralPunishmentHistoryDTO> hNextList = findListHistory(paramDto);
		
		boolean flag = false;
		if(hNextList.size() > 0){//如果存在step_next, 更新
			
			GeneralPunishmentHistoryDTO dto = hNextList.get(0);
			dto.setAudit_status(Constants.GNRL_PNSMT_SHH_STATUS_0);
			dto.setAudit_date(dto.getAudit_date());
			dto.setAudit_org(audit_org);
			
			if("0".equals(dto.getAudit_status()) || StringUtils.isEmpty(dto.getAudit_status())){
				
				if(Constants.AUDIT_STEP_5.equals(dto1.getAudit_step())
						|| Constants.AUDIT_STEP_17.equals(dto1.getAudit_step())
						|| Constants.AUDIT_STEP_9.equals(dto1.getAudit_step())
						|| Constants.AUDIT_STEP_18.equals(dto1.getAudit_step())){
					dto.setDoc_id(dto1.getDoc_id());
				}
				updateHistory(dto);
			}else{
				flag = true;
			}
		}
		
		if(hNextList.size() == 0 || flag){
			GeneralPunishmentHistoryDTO dto = new GeneralPunishmentHistoryDTO();
			dto.setPre_report_no(dto1.getPre_report_no());
			
			//判断是否在【审理决定-终审】通过了不连续的next_step，如果有，按照不连续的step更新
//			if(Constants.AUDIT_STEP_12.equals(dto1.getAudit_step())){//如果是【审理决定-终审】
//				if(null != currGp){
//					if(!Constants.AUDIT_STEP_13.equals(currGp.getForward_step())){//终审通过的next_step不是step_13
//						nextStep = currGp.getForward_step();
//					}
//				}
//			}
			
			dto.setAudit_step(nextStep);
			dto.setAudit_status(Constants.GNRL_PNSMT_SHH_STATUS_0);
			dto.setAudit_org(audit_org);
			
			if(Constants.AUDIT_STEP_5.equals(dto1.getAudit_step())
					|| Constants.AUDIT_STEP_17.equals(dto1.getAudit_step())
//					|| Constants.AUDIT_STEP_9.equals(dto1.getAudit_step())
					|| Constants.AUDIT_STEP_18.equals(dto1.getAudit_step())){
				dto.setDoc_id(dto1.getDoc_id());
			}
			dto.setAudit_date(new Date());
			if(Constants.GNRL_PNSMT_SHH_STATUS_15.equals(dto1.getAudit_status())
					&& Constants.AUDIT_STEP_12.equals(dto1.getAudit_step())){
				
			}else{
				addHistory(dto);
			}
		}
		
		//判断
		//1. step5
		//2. step6
		//3. step12并且【处理建议】=【移送】
		//提交时是否已经填写了【案件移送函】，如果已经填写，此条记录后续环节不可见
		if(Constants.AUDIT_STEP_5.equals(dto1.getAudit_step()) || Constants.AUDIT_STEP_6.equals(dto1.getAudit_step()) || (Constants.AUDIT_STEP_12.equals(dto1.getAudit_step()) && "15".equals(currGp.getForward_step()))){
			
			if(StringUtils.isNotEmpty(dto1.getDoc_id())){
				
				Map<String, Object> paramMap = new HashMap<String, Object>();
				//paramMap.put("proc_main_id", currGp.getMain_id());
				paramMap.put("docIds", Arrays.asList(dto1.getDoc_id().split(",")));
				paramMap.put("doc_type", "D_GP_A_Y_1");
				
				CheckDocsRcdDTO yshDoc = findDocByTypeNMainId(paramMap);
				if(null != yshDoc){//已经填写【案件移送函】
					GeneralPunishmentHistoryDTO dto = new GeneralPunishmentHistoryDTO();
					dto.setPre_report_no(currGp.getPre_report_no());
					dto.setAudit_step(dto1.getAudit_step());
					deleteHistoryWhenFinished(dto);
				}
			}
		}
		return null;
	}
	
	/**
	 * 获取文档类型
	 * @param page
	 * @param modelStr所属模块
	 * @return
	 */
	public static String getDocTypeByStr(String page,String modelStr){
		String doc_type = "";
		if(page.startsWith("gp_anjian_ysh")){//案件移送函
			doc_type = Constants.DOC_YBCF_D_GP_A_Y_1;
		}else if(page.startsWith("gp_lian_spb")){//立案审批表
			doc_type = Constants.DOC_YBCF_D_GP_L_S_1;
		}else if(page.startsWith("gp_yanqi_spb")){//延期审批表
			doc_type = Constants.DOC_YBCF_D_GP_Y_S_1;	
		}else if(page.startsWith("gp_shexiananjian_sbd")){//涉嫌案件申报单
			doc_type = Constants.DOC_YBCF_GP_AJ_SBD;
		}else if(page.startsWith("gp_xzcf_ajfkb")){//行政处罚案件反馈表
			doc_type = Constants.DOC_YBCF_D_GP_XZCF_AJFKB;
		}else if(page.startsWith("gp_diaochabaogao")){//调查报告
			doc_type = Constants.DOC_YBCF_D_GP_DCBG;
		}else if(page.startsWith("gp_xzcf_gzs")){//行政处罚告知书
			doc_type = Constants.DOC_YBCF_D_GP_XZCF_GZS;
		}else if(page.startsWith("gp_anjian_spb")){//行政处罚案件办理审批表
			if("dcbg".equals(modelStr)){
				doc_type = Constants.DOC_YBCF_D_GP_DCBG_XZCFAJ_SPB;//调查报告中的行政处罚案件办理审批表
			}else if("dcbg_yq".equals(modelStr)){
				doc_type = Constants.DOC_YBCF_D_GP_DCBG_Y_S_1;//调查报告中的延期表
			}else{
				doc_type = Constants.DOC_YBCF_D_GP_XZCFAJ_SPB;	
			}
		}else if(page.startsWith("gp_xzcf_jds")){//行政处罚决定书
			doc_type = Constants.DOC_YBCF_D_GP_XZCF_JDS;
		}else if(page.startsWith("gp_xzcf_jabg")){//行政处罚结案报告
			doc_type = Constants.DOC_YBCF_D_GP_XZCF_JABG;
		}
		
		return doc_type;
	}
	
	/**
	 * 获取前一个与后一个步骤下一环节 
	 * [preStep,nextStep,currPage]
	 */
	public static String [] getAboutStep(String step,String docType,String status){
		String preStep = "";
		String nextStep = "";
		String currPage = step;
		switch (step) {
		case Constants.AUDIT_STEP_1:
			preStep = Constants.AUDIT_STEP_1;
			nextStep = Constants.AUDIT_STEP_2;
			break;
		case Constants.AUDIT_STEP_2:
			preStep = Constants.AUDIT_STEP_1;
			nextStep = Constants.AUDIT_STEP_3;
			break;
		case Constants.AUDIT_STEP_3:
			preStep = Constants.AUDIT_STEP_2;
			nextStep = Constants.AUDIT_STEP_16;
			break;
		case Constants.AUDIT_STEP_4:
			preStep = Constants.AUDIT_STEP_16;
			nextStep = Constants.AUDIT_STEP_5;
			break;
		case Constants.AUDIT_STEP_5:
			preStep = Constants.AUDIT_STEP_4;
			nextStep = Constants.AUDIT_STEP_17;
			break;
		case Constants.AUDIT_STEP_6:
			preStep = Constants.AUDIT_STEP_5;
			nextStep = Constants.AUDIT_STEP_7;
			break;
		case Constants.AUDIT_STEP_7:
			preStep = Constants.AUDIT_STEP_6;
			nextStep = Constants.AUDIT_STEP_8;
			break;
		case Constants.AUDIT_STEP_8:
			preStep = Constants.AUDIT_STEP_7;
			nextStep = Constants.AUDIT_STEP_9;
			break;
		case Constants.AUDIT_STEP_9:
			preStep = Constants.AUDIT_STEP_8;
			if(Constants.DOC_YBCF_D_GP_DCBG_XZCFAJ_SPB.equals(docType) || Constants.DOC_YBCF_D_GP_DCBG_Y_S_1.equals(docType)){
				nextStep = Constants.AUDIT_STEP_18;
			}else{
				nextStep = Constants.AUDIT_STEP_10;
			}
			
			break;
		case Constants.AUDIT_STEP_10:
			preStep = Constants.AUDIT_STEP_9;
			nextStep = Constants.AUDIT_STEP_20;
			break;
		case Constants.AUDIT_STEP_11:
			preStep = Constants.AUDIT_STEP_10;
			nextStep = Constants.AUDIT_STEP_12;
			break;
		case Constants.AUDIT_STEP_12:
			preStep = Constants.AUDIT_STEP_11;
			if(Constants.GNRL_PNSMT_SHH_STATUS_14.equals(status)){
				nextStep = Constants.AUDIT_STEP_14;
			}else{
				nextStep = Constants.AUDIT_STEP_13;
			}
			break;
		case Constants.AUDIT_STEP_13:
			preStep = Constants.AUDIT_STEP_12;
			nextStep = Constants.AUDIT_STEP_14;
			break;
		case Constants.AUDIT_STEP_14:
			preStep = Constants.AUDIT_STEP_13;
			nextStep = Constants.AUDIT_STEP_15;
			break;
		case Constants.AUDIT_STEP_15:
			preStep = Constants.AUDIT_STEP_4;
			nextStep = Constants.AUDIT_STEP_2;
			break;
		case Constants.AUDIT_STEP_16:
			currPage = Constants.AUDIT_STEP_3;
			preStep = Constants.AUDIT_STEP_3;
			nextStep = Constants.AUDIT_STEP_4;
			break;
		case Constants.AUDIT_STEP_17:
			currPage = Constants.AUDIT_STEP_5;
			preStep = Constants.AUDIT_STEP_5;
			nextStep = Constants.AUDIT_STEP_6;
			break;
		case Constants.AUDIT_STEP_18:
			preStep = Constants.AUDIT_STEP_9;
			nextStep = Constants.AUDIT_STEP_19;
			break;
		case Constants.AUDIT_STEP_19:
			preStep = Constants.AUDIT_STEP_18;
			if(Constants.DOC_YBCF_D_GP_DCBG_XZCFAJ_SPB.equals(docType)){
				nextStep = Constants.AUDIT_STEP_14;
			}else if( Constants.DOC_YBCF_D_GP_DCBG_Y_S_1.equals(docType)){
				nextStep = Constants.AUDIT_STEP_9;
			}else{
				nextStep = Constants.AUDIT_STEP_10;
			}
			break;
			
		case Constants.AUDIT_STEP_20:
			preStep = Constants.AUDIT_STEP_10;
			currPage = Constants.AUDIT_STEP_10;
			nextStep = Constants.AUDIT_STEP_11;
			break;
//		case Constants.AUDIT_STEP_17:
//			nextStep = Constants.AUDIT_STEP_2;
//			break;
//		case Constants.AUDIT_STEP_18:
//			nextStep = Constants.AUDIT_STEP_2;
//			break;
//		case Constants.AUDIT_STEP_19:
//			nextStep = Constants.AUDIT_STEP_2;
//			break;
//		case Constants.AUDIT_STEP_20:
//			nextStep = Constants.AUDIT_STEP_2;
//			break;
		default:
			preStep = "";
			nextStep = "";
			break;
		}
		String [] list = {preStep,nextStep,currPage};
		return  list;
	}

}
