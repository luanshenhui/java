package com.dpn.ciqqlc.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.dpn.ciqqlc.common.util.BeanUtils;
import com.dpn.ciqqlc.common.util.Constants;
import com.dpn.ciqqlc.common.util.DateUtil;
import com.dpn.ciqqlc.standard.model.Tgoods;
import com.dpn.ciqqlc.standard.model.Tquar;
import com.dpn.ciqqlc.standard.service.TgoodsService;
import com.dpn.ciqqlc.webclient.good.soapXml;
import com.dpn.ciqqlc.webservice.xml.GoodXml;
import com.dpn.ciqqlc.webservice.xml.QuarXml;
import com.dpn.ciqqlc.webservice.xml.TgoodsXml;
import com.dpn.ciqqlc.webservice.xml.TquarXml;
import com.thoughtworks.xstream.XStream;
import com.thoughtworks.xstream.io.xml.DomDriver;

@Repository("tgoodsServiceDbService")
@Transactional
public class TgoodsServiceDb implements TgoodsService {
	
	public static final String DOM_GOOD_BEGIN = "<TGoods>";
	public static final String DOM_GOOD_END = "</TGoods>";
	public static final String DOM_TQUAR_BEGIN = "<TQuar>";
	public static final String DOM_TQUAR_END = "</TQuar>";

	@Autowired
	@Qualifier("blankSST")
	private SqlSession sqlSession;
	
	@Override
	public int deleteByPrimaryKey(String ID) {
		return sqlSession.delete("SQL.Tgoods.deleteByPrimaryKey", ID);
	}

	@Override
	public int insert(Tgoods record) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int insertSelective(Tgoods record) {
		return sqlSession.insert("SQL.Tgoods.insertSelective",record);
	}

	@Override
	public Tgoods selectByPrimaryKey(String ID) {
		return sqlSession.selectOne("SQL.Tgoods.selectByPrimaryKey", ID);
	}

	@Override
	public int updateByPrimaryKeySelective(Tgoods record) {
		
		return sqlSession.update("SQL.Tgoods.updateByPrimaryKeySelective", record);
	}

	@Override
	public int updateByPrimaryKey(Tgoods record) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int fetchMaxGoodId() {
		return sqlSession.selectOne("SQL.Tgoods.fetchMaxGoodId");
	}

	@Override
	public void addGoodByWebClient(String sessionID) {
		this.addGoodByWebClientImp(sessionID);
	}

	private void addGoodByWebClientImp(String m_strSessionID){
		
		try {
			int goodId = sqlSession.selectOne("SQL.Tgoods.fetchMaxGoodId");
			
			XStream stream = new XStream(new DomDriver());
			
			stream.processAnnotations(GoodXml.class);
			
			Map<String, Object> params = new HashMap<String,Object>();
			params.put("PackageSize", 20);
			params.put("GoodsIDMin", goodId);

			String goodStr = soapXml.fetchSoapXml("GetIntcpGoodsDataAsXML", m_strSessionID,params);

			if(goodStr.indexOf(DOM_GOOD_BEGIN) != -1){
				String goods = Constants.DOM_PARENT_BEGIN+ goodStr.substring(goodStr.indexOf(DOM_GOOD_BEGIN),(goodStr.lastIndexOf(DOM_GOOD_END)+DOM_GOOD_END.length()) ) +Constants.DOM_PARENT_END;
				System.out.println(goods);
				GoodXml good = (GoodXml) stream.fromXML(goods);
				List<TgoodsXml> lg = good.getList();
				
				for (TgoodsXml g : lg) {

					JSONObject j = JSONObject.fromObject(g);
					Tgoods tg = (Tgoods)BeanUtils.jsonToBeanIgnoreCase(j.toString(),Tgoods.class);
					tg.setENTERDATE(DateUtil.DateString2formatString(tg.getENTERDATE()));
					tg.setFORMDATE(DateUtil.DateString2formatString(tg.getFORMDATE()));
					tg.setQCDATE(DateUtil.DateString2formatString(tg.getQCDATE()));
					tg.setRECEIVEDDATE(DateUtil.DateString2formatString(tg.getRECEIVEDDATE()));
					tg.setTREATDATE(DateUtil.DateString2formatString(tg.getTREATDATE()));
					if(tg.getMARKID() != null && "".equals(tg.getMARKID().trim())){
						tg.setMARKID(null);
					}
					Tgoods gi = this.selectByPrimaryKey(tg.getID());
					if(gi == null) insertSelective(tg);
					params.put("PackageSize", 100);
					params.put("GoodsIDMin", tg.getID());
					String QuaryStr = soapXml.fetchSoapXml("GetIntcpQuarDataAsXML",m_strSessionID, params);
					if(QuaryStr.indexOf(DOM_TQUAR_BEGIN) != -1){
						String tqx = Constants.DOM_PARENT_BEGIN+ QuaryStr.substring(QuaryStr.indexOf(DOM_TQUAR_BEGIN),(QuaryStr.lastIndexOf(DOM_TQUAR_END)+DOM_TQUAR_END.length()) ) +Constants.DOM_PARENT_END;
						
						XStream q_stream = new XStream(new DomDriver());
						q_stream.processAnnotations(QuarXml.class);
						QuarXml qx = (QuarXml) q_stream.fromXML(tqx);
						List<TquarXml> lt = qx.getList();
						
						for (TquarXml q : lt) {
							
							JSONObject jq = JSONObject.fromObject(q);
							Tquar tqr = (Tquar)BeanUtils.jsonToBeanIgnoreCase(jq.toString(),Tquar.class);
							tqr.setFORMDATE(DateUtil.DateString2formatString(tqr.getFORMDATE()));
							tqr.setINTERDATE(DateUtil.DateString2formatString(tqr.getINTERDATE()));
							
							
							int count =  sqlSession.update("SQL.Tquar.updateByPrimaryKeySelective", tqr);
							
							if(count == 0){
								sqlSession.insert("SQL.Tquar.insertSelective", tqr);
							}
//							sqlSession.insert("SQL.Tquar.insertSelective", tqr);
						}
					}
				}	
				this.addGoodByWebClientImp(m_strSessionID);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	public void updateGoodByWebClient(String sessionID) {
		this.updateGoodByWebClientImp(sessionID);
	}
	
	private void updateGoodByWebClientImp(String m_strSessionID)  {
		
		try {
			
			int goodId = 0;
			XStream stream = new XStream(new DomDriver());
			stream.processAnnotations(GoodXml.class);
			
			Map<String, Object> params = new HashMap<String,Object>();
			params.put("PackageSize", 100);
			params.put("GoodsIDMin", goodId);

			String goodStr = soapXml.fetchSoapXml("GetIntcpGoodsDataAsXML", m_strSessionID,params);

			if(goodStr.indexOf(DOM_GOOD_BEGIN) != -1){
				String goods = Constants.DOM_PARENT_BEGIN+ goodStr.substring(goodStr.indexOf(DOM_GOOD_BEGIN),(goodStr.lastIndexOf(DOM_GOOD_END)+DOM_GOOD_END.length()) ) +Constants.DOM_PARENT_END;
				System.out.println(goods);
				GoodXml good = (GoodXml) stream.fromXML(goods);
				List<TgoodsXml> lg = good.getList();
				
				for (TgoodsXml g : lg) {

					JSONObject j = JSONObject.fromObject(g);
					Tgoods tg = (Tgoods)BeanUtils.jsonToBeanIgnoreCase(j.toString(),Tgoods.class);
					tg.setENTERDATE(DateUtil.DateString2formatString(tg.getENTERDATE()));
					tg.setFORMDATE(DateUtil.DateString2formatString(tg.getFORMDATE()));
					tg.setQCDATE(DateUtil.DateString2formatString(tg.getQCDATE()));
					tg.setRECEIVEDDATE(DateUtil.DateString2formatString(tg.getRECEIVEDDATE()));
					tg.setTREATDATE(DateUtil.DateString2formatString(tg.getTREATDATE()));
					if(tg.getMARKID() != null && "".equals(tg.getMARKID().trim())){
						tg.setMARKID(null);
					}
					
					int num = updateByPrimaryKeySelective(tg);
					if(num != 0){
						params.put("PackageSize", 100);
						params.put("GoodsIDMin", tg.getID());
						String QuaryStr = soapXml.fetchSoapXml("GetIntcpQuarDataAsXML",m_strSessionID, params);
						if(QuaryStr.indexOf(DOM_TQUAR_BEGIN) != -1){
							String tqx = Constants.DOM_PARENT_BEGIN+ QuaryStr.substring(QuaryStr.indexOf(DOM_TQUAR_BEGIN),(QuaryStr.lastIndexOf(DOM_TQUAR_END)+DOM_TQUAR_END.length()) ) +Constants.DOM_PARENT_END;
							
							XStream q_stream = new XStream(new DomDriver());
							q_stream.processAnnotations(QuarXml.class);
							QuarXml qx = (QuarXml) q_stream.fromXML(tqx);
							List<TquarXml> lt = qx.getList();
							
							for (TquarXml q : lt) {
								
								JSONObject jq = JSONObject.fromObject(q);
								Tquar tqr = (Tquar)BeanUtils.jsonToBeanIgnoreCase(jq.toString(),Tquar.class);
								tqr.setFORMDATE(DateUtil.DateString2formatString(tqr.getFORMDATE()));
								tqr.setINTERDATE(DateUtil.DateString2formatString(tqr.getINTERDATE()));
								
								int count =  sqlSession.update("SQL.Tquar.updateByPrimaryKeySelective", tqr);
								
								if(count == 0){
									sqlSession.insert("SQL.Tquar.insertSelective", tqr);
								}
								
							}
						}
					}
				}	
				this.updateGoodByWebClientImp(m_strSessionID);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
