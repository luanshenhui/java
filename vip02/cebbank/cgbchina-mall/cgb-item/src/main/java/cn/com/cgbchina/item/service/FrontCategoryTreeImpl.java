package cn.com.cgbchina.item.service;

import cn.com.cgbchina.item.dao.FrontCategoryDao;
import cn.com.cgbchina.item.dto.FrontCategoryNav;
import cn.com.cgbchina.item.dto.FrontCategoryTree;
import cn.com.cgbchina.item.model.CategoryNode;
import cn.com.cgbchina.item.model.FrontCategory;
import com.google.common.base.Splitter;
import com.google.common.base.Strings;
import com.google.common.base.Throwables;
import com.google.common.collect.Lists;
import com.spirit.common.model.Response;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.Collections;
import java.util.List;

/**
 * Created by 郝文佳 on 2016/5/12.
 */
@Service
@Slf4j
public class FrontCategoryTreeImpl implements FrontCategoryTreeService {

	private static Splitter splitter = Splitter.on(',').omitEmptyStrings().trimResults();

	@Resource
	private FrontCategoryDao frontCategoryDao;

	/**
	 * 返回前台类目数据结构
	 * 
	 * @return
	 */
	@Override
	public Response<CategoryNode<FrontCategory>> buildCategoryTree() {
		Response<CategoryNode<FrontCategory>> response = new Response<>();

		FrontCategory virtualParent = new FrontCategory();
		virtualParent.setId(0L);
		virtualParent.setName("所有分类");

		CategoryNode<FrontCategory> virtualRoot = new CategoryNode<>(virtualParent, 0);
		try {
			recursiveBuildCategoryTree(virtualRoot);
			response.setResult(virtualRoot);

		} catch (Exception e) {
			log.error("failed to build category tree, cause:", Throwables.getStackTraceAsString(e));
			response.setError("query.error");
		}
		return response;
	}

	@Override
	public Response<CategoryNode<FrontCategory>> find() {
		return buildCategoryTree();
	}

	/**
	 * 递归构建树结构
	 * 
	 * @param root
	 */
	private void recursiveBuildCategoryTree(CategoryNode<FrontCategory> root) {
		Long id = root.getCategory().getId();
		List<FrontCategory> categories = this.frontCategoryDao.findChildrenById(id);
		for (FrontCategory frontCategory : categories) {
			CategoryNode subTree = new CategoryNode(frontCategory, root.getLevel() + 1);
			root.addChild(subTree);
			recursiveBuildCategoryTree(subTree);
		}
	}

	public Response<List<CategoryNode<FrontCategory>>> buildTreeByIds(String ids) {
		Response<List<CategoryNode<FrontCategory>>> response = new Response<>();
		if (Strings.isNullOrEmpty(ids)) {
			log.warn("no front category ids provided");
			response.setResult(Collections.<CategoryNode<FrontCategory>>emptyList());
			return response;
		}
		List<String> idList = splitter.splitToList(ids);
		List<CategoryNode<FrontCategory>> resultList = Lists.newArrayList();
		try {
			List<FrontCategory> byIds = frontCategoryDao.findByIds(idList);
			CategoryNode<FrontCategory> virtualRoot = null;
			for (FrontCategory frontCategory : byIds) {
				virtualRoot = new CategoryNode<>(frontCategory, 1);
				recursiveBuildCategoryTree(virtualRoot);
				resultList.add(virtualRoot);
			}
			response.setResult(resultList);

		} catch (Exception e) {
			log.error("failed to build category tree, cause:{}", Throwables.getStackTraceAsString(e));
			response.setError("query.error");
		}
		return response;
	}

	@Override
	public Response<List<FrontCategoryTree>> findFrontCategoryByIds(String ids) {
		Response result = new Response();
		if (Strings.isNullOrEmpty(ids)) {
			log.warn("no front category ids provided");
			result.setResult(Collections.emptyList());
			return result;
		}
		try {
			List<String> idList = splitter.splitToList(ids);
			List<FrontCategoryTree> fcts = Lists.newArrayListWithCapacity(idList.size());
			for (String id : idList) {
				FrontCategoryTree fct = new FrontCategoryTree();

				long firstLevelId = Long.parseLong(id);
				FrontCategory firstLevelFC = this.frontCategoryDao.findById(Long.valueOf(firstLevelId));
				if (firstLevelFC == null) {
					log.error("failed to find 1st front category(id={}), skip", id);
					fcts.add(fct);
					continue;
				}
				fct.setFirstId(Long.valueOf(firstLevelId));
				fct.setFirstFrontCategory(firstLevelFC);
				List<FrontCategory> secondLevels = this.frontCategoryDao.findChildrenById(Long.valueOf(firstLevelId));
				List<FrontCategoryNav> fcns = Lists.newArrayListWithCapacity(secondLevels.size());
				for (FrontCategory secondLevel : secondLevels) {
					FrontCategoryNav fcn = new FrontCategoryNav();
					fcn.setSecondLevel(secondLevel);

					List thirdLevels = this.frontCategoryDao.findChildrenById(secondLevel.getId());
					fcn.setThirdLevel(thirdLevels);
					fcns.add(fcn);
				}
				fct.setChildFrontCategory(fcns);
				fcts.add(fct);
			}
			result.setResult(fcts);
			return result;
		} catch (Exception e) {
			log.error("failed to find front category hierarchy by ids {} , cause:{}", ids, Throwables.getStackTraceAsString(e));
			result.setError("frontCategory.query.fail");
		}
		return result;
	}
}
