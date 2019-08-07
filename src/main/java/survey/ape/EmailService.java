package survey.ape;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import survey.ape.components.invitationInfo.Invitation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Component;

@Component
public class EmailService {
    @Autowired
    public JavaMailSender mailSender;

    public void sendInvitationMail(Invitation invitation) {
        String content = "Survey Invitation: " + invitation.getUrl();
        String subject = "Survey Invitation";
        try {
            MimeMessage mail = mailSender.createMimeMessage();
            mail.setRecipient(Message.RecipientType.TO, new InternetAddress(invitation.getToEmail()));
            mail.setFrom(new InternetAddress("SurveyApe <1234@gmail.com>"));
            mail.setSubject(subject);
            mail.setText(content);
            mailSender.send(mail);
        } catch (MessagingException ex) {
        }
    }

    public void sendVerificationCode(String to, String code){
        try {
            MimeMessage mimeMessage = mailSender.createMimeMessage();
            mimeMessage.setRecipient(Message.RecipientType.TO, new InternetAddress(to));
            mimeMessage.setFrom(new InternetAddress("SurveyApe <1234@gmail.com>"));
            mimeMessage.setSubject("Verification Information");
            mimeMessage.setText("The verification code is: " + code);
            mailSender.send(mimeMessage);
        } catch (MessagingException ex) {
        }
    }

    public void sendSubmitSurveyComfirmMail(String to, String surveyId) {
        MimeMessage mimeMessage = mailSender.createMimeMessage();
        try {
            mimeMessage.setRecipient(Message.RecipientType.TO, new InternetAddress(to));
            mimeMessage.setFrom(new InternetAddress("SurveyApe <1234@gmail.com>"));
            mimeMessage.setSubject("Submit survey Confirmation");
            mimeMessage.setText( "The survey " + surveyId + " has been submitted");
            mailSender.send(mimeMessage);
        } catch (MessagingException ex) {
        }
    }
}
