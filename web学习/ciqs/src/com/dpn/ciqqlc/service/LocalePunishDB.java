package com.dpn.ciqqlc.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.dpn.ciqqlc.standard.model.DocTypeDTO;
import com.dpn.ciqqlc.standard.model.LegalPunishModel;
import com.dpn.ciqqlc.standard.model.LocalePunishDTO;
import com.dpn.ciqqlc.standard.model.VideoDTO;
import com.dpn.ciqqlc.standard.service.LocalePunishDbService;

@Repository("localePunishDBServ")
public class LocalePunishDB implements LocalePunishDbService {
	/**
	 * sqlSession.
	 * 
	 * @since 1.0.0
	 */
	@Autowired
	@Qualifier("blankSST")
	private SqlSession sqlSession = null;

	public List<LocalePunishDTO> findLocalePunishes(Map<String, String> map)
			throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.selectList("SQL.PUNISH.findLocalePunishes", map);
	}

	public int findLocalePunishesCount(Map<String, String> map)
			throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("SQL.PUNISH.findLocalePunishesCount", map);
	}

	public LocalePunishDTO localepunishInfo(Map<String, String> map)
			throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("SQL.PUNISH.localepunishInfo", map);
	}

	public List<VideoDTO> queryPunishFiles(Map<String, String> map)
			throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.selectList("SQL.PUNISH.queryPunishFiles", map);
	}

	public List<DocTypeDTO> queryPunishDocs(Map<String, String> map)
			throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.selectList("SQL.PUNISH.queryPunishDocs", map);
	}

	public int insertPunishFiles(Map<String, String> map) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.insert("SQL.PUNISH.insertPunishFiles", map);
	}

	public void insertLocalePunish(LocalePunishDTO dto) throws Exception {
		sqlSession.insert("SQL.PUNISH.insertLocalePunish", dto);
	}

	@Override
	public void updateLocalePunish(LocalePunishDTO dto) throws Exception {
		sqlSession.update("SQL.PUNISH.updateLocalePunish", dto);
	}

	public LegalPunishModel findPunishList(LocalePunishDTO dto)
			throws Exception {
		return sqlSession.selectOne("SQL.PUNISH.findPunishList", dto);
	}

	@Override
	public Integer findLocaleCount(String punish_id) throws Exception {
		return sqlSession.selectOne("SQL.PUNISH.findLocaleCount", punish_id);
	}

	@Override
	public Map<String, String> searchDetail(String punish_id)
			throws Exception {
		return sqlSession.selectOne("SQL.PUNISH.searchDetail", punish_id);
	}
}
