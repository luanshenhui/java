package com.dpn.ciqqlc.standard.service;

import java.util.List;

import com.dpn.ciqqlc.http.form.WarningLinkRuleForm;
import com.dpn.ciqqlc.standard.model.SelectModel;
import com.dpn.ciqqlc.standard.model.WarningRuleDto;
import com.dpn.ciqqlc.standard.model.WarningStandardEventDto;

public interface WarningService {

	List<WarningRuleDto> findWarningList(WarningRuleDto warningRuleDto);

	int findwarinCount(WarningRuleDto warningRuleDto);

	void insertWarning(WarningRuleDto warningRuleDto);

	void updateWarning(WarningRuleDto warningRuleDto);

	void deleteWarning(WarningRuleDto warningRuleDto);

	List<WarningStandardEventDto> findGuifanList(
			WarningStandardEventDto warningStandardEventDto);

	int findGuifanCount(WarningStandardEventDto warningStandardEventDto);

	List<SelectModel> findCodeLibrary(SelectModel model);

	List<WarningLinkRuleForm> findGuifanWeihuList(
			WarningLinkRuleForm warningLinkRuleForm);

	int findGuifanWeihuCount(WarningLinkRuleForm warningLinkRuleForm);

	List<WarningLinkRuleForm> findTypeRuleList(
			WarningLinkRuleForm warningLinkRuleForm);

	Object findWarningLinkRuleFormById(WarningLinkRuleForm m);

	void updateWeihu(WarningLinkRuleForm m) throws Exception;

}

