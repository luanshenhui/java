package dao;
/*
 * 1�������ݿ�  
 * 
 * 2 ������
 * ʵ����  entity User  
 * util  DBUtil  Factory
 * ����дdao���ʱ��һ����д�ӿ�  �ٽӿڶ��巽��  ����һ��ʵ��һ��
 * 3 ���� save
 * 4 ���� saveList
 * 5 ������  saveBatch
 * 6 ��ѯ findAll
 * 7 findByUsername
 * 8 ɾ�� delete
 * 9 �޸� update
 * 10��ҳ findByPages
 * 11 getTOtalPage
 * Ҫ��:ÿһ��dao�㷽��д���˶�Ҫ��һ�����Է�����������ԣ�
 */
import java.sql.SQLException;

import entity.User;

public interface UserDAO {
	public abstract void save(User user) throws SQLException;
	
}
