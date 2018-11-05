package survey.ape.components.invitationInfo;

import javax.persistence.*;
import java.util.UUID;

@Entity
@Table(name = "invitation")
public class Invitation {
    public enum InvitationStatus {
        OPEN,
        SUBMITTED
    }

    public enum InvitationType {
        PUBLIC,
        PRIVATE
    }

    @Id
    @Column(name = "invitation_id")
    private String invitationId;

    @Column(name = "url", nullable = false)
    private String url;

    @Column(name = "to_email", nullable = false)
    private String toEmail;

    @Column(name = "invitation_status", nullable = false)
    private InvitationStatus status;

    @Column(name = "invitation_type", nullable = false)
    private InvitationType type;

    public InvitationType getType() {
        return type;
    }

    public void setType(InvitationType type) {
        this.type = type;
    }

    public String getInvitationId() {
        return invitationId;
    }

    public void setInvitationId(String invitationId) {
        this.invitationId = invitationId;
    }

    public String getToEmail() {
        return toEmail;
    }

    public void setToEmail(String toEmail) {
        this.toEmail = toEmail;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public InvitationStatus getStatus() {
        return status;
    }

    public void setStatus(InvitationStatus status) {
        this.status = status;
    }

    public Invitation() {
        this.invitationId = "invitation_" + UUID.randomUUID().toString().replaceAll("-", "");
        this.url = "http://35.197.100.47:8080";
    }
}
