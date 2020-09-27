package dao;
/*
 * 1创建数据库  
 * 
 * 2 创建表
 * 实体类  entity User  
 * util  DBUtil  Factory
 * 当你写dao层的时候一定先写接口  再接口定义方法  定义一个实现一个
 * 3 插入 save
 * 4 事物 saveList
 * 5 批处理  saveBatch
 * 6 查询 findAll
 * 7 findByUsername
 * 8 删除 delete
 * 9 修改 update
 * 10分页 findByPages
 * 11 getTOtalPage
 * 要求:每一个dao层方法写完了都要有一个测试方法（单体测试）
 */
import java.sql.SQLException;

import entity.User;

public interface UserDAO {
	public abstract void save(User user) throws SQLException;
	
}
