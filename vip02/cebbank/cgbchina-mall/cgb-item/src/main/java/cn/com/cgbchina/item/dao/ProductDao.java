package cn.com.cgbchina.item.dao;

import cn.com.cgbchina.item.dto.ProductDto;
import cn.com.cgbchina.item.model.ProductModel;
import com.google.common.collect.Maps;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import com.spirit.common.model.Pager;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class ProductDao extends SqlSessionDaoSupport {

	public Integer update(ProductModel product) {
		return getSqlSession().update("ProductModel.update", product);
	}

	public List<ProductModel> findAll(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("ProductModel.count", params);
		return getSqlSession().selectList("ProductModel.findAll");
	}

	public ProductModel findById(Long id) {
		return getSqlSession().selectOne("ProductModel.findById", id);
	}

	public Pager<ProductModel> findByPage(Map<String, Object> params, int offset, int limit) {
		Long total = getSqlSession().selectOne("ProductModel.count", params);
		if (total == 0) {
			return Pager.empty(ProductModel.class);
		}
		Map<String, Object> paramMap = Maps.newHashMap();
		if (!params.isEmpty()) {
			paramMap.putAll(params);
		}
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		List<ProductModel> data = getSqlSession().selectList("ProductModel.pagerQuery", paramMap);
		return new Pager<ProductModel>(total, data);
	}

	public Integer delete(ProductModel product) {
		return getSqlSession().delete("ProductModel.delete", product);
	}

	/**
	 * 删除产品（逻辑删除）
	 *
	 * @param id
	 * @return ProductModel.delete 物理删除
	 */
	public Integer deleteProduct(Long id) {
		return getSqlSession().delete("ProductModel.deleteProduct", id);
	}

	/**
	 * 新增产品
	 * 
	 * @param product
	 * @return
	 */
	public Long insert(ProductModel product) {
		getSqlSession().insert("ProductModel.insertProduct", product);
		return product.getId();
	}

	/**
	 * 产品名称重复校验
	 * 
	 * @param productModel
	 * @return
	 */
	public Long findByName(ProductModel productModel) {
		Long total = getSqlSession().selectOne("ProductModel.findNameByName", productModel);
		return total;
	}

	/**
	 * 检索产品列表
	 *
	 * @param params
	 * @return
	 */
	public List<ProductModel> findProductList(Map<String, Object> params) {
		return getSqlSession().selectList("ProductModel.findProductListWithoutPager", params);
	}

	/**
	 * 通过产品ID列表检索产品列表
	 *
	 * @param ids
	 * @return
	 */
	public List<ProductModel> findByIds(List ids) {
		return getSqlSession().selectList("ProductModel.findByIds", ids);
	}

	public ProductModel findProductByName(String name){
		return getSqlSession().selectOne("ProductModel.findProductByName",name);
	}
}