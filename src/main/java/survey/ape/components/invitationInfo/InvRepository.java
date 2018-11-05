package survey.ape.components.invitationInfo;

import survey.ape.components.invitationInfo.Invitation;
import org.springframework.data.repository.CrudRepository;

public interface InvRepository extends CrudRepository<Invitation, Long> {
}
