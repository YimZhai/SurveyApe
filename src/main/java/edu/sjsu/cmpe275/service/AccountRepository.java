package edu.sjsu.cmpe275.service;

import edu.sjsu.cmpe275.domain.Account;
import org.springframework.data.repository.CrudRepository;

import java.util.Optional;

public interface AccountRepository extends CrudRepository<Account, String> {
    Optional<Account> findByEmail(String email);
}
