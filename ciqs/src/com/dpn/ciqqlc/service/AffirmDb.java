package com.dpn.ciqqlc.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.dpn.ciqqlc.standard.model.DocTypeDTO;
import com.dpn.ciqqlc.standard.model.VideoDTO;
import com.dpn.ciqqlc.standard.model.CheckDocsRcdDTO;
import com.dpn.ciqqlc.standard.model.VisualDeclareDTO;
import com.dpn.ciqqlc.standard.service.AffirmDbService;
@Repository("affirmDbServ")
public class AffirmDb implements AffirmDbService {
	 /**
     * sqlSession.
     * @since 1.0.0
     */
    @Autowired
    @Qualifier("blankSST")
    private SqlSession sqlSession = null;
	
	public List<VisualDeclareDTO> findTransports(Map<String, String> map)throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.selectList("findTransports", map);
	}

	public int findTransportsCount(Map<String, String> map) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("findTransportsCount", map);
	}

	public VisualDeclareDTO findTransportOne(String transportid)
			throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("findTransportOne", transportid);
	}

	public List<VideoDTO> queryTransportFiles(Map<String,String> map) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.selectList("queryTransportFiles", map);
	}

	public List<DocTypeDTO> queryTransportTemplates(
			Map<String, String> map) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.selectList("queryTransportTemplates", map);
	}
	
	public List<Map<String, String>> showTransportsApp(Map<String, String> map) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.selectList("showTransportsApp", map);
	}

	public CheckDocsRcdDTO transportsTemplate(String doc_id) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("transportsTemplate", doc_id);
	}
	
	public CheckDocsRcdDTO findDocByTypeNMainId(Map<String, String> paramMap){
		return sqlSession.selectOne("SQL.AFFIRM.findDocByTypeNMainId", paramMap);
	}

	@Override
	public VisualDeclareDTO findVsvByVslDecId(VisualDeclareDTO dto) {
		return sqlSession.selectOne("findVsvByVslDecId", dto);
	}

	@Override
	public int insertVSL(VisualDeclareDTO dto) {
		return sqlSession.insert("insertVSL", dto);
	}

	@Override
	public int updateVSL(VisualDeclareDTO dto) {
		return sqlSession.update("updateVSL", dto);
	}
	
}
