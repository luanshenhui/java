package com.dpn.ciqqlc.standard.service;

import java.util.List;
import java.util.Map;

import com.dpn.ciqqlc.http.form.IntercepeForm;
import com.dpn.ciqqlc.http.form.TravCarryObjForm;
import com.dpn.ciqqlc.standard.model.IntercepeModel;
import com.dpn.ciqqlc.standard.model.SelectModel;
import com.dpn.ciqqlc.standard.model.VideoFileEventModel;

public interface BelongingsService {
		/**
		 * 查询拦截物
		 * */
		List<IntercepeModel> selectIntercepe(Map<String, String> map);
		/**
		 * 查询详细信息
		 * */
		List<IntercepeModel> selectIntercepeDetails(Map<String, String> map);
		
		/**
		 * 查询拦截物移动端
		 * */
		List<IntercepeModel> selectMoveIntercepe(IntercepeForm intercepeForm);
		/**
		 * 查询详细信息移动端
		 * */
		List<IntercepeModel> selectMoveDetails(Map<String, Object> map);
		/**
		 * option
		 * */
		List<SelectModel> allOrgList();

		List<SelectModel> allDepList();
		
		List<SelectModel> allGoodsTypeList();
		/**
		 * insert
		 * */
		void insertItravCarryObj(Map<String, Object> map);
		
		int findIntercepeCount(Map<String, String> map);
		
		List<VideoFileEventModel> videoFileEventList(Map<String, String> map);
		
		void updateItravCarryObj(Map<String, Object> map);
		
		List<IntercepeModel> selectMoveIntercepeByCardNo(
				IntercepeForm intercepeForm);
		
		void updateImgYjwStatus(Map<String, Object> map);
		
		void updateImgBldwStatus(Map<String, Object> map);
		
		String getDzqm(Map<String, String> map);
		
		void insertDzqm(Map<String, Object> paramMap);
				
}
