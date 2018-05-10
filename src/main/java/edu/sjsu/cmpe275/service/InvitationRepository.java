package edu.sjsu.cmpe275.service;

import edu.sjsu.cmpe275.domain.Invitation;
import org.springframework.data.repository.CrudRepository;

public interface InvitationRepository extends CrudRepository<Invitation, Long> {
}
