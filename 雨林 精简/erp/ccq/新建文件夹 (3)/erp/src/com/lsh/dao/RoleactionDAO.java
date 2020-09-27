package com.lsh.dao;

import java.util.List;

import com.lsh.domain.Roleaction;


public interface RoleactionDAO {
	/**
	 * 增加角色权限
	 * @param product
	 */
	public abstract void add(Roleaction roleaction);
	/**
	 * 修改角色权限
	 * @param product
	 */
	public abstract void update(Roleaction roleaction);
	
	/**
	 * 删除角色权限
	 * @param product
	 */
	public abstract void delete(Roleaction roleaction);
	
	/**
	 * 根据id查角色权限
	 * @param id
	 * @return
	 */
	public abstract Roleaction getByID(long id);
	
	/**
	 *查询所有角色权限
	 * @return
	 */
	public abstract List<Roleaction> getAll();

}
