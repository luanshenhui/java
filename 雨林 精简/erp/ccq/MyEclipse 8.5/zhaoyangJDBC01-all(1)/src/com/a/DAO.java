package com.a;

public interface DAO {



	void add(Bank bank);

	Bank findBankID(int i);

	//Bank findBankByID(int i);

	void update(Bank bank);

	void delete(Bank bank);

}
