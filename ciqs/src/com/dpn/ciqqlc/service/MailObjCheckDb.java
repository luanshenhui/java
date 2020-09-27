package com.dpn.ciqqlc.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.dpn.ciqqlc.common.util.Constants;
import com.dpn.ciqqlc.common.util.WarningEnum;
import com.dpn.ciqqlc.http.form.MailObjCheckForm;
import com.dpn.ciqqlc.service.dto.WarningDto;
import com.dpn.ciqqlc.standard.model.MailObjCheckModel;
import com.dpn.ciqqlc.standard.model.SelectModel;
import com.dpn.ciqqlc.standard.model.UserInfoDTO;
import com.dpn.ciqqlc.standard.model.UsersDTO;
import com.dpn.ciqqlc.standard.model.VideoFileEventModel;
import com.dpn.ciqqlc.standard.model.WarningEventDto;
import com.dpn.ciqqlc.standard.service.MailObjCheckDbService;
import com.dpn.ciqqlc.standard.service.WarningEventService;

/**
 * MailObjCheckDb
 * 
 * @author wangzhy
 * @since 1.0.0
 * @version 1.0.0
 */
/* *****************************************************************************
 * 备忘记录
 * -> 数据库服务实现。
 ********************************************************************************
 * 变更履历
 * -> 
 ***************************************************************************** */
@Repository("mailObjCheckServ")
public class MailObjCheckDb implements MailObjCheckDbService {

	/**
     * sqlSession.
     * @since 1.0.0
     */
    @Autowired
    @Qualifier("blankSST")
    private SqlSession sqlSession = null;
	@Autowired
	@Qualifier("warningEventService")
	private WarningEventService warningEventService = null;
    
	public void createMail(Map<String, Object> map) {
		sqlSession.insert("SQL.MAIL.createMail", map);	
	}
	
	public List<MailObjCheckModel> findMail(Map<String, String> map) {
		return sqlSession.selectList("SQL.MAIL.findMail", map);
	}

	public int findMainCount(Map<String, String> map) {
		return sqlSession.selectOne("SQL.MAIL.findMainCount", map);
	}

	public List allDealType() {
		return sqlSession.selectList("SQL.MAIL.allDealType");
	}

	public MailObjCheckModel findUMailById(Map map) {
		return sqlSession.selectOne("SQL.MAIL.findUMailById",map);
	}


	public List<SelectModel> allOrgList() {
		return sqlSession.selectList("SQL.MAIL.allOrgList");
	}

	public List<SelectModel> allDepList() {
		return sqlSession.selectList("SQL.MAIL.allDepList");
	}


	public List<VideoFileEventModel> videoFileEventList(Map map) {
		return sqlSession.selectList("SQL.MAIL.videoFileEventList",map);
	}

	public List<MailObjCheckModel> selectMail(Map map) {
		return sqlSession.selectList("SQL.MAIL.selectMail",map);
	}
	
	public List<MailObjCheckModel> selectMailDetail(Map map) {
		return sqlSession.selectList("SQL.MAIL.selectMailDetail",map);
	}
	
	public int selectMailExist(Map map) {
		return sqlSession.selectOne("SQL.MAIL.selectMailExist",map);
	}
	
	public void updateMail(MailObjCheckModel mailObjCheckModel) {
		sqlSession.update("updateMail",mailObjCheckModel);
	}

	public void updateStatus(HttpServletRequest request ,Map<String, Object> map) {
		sqlSession.update("updateStatus",map);
		//TODO
		UserInfoDTO user = (UserInfoDTO) request.getSession().getAttribute(Constants.USER_KEY);
		WarningDto dto =new WarningDto();
		dto.setBusinessType(WarningEnum.ql0308001.getWarningLinkRuleForm().getBusinessType());
		dto.setBusinessName(WarningEnum.ql0308001.getWarningLinkRuleForm().getBusinessName());
		dto.setWarningId(map.get("package_no").toString());
		dto.setPartnerCode(user.getPort_code()); // 部门
		List<WarningEventDto> eventDtoList=new ArrayList<WarningEventDto>();
		WarningEventDto warningEventDto=new WarningEventDto();
		warningEventDto.setWarningId(dto.getWarningId());
		warningEventDto.setFirstModuleType(WarningEnum.ql0308001.getWarningLinkRuleForm().getLinkType());
		warningEventDto.setFirstModuleName(WarningEnum.ql0308001.getWarningLinkRuleForm().getLinkName());
		warningEventDto.setThirdModuleType(WarningEnum.ql0308001.getWarningLinkRuleForm().getDicType());
		warningEventDto.setThirdModuleName(WarningEnum.ql0308001.getWarningLinkRuleForm().getDicName());
		warningEventDto.setBusinessType(WarningEnum.ql0308001.getWarningLinkRuleForm().getBusinessType());
		warningEventDto.setBusinessName(WarningEnum.ql0308001.getWarningLinkRuleForm().getBusinessName());
		eventDtoList.add(warningEventDto);
		warningEventService.updateEvent(dto);
	}

	public boolean getIsImg(Map<String, Object> map) {
		List list = sqlSession.selectList("SQL.MAIL.getIsImg",map);
		if(list !=null && list.size() > 0){
			return true;
		}else{
			return false;
		}
	}
	
	public List ydxhList(Map<String, Object> map) {
		return sqlSession.selectList("SQL.MAIL.xhList",map);
	}

	@Override
	public void updateMailObjCheckDitroyId(Map<String, Object> map) {
		sqlSession.update("updateMailObjCheckDitroyId",map);
	}

	@Override
	public List<MailObjCheckModel> xhList(Map<String, String> map) {
		return sqlSession.selectList("SQL.MAIL.pcxhList",map);
	}
}
