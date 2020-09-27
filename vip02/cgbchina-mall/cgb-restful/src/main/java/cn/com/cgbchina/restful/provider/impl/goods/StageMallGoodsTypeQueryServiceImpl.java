/*
 * 
 * Copyright 2016 by www.cgbchina.com.cn All rights reserved.
 * 
 */
package cn.com.cgbchina.restful.provider.impl.goods;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import com.spirit.category.dto.RichCategory;
import com.spirit.category.model.CategoryNode;
import com.spirit.category.model.FrontCategory;
import com.spirit.category.service.CategoryService;
import com.spirit.category.service.Forest;
import com.spirit.category.service.FrontCategoryHierarchy;
import com.spirit.category.service.FrontCategoryService;

import org.apache.regexp.recompile;
import org.springframework.stereotype.Service;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.spirit.common.model.Response;

import cn.com.cgbchina.common.contants.Contants;
import cn.com.cgbchina.rest.common.util.MallReturnCode;
import cn.com.cgbchina.rest.provider.model.goods.StageMallGoodsType;
import cn.com.cgbchina.rest.provider.model.goods.StageMallGoodsTypeQuery;
import cn.com.cgbchina.rest.provider.model.goods.StageMallGoodsTypeQueryReturn;
import cn.com.cgbchina.rest.provider.service.goods.StageMallGoodsTypeQueryService;

import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

/**
 * Description: 接口311 商品类别查询 日期 : 2016-7-26<br>
 * 作者 : xiewl<br>
 * 项目 : cgb-rest<br>
 * 功能 : <br>
 */
@Service
@Slf4j
public class StageMallGoodsTypeQueryServiceImpl implements StageMallGoodsTypeQueryService {

	@Resource
	CategoryService categoryService;
	@Resource
	FrontCategoryService frontCategoryService;
	
	@Override
	public StageMallGoodsTypeQueryReturn query(StageMallGoodsTypeQuery stageMallGoodsTypeQueryObj) {
		StageMallGoodsTypeQueryReturn queryReturn = new StageMallGoodsTypeQueryReturn();
		// TODO 20160728 前台类目没有商城标记以及分区类型
		String mallType = stageMallGoodsTypeQueryObj.getMallType();
		String areaId = stageMallGoodsTypeQueryObj.getAreaId();
		if (Contants.MAll_GF.equals(mallType)) {
			mallType  = "YG";
		} else {
			mallType  = "JF";
		}
		List<StageMallGoodsType> stageMallGoodsTypes = Lists.newArrayList();
		try {
			Map<String, Object> categoryMap = categoryService.assignCategoryService(1, mallType);
			List<RichCategory> richCategories = (List<RichCategory>) categoryMap.get("data");
			if (richCategories != null && !richCategories.isEmpty()) {
				for (RichCategory richCategory : richCategories) {//一级节点
					if (richCategory.getLevel() == 1) {
						richCategory.setParentId(richCategory.getId());
					}
					StageMallGoodsType stageMallGoodsType = convert(richCategory,mallType);
					stageMallGoodsTypes.add(stageMallGoodsType);
					//获取叶子节点
					if (richCategory.isHasChild()) {
						stageMallGoodsTypes = getLeafGoodTypes(stageMallGoodsTypes,richCategory,mallType,richCategory.getId());
					}
				}
			}
			queryReturn.setInfos(stageMallGoodsTypes);
			queryReturn.setReturnCode(MallReturnCode.RETURN_SUCCESS_CODE);
			queryReturn.setReturnDes("");
		} catch (Exception e) {
			queryReturn.setReturnCode(MallReturnCode.RETURN_SYSERROR_CODE);
			queryReturn.setReturnDes(MallReturnCode.RETURN_SYSERROR_MSG);
		}
		return queryReturn;
	}

	/**
	 * Description : 获取叶子节点
	 * @param stageMallGoodsTypes 返回数据
	 * @param richCategory 父节点
	 * @param mallType 商城类型
	 * @param parentId 一级节点id
	 * @return
	 */
	private List<StageMallGoodsType> getLeafGoodTypes(List<StageMallGoodsType> stageMallGoodsTypes,
			RichCategory richCategory, String mallType,Long parentId) {
		Response<List<RichCategory>> childrenResponse =  frontCategoryService.childrenOfNoCache(richCategory.getId(), "");
		if (childrenResponse.isSuccess() && childrenResponse.getResult() != null) {
			for (RichCategory childCategory : childrenResponse.getResult()) {
				if (!childCategory.isHasChild()) {
					childCategory.setParentId(parentId);//将所有叶子节点的父ID设为一级节点的ID
					childCategory.setLevel(2);
					StageMallGoodsType childGoodsType = convert(childCategory,mallType);
					stageMallGoodsTypes.add(childGoodsType);
				}else {
					stageMallGoodsTypes = getLeafGoodTypes(stageMallGoodsTypes,childCategory,mallType,parentId);
				}
			}
		}
		return stageMallGoodsTypes;
	}

	/**
	 * Description : 前台类目转换成返回数据
	 * 
	 * @param category
	 * @return
	 */
	private StageMallGoodsType convert(RichCategory richCategory,String mallType) {
		StageMallGoodsType type = new StageMallGoodsType();
		type.setTypeId(richCategory.getId().toString());
		type.setParentId(richCategory.getParentId().toString());
		type.setOrderTypeId(mallType);
		type.setLevelNm(richCategory.getName());
		type.setLevelCode(String.valueOf(richCategory.getLevel()));
		type.setLevelSeq("");//显示顺序
		type.setLevelDesc("");//商品类别备注
		type.setPictureUrl(richCategory.getIcon());//图片链接
		return type;
	}
}
