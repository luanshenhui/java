/**
 * 
 */
package com.f.DAO;

import java.util.List;

import com.f.domain.Repertory;

/**
 * @author 冯学明
 *
 * 2015-2-2下午5:12:32
 * 库存的数据访问对象
 *
 */
public interface RepertoryDAO {
	/**
	 * //添加商品
	 * @param person
	 */
	void add(Repertory repertory);
	/**
	 * //修改商品信息
	 * @param person
	 */
	void update(Repertory repertory);
	/**
	 * //删除商品
	 * @param id
	 */
	void delete(long id);
	/**
	 * //查看商品信息
	 * @param id
	 * @return Person
	 */
	Repertory getByID(long id);
	/**
	 * //查看所有商品
	 * @return list
	 */
	List<Repertory> getAll();

}
