/**
 * 
 */
package com.f.DAO;

import java.util.List;

import com.f.domain.Roleaction;


/**
 * @author ��ѧ��
 *
 * 2015-2-2����4:55:32
 *��ɫ�����ݷ��ʶ���
 */
public interface RoleactionDAO {
	
	/**
	 * //�鿴��ɫ��Ϣ
	 * @param id
	 * @return Person
	 */
	Roleaction getByID(long id);
	/**
	 * //�鿴��ɫ�û�
	 * @return list
	 */
	List<Roleaction> getAll();
}
