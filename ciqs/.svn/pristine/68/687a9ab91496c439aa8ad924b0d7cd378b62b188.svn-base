package com.dpn.ciqqlc.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.dpn.ciqqlc.common.util.DateUtil;
import com.dpn.ciqqlc.standard.model.CheckDocsRcdModel;
import com.dpn.ciqqlc.standard.model.OrigPlaceCargoDto;
import com.dpn.ciqqlc.standard.model.OrigPlaceDto;
import com.dpn.ciqqlc.standard.model.UsersDTO;
import com.dpn.ciqqlc.standard.model.VideoEventModel;
import com.dpn.ciqqlc.standard.service.OrigPlaceFlowService;
@Repository("origPlaceServer")
public class OrigPlaceFlow implements OrigPlaceFlowService {

	@Autowired
	@Qualifier("blankSST")
	private SqlSession sqlSession;

	public List<OrigPlaceDto> findorigList(OrigPlaceDto origPlace) throws Exception {
		return sqlSession.selectList("SQL.ORIGPLACE.findorigList", origPlace);
	}

	public int findOrigCount(OrigPlaceDto origPlace) throws Exception{
		return sqlSession.selectOne("SQL.ORIGPLACE.findOrigCount", origPlace);
	}

	public void insertOrigPlace(OrigPlaceDto origPlace) throws Exception {
		sqlSession.selectOne("SQL.ORIGPLACE.insertOrigPlace", origPlace);
	}

	public OrigPlaceDto findOrigById(String id) throws Exception {
		OrigPlaceDto origPlace=new OrigPlaceDto();
		origPlace.setId(id);
		List<OrigPlaceDto> dtoList= sqlSession.selectList("SQL.ORIGPLACE.findOrigById", origPlace);
		OrigPlaceDto dto=null;
		if(null!=dtoList && !dtoList.isEmpty()){
			dto=dtoList.get(0);
		}
//		if(null!=dto){
//			VideoEventModel videoEvent=new VideoEventModel();
//			videoEvent.setProcMainId(dto.getMain_id());
//			List<VideoEventModel> imglist=this.getViewImg(videoEvent);
//			List<VideoEventModel> qvAllList =new ArrayList<VideoEventModel>();
//			List<VideoEventModel>  qvMainList = new ArrayList<VideoEventModel>();
//			List<VideoEventModel>  qvGoodList = new ArrayList<VideoEventModel>();
//			List<VideoEventModel>  qvMatList = new ArrayList<VideoEventModel>();
//			List<VideoEventModel>  qvQianfaList = new ArrayList<VideoEventModel>();
//			List<VideoEventModel>  qvOrderList = new ArrayList<VideoEventModel>();
//			List<VideoEventModel>  qvVideoList =new ArrayList<VideoEventModel>();
//			List<VideoEventModel>  qvCheckCertList =new ArrayList<VideoEventModel>();
//			if(!imglist.isEmpty()){
//				for(VideoEventModel v:imglist){
//					if(v.getProcType().equals("V_OC_C_M_8")){//移动快检照片
//						qvAllList.add(v);
//					}else if(v.getProcType().equals("V_OC_C_M_9")){//主要加工工序
//						qvMainList.add(v);
//					}else if(v.getProcType().equals("V_OC_C_M_3")){//成品
//						qvGoodList.add(v);
//					}else if(v.getProcType().equals("V_OC_C_M_4")){//包装及唛头
//						qvMatList.add(v);
//					}else if(v.getProcType().equals("V_OC_C_M_5")){//签发证书
//						qvQianfaList.add(v);
//					}else if(v.getProcType().equals("V_OC_C_M_7")){//其他材料
//						qvOrderList.add(v);
//					}else if(v.getProcType().equals("V_OC_C_M_10")){//异常或争议视频
//						qvVideoList.add(v);
//					}else if(v.getProcType().equals("V_OC_C_M_11")){//书面调查
//						qvCheckCertList.add(v);
//					}
//				}
//			}
//			dto.setQvAllList(qvAllList);
//			dto.setQvGoodList(qvGoodList);
//			dto.setQvMainList(qvMainList);
//			dto.setQvMatList(qvMatList);
//			dto.setQvQianfaList(qvQianfaList);
//			dto.setQvOrderList(qvOrderList);
//			dto.setQvVideoList(qvVideoList);
//			dto.setQvCheckCertList(qvCheckCertList);
//		}
		return dto;
	}

	public List<VideoEventModel> getViewImg(VideoEventModel videoEvent) {
		List<VideoEventModel> list=sqlSession.selectList("SQL.ORIGPLACE.getViewImg", videoEvent);
		for(VideoEventModel v:list){
			v.setCreateStrDate(DateUtil.DateToString(v.getCreateDate(),"yyyy-MM-dd HH:mm"));
			v.setCreateTime(DateUtil.DateToString(v.getCreateDate(),"yyyy-MM-dd HH:mm:ss"));
			UsersDTO user=sqlSession.selectOne("findUsersByCode", v.getCreateUser());
			if(null!=user){
				v.setCreateUser(user.getName());
			}
		}
		return list;
	}

	public List<OrigPlaceDto> findAppPrigList(OrigPlaceDto origPlace) {
		return sqlSession.selectList("SQL.ORIGPLACE.findOrigById", origPlace);
	}

	public List<CheckDocsRcdModel> getOptionList(CheckDocsRcdModel checkDocsRcd) {
		return sqlSession.selectList("SQL.ORIGPLACE.getOptionList", checkDocsRcd);
	}

	public List<Map<String, String>>  getOrigById(String id) {
		OrigPlaceDto origPlace=new OrigPlaceDto();
		origPlace.setId(id);
		List<Map<String, String>> list= sqlSession.selectList("SQL.ORIGPLACE.getOrigById", origPlace);
		return list;
	
	}

	@Override
	public OrigPlaceDto getOrigPlace(OrigPlaceDto origPlace) {
		return sqlSession.selectOne("SQL.ORIGPLACE.getOrigPlace", origPlace);
	}

	@Override
	public List<OrigPlaceCargoDto> getOrigPlaceCargo(
			OrigPlaceCargoDto origPlaceCargo) {
		return sqlSession.selectList("SQL.ORIGPLACE.getOrigPlaceCargo", origPlaceCargo);
	}

	@Override
	public List<OrigPlaceDto> findOrigByMainId(OrigPlaceDto org) {
		return sqlSession.selectList("SQL.ORIGPLACE.findOrigByMainId", org);
	}

}
