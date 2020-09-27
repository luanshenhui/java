package com.dhc.base.persistence.ibatis;

import org.springframework.dao.DataAccessException;
import org.springframework.orm.ibatis.support.SqlMapClientDaoSupport;

public class OracleSequenceDao extends SqlMapClientDaoSupport implements SqlMapSequenceDao {

	/**
	 * Get the next sequence using an Oracle thread-safe sequence
	 * 
	 * @param name
	 *            Name is the name of the oracle sequence.
	 * @return the next sequence
	 */
	public int getNextId(String name) throws DataAccessException {
		Sequence sequence = new Sequence();
		sequence.setName(name);
		sequence = (Sequence) getSqlMapClientTemplate().queryForObject("oracleSequence", sequence);
		return sequence.getNextId();
	}

}
