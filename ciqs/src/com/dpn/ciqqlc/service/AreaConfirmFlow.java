package com.dpn.ciqqlc.service;

import java.util.List;
import java.util.UUID;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.dpn.ciqqlc.standard.model.CheckResultModel;
import com.dpn.ciqqlc.standard.model.ChkRckModel;
import com.dpn.ciqqlc.standard.service.AreaConfirmFlowService;

@Repository("areaServer")
public class AreaConfirmFlow implements AreaConfirmFlowService {

	@Autowired
    @Qualifier("blankSST")
	private SqlSession sqlSession = null;

	public void insertConfirm(ChkRckModel chkRckModel) throws Exception{
		chkRckModel.setId(UUID.randomUUID().toString().replace("-",""));
		this.sqlSession.insert("SQL.AREA.insertChkRckModel", chkRckModel);

	}

	public List<CheckResultModel> selectCheckResult(CheckResultModel checkResult) throws Exception {
		return sqlSession.selectList("SQL.AREA.selectCheckResult", checkResult);
	}

}
