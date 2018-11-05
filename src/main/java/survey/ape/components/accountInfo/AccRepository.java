package survey.ape.components.accountInfo;

import survey.ape.components.accountInfo.Account;
import org.springframework.data.repository.CrudRepository;

import java.util.Optional;

public interface AccRepository extends CrudRepository<Account, String> {
    Optional<Account> findByEmail(String email);
}
