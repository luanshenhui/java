package cn.com.cgbchina.item.manager;

import cn.com.cgbchina.item.dao.ProductDao;
import cn.com.cgbchina.item.model.ProductModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

/**
 * Created by Tanliang on 16-4-23.
 */
@Component
@Transactional
public class ProductManager {
	@Autowired
	private ProductDao productDao;

	/**
	 * 新增产品功能
	 * 
	 * @param product
	 * @return
	 */
	public boolean createProduct(ProductModel product) {
		Long productResult = productDao.insert(product);
		// 事物处理
		if (productResult == null) {
			return Boolean.FALSE;
		}
		return Boolean.TRUE;
	}

	/**
	 * 编辑产品功能
	 * 
	 * @param product
	 * @return
	 */
	public boolean editProduct(ProductModel product) {
		Integer productResult = productDao.update(product);
		// 事物处理
		if (productResult != 1) {
			return Boolean.FALSE;
		}
		return Boolean.TRUE;
	}

	/**
	 * 删除产品功能
	 * 
	 * @param id
	 * @return
	 */
	public boolean deleteProduct(Long id) {
		Integer productResult = productDao.deleteProduct(id);
		// 事物处理
		if (productResult != 1) {
			return Boolean.FALSE;
		}
		return Boolean.TRUE;
	}
}
