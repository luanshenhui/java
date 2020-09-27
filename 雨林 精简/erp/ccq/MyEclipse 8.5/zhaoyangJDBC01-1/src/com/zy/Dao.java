package com.zy;

public interface Dao {

	Bank findBankByID(int i);

	void update(Bank bank);

	void delete(Bank bank);

}
