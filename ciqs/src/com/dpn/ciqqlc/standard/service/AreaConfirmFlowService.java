package com.dpn.ciqqlc.standard.service;

import java.util.List;

import com.dpn.ciqqlc.standard.model.CheckResultModel;
import com.dpn.ciqqlc.standard.model.ChkRckModel;

public interface AreaConfirmFlowService {

	void insertConfirm(ChkRckModel chkRckModel) throws Exception;

	List<CheckResultModel> selectCheckResult(CheckResultModel checkResult) throws Exception;

}
